whois "$1" | awk '
/^Registrant / { section="Registrant" }
/^Admin /      { section="Admin" }
section != "" && /Name:/ && NR<=2 {
    printf "%s Name,%s\n", section, substr($0, index($0, ":")+2)
}
'
