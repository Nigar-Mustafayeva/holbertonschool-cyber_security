whois "$1" | awk ' /^Registrant / { section="Registrant" } /^Admin /      { section="Admin" } /^Tech /     { section="Tech" } '
