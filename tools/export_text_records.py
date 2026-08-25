"""Export Goemon 3 text records with loss-aware command markup.

Records are bounded by the next distinct pointer-table target.  Confirmed
compression commands are expanded; commands whose visual meaning is still
context-dependent are emitted as tags instead of being guessed as text.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path


TABLE_FILE_OFFSET = 0x03C28F
TABLE_COUNT = 27


def text_offset_to_file(offset: int) -> int:
    offset &= 0xFFFF
    if offset < 0x8000:
        return 0x1B0000 + offset
    return 0x1E0000 + offset - 0x8000


# Verified single-byte glyphs from the current font/code table.  Unknown
# values remain visible as <XX> so an export is never silently lossy.
GLYPHS = {
    0x04: "\\n",
    0x16: "<NORMAL>",
    0x17: "<RED>",
    0x18: " ",
    0x1A: "あ", 0x1B: "い", 0x1C: "う", 0x1D: "え", 0x1E: "お",
    0x1F: "か", 0x20: "き", 0x21: "く", 0x22: "け", 0x23: "こ",
    0x24: "さ", 0x25: "し", 0x26: "す", 0x27: "せ", 0x28: "そ",
    0x29: "た", 0x2A: "ち", 0x2B: "つ", 0x2C: "て", 0x2D: "と",
    0x2E: "な", 0x2F: "に", 0x30: "ぬ", 0x31: "ね", 0x32: "の",
    0x33: "は", 0x34: "ひ", 0x35: "ふ", 0x36: "へ", 0x37: "ほ",
    0x38: "ま", 0x39: "み", 0x3A: "む", 0x3B: "め", 0x3C: "も",
    0x3D: "や", 0x3E: "ゆ", 0x3F: "よ", 0x40: "ら", 0x41: "り",
    0x42: "る", 0x43: "れ", 0x44: "ろ", 0x45: "わ", 0x46: "を",
    0x47: "ん", 0x48: "っ", 0x49: "ゃ", 0x4A: "ゅ", 0x4B: "ょ",
    0x4C: "ぉ", 0x4D: "重", 0x4E: "禄", 0x4F: "兵", 0x50: "衛",
    0x51: "<51>", 0x52: "◀", 0x53: "▶", 0x54: "▲", 0x55: "▼",
    0x58: "０", 0x59: "１", 0x5A: "２", 0x5B: "３", 0x5C: "４",
    0x5D: "５", 0x5E: "６", 0x5F: "７", 0x60: "８", 0x61: "９",
    0x68: "コ", 0x69: "エ", 0x6A: "モ", 0x6B: "ン", 0x6C: "ヒ",
    0x6D: "ス", 0x6E: "サ", 0x6F: "ケ", 0x70: "ヤ", 0x74: "両",
    0x75: "丸", 0x76: "ー", 0x77: "金", 0x78: "・", 0x79: "？",
    0x7A: "！", 0x7B: "「", 0x7C: "」", 0x81: "。", 0x82: "（",
    0x83: "）", 0x88: "が", 0x89: "ぎ", 0x8A: "ぐ", 0x8B: "げ",
    0x8C: "ご", 0x8D: "ざ", 0x8E: "じ", 0x8F: "ず", 0x90: "ぜ",
    0x91: "ぞ", 0x92: "だ", 0x93: "ぢ", 0x94: "づ", 0x95: "で",
    0x96: "ど", 0x97: "ば", 0x98: "び", 0x99: "ぶ", 0x9A: "べ",
    0x9B: "ぼ", 0x9C: "ゴ", 0x9D: "ビ", 0x9E: "ズ", 0x9F: "ザ",
    0xA0: "ゲ", 0xA8: "ぱ", 0xA9: "ぴ", 0xAA: "ぷ", 0xAB: "ぺ",
    0xAC: "ぽ", 0xAD: "ピ",
}

DEFAULT_GLYPHS = GLYPHS
CODE_TABLE_PATH = Path(__file__).resolve().parent.parent / "data" / "text-code-table.json"
if CODE_TABLE_PATH.exists():
    GLYPHS = {int(code, 16): value for code, value in json.loads(CODE_TABLE_PATH.read_text(encoding="utf-8")).items()}


PREDEFINED = {
    0xD0: [0x24, 0x29, 0x81, 0x7C, 0x04],
    0xD1: [0x7A, 0x7C, 0x04],
    0xD2: [0x81, 0x7C, 0x04],
    0xD3: [0x7C, 0x04],
    0xD4: [0x9C, 0x69, 0x6A, 0x6B, 0x18, 0x7B],
    0xD5: [0x69, 0x9D, 0x6D, 0x75, 0x18, 0x7B],
    0xD6: [0x6E, 0x6D, 0x6F, 0x18, 0x18, 0x7B],
    0xD7: [0x70, 0x69, 0x18, 0x18, 0x18, 0x7B],
    0xD8: [0x78, 0x78, 0x78],
    0xD9: [0x18] * 6,
    0xDA: [0x18] * 5,
    0xDB: [0x18] * 4,
    0xDC: [0x18] * 3,
    0xDD: [0x18] * 2,
    0xDE: [0x33, 0x47],
    0xDF: [0x8C, 0x8D, 0x42],
}


def glyph(value: int) -> str:
    return GLYPHS.get(value, f"<{value:02X}>")


def decode_char_bytes(values: bytes) -> str:
    return "".join(glyph(value) for value in values)


def decode_stream(data: bytes, start: int, end: int) -> str:
    out: list[str] = []
    pos = start
    while pos < end:
        command = data[pos]
        if command == 0x00:
            out.append("<00>")
            pos += 1
        elif command < 0xB0:
            out.append(glyph(command))
            pos += 1
        elif command == 0xB5:
            descriptor_end = data.find(b"\xff", pos + 1, end)
            if descriptor_end < 0:
                out.append("<B5:unterminated>")
                pos += 1
            else:
                raw = data[pos + 1 : descriptor_end + 1].hex().upper()
                out.append(f"<B5:{raw}>")
                pos = descriptor_end + 1
        elif command == 0xB7 and pos + 1 < end:
            out.append(f"<B7:{data[pos + 1]:02X}>")
            pos += 2
        elif 0xB0 <= command <= 0xB4 and pos + 2 < end:
            value = data[pos + 1] | (data[pos + 2] << 8)
            out.append(f"<B{command - 0xB0:X}:{value:04X}>")
            pos += 3
        elif command in (0xB8, 0xB9, 0xBA, 0xB6):
            out.append(f"<{command:02X}>")
            pos += 1
        elif 0xC0 <= command <= 0xCF:
            out.append(" " * (command - 0xC0 + 2))
            pos += 1
        elif 0xD0 <= command <= 0xDF:
            out.append(decode_char_bytes(bytes(PREDEFINED.get(command, []))))
            pos += 1
        elif 0xE0 <= command <= 0xEF and pos + 1 < end:
            out.append(glyph(data[pos + 1]) * (command - 0xE0 + 3))
            pos += 2
        elif 0xF0 <= command <= 0xFF and pos + 2 < end:
            target = data[pos + 1] | (data[pos + 2] << 8)
            count = command - 0xF0 + 4
            target_file = text_offset_to_file(target)
            copied = data[target_file : target_file + count]
            out.append(decode_char_bytes(copied))
            pos += 3
        else:
            out.append(f"<{command:02X}:truncated>")
            pos += 1
    return "".join(out)


def pointer_targets(data: bytes, table: int, count: int) -> list[tuple[int, int]]:
    targets = []
    for index in range(count):
        offset = int.from_bytes(data[table + index * 2 : table + index * 2 + 2], "little")
        targets.append((index, text_offset_to_file(offset)))
    return targets


def record_end(data: bytes, start: int, next_boundary: int) -> int:
    """Use the explicit final marker only when no later table target exists."""
    if next_boundary < len(data):
        return next_boundary
    terminator = data.find(b"\x03\x00", start, min(len(data), start + 0x1000))
    return terminator + 2 if terminator >= 0 else next_boundary


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("rom", type=Path)
    parser.add_argument("--table", type=lambda value: int(value, 0), default=TABLE_FILE_OFFSET)
    parser.add_argument("--count", type=int, default=TABLE_COUNT)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    data = args.rom.read_bytes()
    targets = pointer_targets(data, args.table, args.count)
    boundaries = sorted({file_offset for _, file_offset in targets})
    rows = []
    for index, start in targets:
        next_boundary = next((value for value in boundaries if value > start), len(data))
        next_boundary = record_end(data, start, next_boundary)
        offset = int.from_bytes(data[args.table + index * 2 : args.table + index * 2 + 2], "little")
        rows.append({
            "index": index,
            "offset": f"${offset:04X}",
            "file_start": f"${start:06X}",
            "file_end": f"${next_boundary:06X}",
            "raw": data[start:next_boundary].hex(" ").upper(),
            "text": decode_stream(data, start, next_boundary),
        })
    args.output.write_text("\n".join(json.dumps(row, ensure_ascii=False) for row in rows) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
