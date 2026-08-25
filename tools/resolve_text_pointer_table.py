"""Resolve the known Goemon 3 text pointer table and nested copy references.

The table stores 16-bit text offsets.  The text stream can contain F0-FF
commands whose two-byte argument is a character-data source offset, so a flat
pointer dump is not sufficient for this game.
"""

from __future__ import annotations

import argparse
from pathlib import Path


TABLE_FILE_OFFSET = 0x03C28F
TABLE_CPU_ADDRESS = 0x87C28F
TABLE_COUNT = 27
DEFAULT_WINDOW = 0x100


def text_offset_to_file(offset: int) -> int:
    offset &= 0xFFFF
    if offset < 0x8000:
        return 0x1B0000 + offset
    return 0x1E0000 + (offset - 0x8000)


def text_offset_to_snes(offset: int) -> int:
    offset &= 0xFFFF
    if offset < 0x8000:
        return 0xB68000 + offset
    return 0xBD0000 + offset


def scan_nested_offsets(data: bytes, start: int, window: int):
    """Return copy-source offsets without pretending every byte is text.

    F0-FF is documented as a three-byte copy command.  B5 is retained as an
    observed special command with a two-byte argument.  Other B0-BF bytes are
    formatting commands in this stream and are not treated as pointers without
    runtime evidence.
    The scan is bounded because records are not all sorted by offset.
    """
    end = min(len(data), start + window)
    pos = start
    edges = []
    while pos < end:
        command = data[pos]
        if 0xF0 <= command <= 0xFF and pos + 2 < end:
            target = data[pos + 1] | (data[pos + 2] << 8)
            edges.append((pos - start, command, target, "copy"))
            pos += 3
        elif command == 0xB5 and pos + 2 < end:
            target = data[pos + 1] | (data[pos + 2] << 8)
            edges.append((pos - start, command, target, "special"))
            pos += 3
        elif 0xE0 <= command <= 0xEF:
            pos += 2
        else:
            pos += 1
    return edges


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("rom", type=Path)
    parser.add_argument("--table", type=lambda value: int(value, 0), default=TABLE_FILE_OFFSET)
    parser.add_argument("--count", type=int, default=TABLE_COUNT)
    parser.add_argument("--window", type=lambda value: int(value, 0), default=DEFAULT_WINDOW)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    data = args.rom.read_bytes()
    lines = [
        "index\ttable_file\ttable_snes\toffset\ttarget_snes\ttarget_file\thead\tkind\tnested_offset\tnested_snes\tnested_file",
    ]

    for index in range(args.count):
        table_pos = args.table + index * 2
        offset = data[table_pos] | (data[table_pos + 1] << 8)
        target_file = text_offset_to_file(offset)
        target_snes = text_offset_to_snes(offset)
        head = data[target_file:target_file + 16].hex(" ").upper()
        edges = scan_nested_offsets(data, target_file, args.window)

        if not edges:
            lines.append(
                f"{index}\t${table_pos:06X}\t${TABLE_CPU_ADDRESS + index * 2:06X}\t"
                f"${offset:04X}\t${target_snes:06X}\t${target_file:06X}\t{head}\t\t\t\t"
            )
            continue

        for relative, command, nested, kind in edges:
            nested_file = text_offset_to_file(nested)
            nested_snes = text_offset_to_snes(nested)
            lines.append(
                f"{index}\t${table_pos:06X}\t${TABLE_CPU_ADDRESS + index * 2:06X}\t"
                f"${offset:04X}\t${target_snes:06X}\t${target_file:06X}\t{head}\t"
                f"{kind}:0x{command:02X}\t${nested:04X}\t${nested_snes:06X}\t${nested_file:06X}"
            )

    output = "\n".join(lines) + "\n"
    if args.output:
        args.output.write_text(output, encoding="utf-8")
    else:
        print(output, end="")


if __name__ == "__main__":
    main()
