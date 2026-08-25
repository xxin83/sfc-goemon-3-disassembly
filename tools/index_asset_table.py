"""Index the bank $88 resource transfer table without changing the ROM source."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


LABEL_RE = re.compile(r"^(asset_[A-Za-z0-9_]+):\s*$")
ADDR_RE = re.compile(r";\s*\$([0-9A-Fa-f]{6})\b")
DB_RE = re.compile(r"^\s*db\s+\$([0-9A-Fa-f]{2})\b")
DW_RE = re.compile(r"^\s*dw\s+\$([0-9A-Fa-f]{4})(?:\|\$([0-9A-Fa-f]{4}))?\b")
DL_RE = re.compile(r"^\s*dl\s+([^\s;]+)")

TYPE_NAMES = {"00": "VRAM", "01": "WRAM", "02": "SPC", "FF": "SPRITE", "80": "NOP"}


def address(line: str) -> str:
    match = ADDR_RE.search(line)
    return match.group(1).upper() if match else ""


def parse(path: Path) -> list[dict[str, str]]:
    lines = path.read_text(encoding="utf-8").splitlines()
    rows: list[dict[str, str]] = []
    asset = ""
    asset_addr = ""
    resource_type = ""
    mode = ""
    pending_destination = ""
    pending_address = ""
    expect_mode = False

    for line in lines:
        label = LABEL_RE.match(line)
        if label:
            asset = label.group(1)
            asset_addr = ""
            resource_type = ""
            mode = ""
            pending_destination = ""
            pending_address = ""
            expect_mode = False
            continue
        if not asset:
            continue

        line_addr = address(line)
        db = DB_RE.match(line)
        if db:
            code = db.group(1).upper()
            if expect_mode and code in {"00", "01", "02"}:
                mode = "deferred" if code == "01" else "normal"
                expect_mode = False
                continue
            if not resource_type and code in TYPE_NAMES:
                resource_type = TYPE_NAMES[code]
                if not asset_addr:
                    asset_addr = line_addr
                pending_destination = ""
                pending_address = ""
                expect_mode = resource_type in {"VRAM", "WRAM", "SPC"}
                if resource_type in {"VRAM", "WRAM", "SPC"}:
                    mode = "deferred" if code == "01" else "normal"
                continue
            if resource_type in {"VRAM", "WRAM", "SPC"} and code == "FF":
                resource_type = ""
                pending_destination = ""
                pending_address = ""
                expect_mode = False
                continue
            if code in TYPE_NAMES:
                resource_type = TYPE_NAMES[code]
                pending_destination = ""
                pending_address = ""
                expect_mode = resource_type in {"VRAM", "WRAM", "SPC"}
                if resource_type in {"VRAM", "WRAM", "SPC"}:
                    mode = "deferred" if code == "01" else "normal"
                continue
        if not asset_addr and line_addr:
            asset_addr = line_addr
        if not resource_type:
            continue

        if resource_type == "VRAM":
            dw = DW_RE.match(line)
            if dw:
                pending_destination = "$" + dw.group(1).upper()
                pending_address = line_addr
                continue
            dl = DL_RE.match(line)
            if dl and pending_destination:
                rows.append({
                    "asset": asset,
                    "asset_address": "$" + asset_addr if asset_addr else "",
                    "type": resource_type,
                    "mode": mode,
                    "destination": pending_destination,
                    "source": dl.group(1),
                    "entry_address": "$" + pending_address if pending_address else "",
                })
                pending_destination = ""
                pending_address = ""
        elif resource_type == "WRAM":
            dl = DL_RE.match(line)
            if dl:
                if not pending_destination:
                    pending_destination = dl.group(1)
                    pending_address = line_addr
                else:
                    rows.append({
                        "asset": asset,
                        "asset_address": "$" + asset_addr if asset_addr else "",
                        "type": resource_type,
                        "mode": mode,
                        "destination": pending_destination,
                        "source": dl.group(1),
                        "entry_address": "$" + pending_address if pending_address else "",
                    })
                    pending_destination = ""
                    pending_address = ""
        elif resource_type == "SPC":
            dl = DL_RE.match(line)
            if dl:
                if not pending_destination:
                    pending_destination = dl.group(1)
                    pending_address = line_addr
                else:
                    rows.append({
                        "asset": asset,
                        "asset_address": "$" + asset_addr if asset_addr else "",
                        "type": resource_type,
                        "mode": mode,
                        "destination": pending_destination,
                        "source": dl.group(1),
                        "entry_address": "$" + pending_address if pending_address else "",
                    })
                    pending_destination = ""
                    pending_address = ""
        elif resource_type == "SPRITE":
            dl = DL_RE.match(line)
            if dl:
                pending_destination = dl.group(1)
                pending_address = line_addr
                continue
            dw = DW_RE.match(line)
            if dw and pending_destination:
                rows.append({
                    "asset": asset,
                    "asset_address": "$" + asset_addr if asset_addr else "",
                    "type": resource_type,
                    "mode": "last" if dw.group(2) else "",
                    "destination": "$" + dw.group(1).upper(),
                    "source": pending_destination,
                    "entry_address": "$" + pending_address if pending_address else "",
                })
                pending_destination = ""
                pending_address = ""

        if line_addr and not asset_addr:
            asset_addr = line_addr
    return rows


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, nargs="?", default=Path("disassembly/bank_88.asm"))
    parser.add_argument("output", type=Path, nargs="?", default=Path("docs/resource-index.tsv"))
    args = parser.parse_args()
    rows = parse(args.source)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    fields = ["asset", "asset_address", "type", "mode", "destination", "source", "entry_address"]
    with args.output.open("w", encoding="utf-8", newline="") as stream:
        stream.write("\t".join(fields) + "\n")
        for row in rows:
            stream.write("\t".join(row[field] for field in fields) + "\n")
    print(f"indexed {len(rows)} transfer entries from {args.source} -> {args.output}")


if __name__ == "__main__":
    main()
