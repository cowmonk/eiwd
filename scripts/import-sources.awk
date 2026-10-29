# Read the upstream source assignments, including their continuation lines.
function assignment(line,    key) {
	if (line !~ /^[A-Za-z_][A-Za-z_0-9]*[ \t]*[+:?]?=/)
		return
	key = line
	sub(/[ \t]*[+:?]?=.*/, "", key)
	if (key !~ /^(ell_sources|ell_headers|ell_shared|eap_sources|src_iwd_SOURCES|monitor_iwmon_SOURCES|unit_test_.*_SOURCES)$/ || key == "unit_test_client_SOURCES")
		return
	if (line !~ /^[A-Za-z_][A-Za-z_0-9]*[ \t]*=/ || key in values) {
		print "review changed upstream assignment: " key > "/dev/stderr"
		bad = 1
		return
	}
	sub(/^[^=]*=[ \t]*/, "", line)
	values[key] = line
	if (key ~ /^unit_test_.*_SOURCES$/ && key != "unit_test_client_SOURCES")
		tests[++ntests] = key
}

function emit(name, value, suffix,    n, words, i, file, count, seen) {
	# All supported references are expanded explicitly. A new upstream
	# reference must be reviewed instead of silently dropping its sources.
	gsub(/\$\(eap_sources\)/, values["eap_sources"], value)
	gsub(/\$\(builtin_sources\)/, "", value)
	n = split(value, words, /[ \t]+/)
	printf "%s =", name
	for (i = 1; i <= n; i++) {
		file = words[i]
		if (file ~ /\$/) {
			print "unsupported upstream source reference: " file > "/dev/stderr"
			bad = 1
		}
		if (file !~ suffix || seen[file]++)
			continue
		if (name ~ /^ELL_/)
			sub(/^ell\//, "$(ELL_DIR)/ell/", file)
		printf " \\\n\t%s", file
		count++
	}
	printf "\n\n"
	if (!count) {
		print "empty upstream source list: " name > "/dev/stderr"
		bad = 1
	}
}

{
	line = line $0
	if (sub(/\\[ \t]*$/, " ", line))
		next
	assignment(line)
	line = ""
}

END {
	print "# Imported by scripts/import-upstream; review changes when updating iwd."
	print "VERSION = " version "\n"
	emit("ELL_SRC", values["ell_sources"], "\\.c$")
	emit("ELL_HEADERS", values["ell_headers"] " " values["ell_sources"] " " values["ell_shared"], "\\.h$")
	emit("IWD_SRC", values["src_iwd_SOURCES"], "\\.c$")
	emit("MONITOR_SRC", values["monitor_iwmon_SOURCES"], "\\.c$")
	emit("HEADERS", values["src_iwd_SOURCES"] " " values["monitor_iwmon_SOURCES"], "\\.h$")
	printf "ELL_OBJ ="
	n = split(values["ell_sources"], words, /[ \t]+/)
	for (i = 1; i <= n; i++) {
		if (words[i] !~ /\.c$/)
			continue
		file = words[i]
		sub(/^ell\//, "build/ell/", file)
		sub(/\.c$/, ".o", file)
		printf " \\\n\t%s", file
		deps = deps file ": $(ELL_DIR)/" words[i] "\n"
	}
	print "\n\n" deps
	printf "TESTS ="
	for (i = 1; i <= ntests; i++) {
		name = tests[i]
		sub(/^unit_test_/, "unit/test-", name)
		sub(/_SOURCES$/, "", name)
		gsub(/_/, "-", name)
		targets[i] = name
		printf " \\\n\t%s", name
	}
	print "\n"
	for (j = 1; j <= ntests; j++) {
		name = tests[j]
		sub(/_SOURCES$/, "_OBJ", name)
		emit(name, values[tests[j]], "\\.c$")
		# Convert only the emitted source variable at its point of use.
		printf "%s: $(%s:.c=.o) libell.a\n", targets[j], name
		printf "\t$(CC) $(LDFLAGS) -o $@ $(%s:.c=.o)", name
		if (targets[j] == "unit/test-sae")
			printf " -Wl,-wrap,l_ecc_supported_ike_groups"
		print " libell.a $(LDLIBS)\n"
		objects = objects " \\\n\t$(" name ":.c=.o)"
	}
	print "TEST_OBJ =" objects "\n"
	if (bad || !ntests)
		exit 1
}
