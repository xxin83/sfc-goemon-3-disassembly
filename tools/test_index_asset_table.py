"""Regression checks for the bank $88 transfer-table indexer."""

from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent))
from index_asset_table import parse


ROOT = Path(__file__).resolve().parents[1]
ROWS = parse(ROOT / "disassembly/bank_88.asm")


def test_shape() -> None:
    assert len(ROWS) == 4538
    assert len({row["asset"] for row in ROWS}) == 963


def test_known_vram_and_sprite_records() -> None:
    logo = [row for row in ROWS if row["asset"] == "asset_logo_and_icons"]
    assert logo[0] == {
        "asset": "asset_logo_and_icons",
        "asset_address": "$888000",
        "type": "VRAM",
        "mode": "normal",
        "destination": "$2000",
        "source": "VRAM_968000",
        "entry_address": "$888002",
    }
    sprite = [row for row in ROWS if row["asset"] == "asset_logo_sprites"]
    assert sprite[0]["type"] == "SPRITE"
    assert sprite[0]["source"] == "SPRITE_96A203"
    assert sprite[0]["mode"] == "last"


def test_known_wram_record() -> None:
    rows = [row for row in ROWS if row["asset"] == "asset_8880E3"]
    assert rows[0]["type"] == "WRAM"
    assert rows[0]["destination"] == "$7F0000"
    assert rows[0]["source"] == "FILE_87F89D"


if __name__ == "__main__":
    for test in (test_shape, test_known_vram_and_sprite_records, test_known_wram_record):
        test()
    print("asset table checks passed")
