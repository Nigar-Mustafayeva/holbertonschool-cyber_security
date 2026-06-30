# Escape the Blacklist:

## Overview

When systems rely on **blacklisting** (blocking specific keywords or characters), they are often vulnerable to bypass techniques. Since it is difficult to anticipate every possible variation an attacker might use, these filters can frequently be evaded through shell features or command obfuscation.

> **Note:** These examples are intended for educational use in authorized security labs and penetration testing environments.
> 

---

## Common Blacklist Bypass Techniques

### 1. Wildcards ( and `?`)

Wildcards can replace one or more characters in filenames or command names, allowing commands to execute even when exact strings are filtered.

**Example**

```bash
cat home/user/?lag
```

In Task 0, this technique was used to read the `flag` file without typing its full name.

---

### 2. Alternate Separators (`${IFS}`)

The shell's **Internal Field Separator (IFS)** can be used instead of spaces, which may bypass simple regular-expression filters.

**Example**

```bash
cat${IFS}home/user/?lag
```

In Task 1, `${IFS}` replaced the normal space between the command and its argument.

---

### 3. Encoding

Commands can be encoded (for example, using Base64 or hexadecimal) and then decoded at execution time. This can prevent blacklist filters from matching restricted strings directly.

---

### 4. Character Sets (`[chars]`)

Character classes allow individual characters to be matched while avoiding exact string matches.

**Example**

```bash
/usr/bin/cat /e[t]c/[p]assw[d]
```

Instead of writing the complete path directly, selected characters are enclosed in brackets.

---

### 5. Quotes

Individual characters can be wrapped in quotes while still being interpreted as the same command by the shell.

**Example**

```bash
'p''i''n''g'
```

The shell concatenates the quoted characters into a single command.

---

### 6. Backslashes

Backslashes can escape individual characters while preserving the command's meaning.

**Example**

```bash
\u\n\a\m\e -\a
```

This executes the equivalent of:

```bash
uname -a
```

---

### 7. `$@`

The special parameter `$@` can sometimes be used within commands while still producing the intended command name.

**Example**

```bash
who$@ami
```

This is interpreted as:

```bash
whoami
```

---

## Summary

Blacklists are generally an unreliable security mechanism because shell parsing and expansion provide many alternate ways to represent the same command. A more secure approach is to use **allowlists**, proper input validation, and avoid executing user-controlled input whenever possible.
