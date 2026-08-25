"""Conservatively recompress the confirmed Goemon text stream commands."""

from __future__ import annotations

try:
    from .export_text_records import PREDEFINED
except ImportError:
    from export_text_records import PREDEFINED


DICTIONARY = sorted(
    ((bytes(value), bytes((command,))) for command, value in PREDEFINED.items()),
    key=lambda item: len(item[0]),
    reverse=True,
)


def protected_length(data: bytes, pos: int, end: int) -> int:
    command = data[pos]
    if 0xB0 <= command <= 0xB4:
        return 3 if pos + 3 <= end else 1
    if command == 0xB5:
        terminator = data.find(b"\xFF", pos + 1, end)
        return terminator + 1 - pos if terminator >= 0 else 1
    if command == 0xB7:
        return 2 if pos + 2 <= end else 1
    if command in (0xB6, 0xB8, 0xB9, 0xBA):
        return 1
    return 0


def compress_stream(data: bytes) -> bytes:
    result = bytearray()
    pos = 0
    while pos < len(data):
        protected = protected_length(data, pos, len(data))
        if protected:
            result.extend(data[pos : pos + protected])
            pos += protected
            continue

        for source, command in DICTIONARY:
            if data.startswith(source, pos):
                result.extend(command)
                pos += len(source)
                break
        else:
            value = data[pos]
            if value == 0x18:
                count = 1
                while count < 17 and pos + count < len(data) and data[pos + count] == value:
                    count += 1
                if count >= 2:
                    result.append(0xC0 + count - 2)
                    pos += count
                    continue
            if value >= 0x10:
                count = 1
                while count < 18 and pos + count < len(data) and data[pos + count] == value:
                    count += 1
                if count >= 3:
                    result.extend((0xE0 + count - 3, value))
                    pos += count
                    continue
            result.append(value)
            pos += 1
        continue
    return bytes(result)
