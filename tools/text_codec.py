"""Encode the loss-aware markup emitted by export_text_records.py."""

from __future__ import annotations

import re

try:
    from .export_text_records import GLYPHS
except ImportError:
    from export_text_records import GLYPHS


REVERSE_GLYPHS = {}
for _code, _glyph in GLYPHS.items():
    if len(_glyph) == 1 and _glyph not in REVERSE_GLYPHS:
        REVERSE_GLYPHS[_glyph] = _code


def encode_tag(tag: str) -> bytes:
    if tag == "NORMAL":
        return b"\x16"
    if tag == "RED":
        return b"\x17"
    if re.fullmatch(r"[0-9A-Fa-f]{2}", tag):
        return bytes([int(tag, 16)])
    match = re.fullmatch(r"B([0-4]):([0-9A-Fa-f]{4})", tag)
    if match:
        value = int(match.group(2), 16)
        return bytes([0xB0 + int(match.group(1)), value & 0xFF, value >> 8])
    match = re.fullmatch(r"B5:([0-9A-Fa-f]+)", tag)
    if match:
        payload = bytes.fromhex(match.group(1))
        return b"\xB5" + payload
    match = re.fullmatch(r"B7:([0-9A-Fa-f]{2})", tag)
    if match:
        return bytes((0xB7, int(match.group(1), 16)))
    if tag in {"B6", "B8", "B9", "BA"}:
        return bytes((int(tag, 16),))
    raise ValueError(f"unsupported text tag: <{tag}>")


def encode_markup(text: str) -> bytes:
    """Encode text and explicit decoder tags without guessing unknown glyphs."""
    result = bytearray()
    pos = 0
    while pos < len(text):
        if text.startswith("\\n", pos):
            result.append(0x04)
            pos += 2
            continue
        if text[pos] == "<":
            end = text.find(">", pos + 1)
            if end < 0:
                raise ValueError("unterminated text tag")
            result.extend(encode_tag(text[pos + 1 : end]))
            pos = end + 1
            continue
        try:
            result.append(REVERSE_GLYPHS[text[pos]])
        except KeyError as exc:
            raise ValueError(f"glyph is not in the single-byte table: {text[pos]!r}") from exc
        pos += 1
    return bytes(result)
