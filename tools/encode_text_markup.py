"""Encode one exported text field to a hexadecimal byte stream."""

from __future__ import annotations

import argparse

try:
    from .text_codec import encode_markup
except ImportError:
    from text_codec import encode_markup


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("text")
    args = parser.parse_args()
    print(encode_markup(args.text).hex(" ").upper())


if __name__ == "__main__":
    main()
