import unittest
from unittest.mock import patch

try:
    from . import analyze_single_byte_slots as slots
except ImportError:
    import analyze_single_byte_slots as slots


class SingleByteSlotTests(unittest.TestCase):
    def test_classifies_reserved_available_and_occupied(self):
        rows = [
            {"code": "$00", "glyph": "<00>", "tile_words": ["$0300", "$0300"]},
            {"code": "$01", "glyph": "<01>", "tile_words": ["$0300", "$0300"]},
            {"code": "$02", "glyph": "<02>", "tile_words": ["$0301", "$0311"]},
            {"code": "$03", "glyph": "X", "tile_words": ["$0300", "$0300"]},
        ]
        with patch.object(slots, "export", return_value=rows), patch.object(
            slots, "GLYPHS", {0x03: "X"}
        ):
            result = slots.classify(b"")
        self.assertEqual([row["code"] for row in result["reserved"]], ["$00"])
        self.assertEqual([row["code"] for row in result["available"]], ["$01"])
        self.assertEqual(
            [row["code"] for row in result["occupied"]], ["$02", "$03"]
        )


if __name__ == "__main__":
    unittest.main()
