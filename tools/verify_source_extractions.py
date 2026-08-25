"""Verify extracted db source bytes against the original bank assets."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


ADDRESS_RE = re.compile(r";\s*\$([0-9A-Fa-f]{6})\b")
BYTE_RE = re.compile(r"\$([0-9A-Fa-f]{2})")


def verify(root: Path) -> tuple[int, list[str]]:
    checked = 0
    errors: list[str] = []
    for source in sorted((root / "disassembly").glob("data_*.asm")):
        for line_number, line in enumerate(source.read_text(encoding="utf-8").splitlines(), 1):
            address = ADDRESS_RE.search(line)
            if not address or "db" not in line.lower():
                continue
            values = BYTE_RE.findall(line.split(";", 1)[0])
            if not values:
                continue
            snes_address = int(address.group(1), 16)
            bank = (snes_address >> 16) & 0xFF
            bank_path = root / "assets" / f"bank_{bank:02X}.bin"
            if not bank_path.exists():
                errors.append(f"{source}:{line_number}: missing {bank_path.name}")
                continue
            offset = snes_address - ((bank << 16) | 0x8000)
            raw = bank_path.read_bytes()
            expected = bytes.fromhex("".join(values))
            actual = raw[offset : offset + len(expected)]
            checked += len(expected)
            if actual != expected:
                errors.append(
                    f"{source}:{line_number}: ${snes_address:06X} "
                    f"expected {actual.hex()} got {expected.hex()}"
                )
    return checked, errors


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", type=Path, nargs="?", default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    checked, errors = verify(args.root)
    if errors:
        print("\n".join(errors))
        raise SystemExit(1)
    print(f"verified {checked} extracted source bytes")


if __name__ == "__main__":
    main()
