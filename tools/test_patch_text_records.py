import json
import tempfile
import unittest
from pathlib import Path

try:
    from .export_text_records import pointer_targets, record_end
    from .patch_text_records import build_patches
except ImportError:
    from export_text_records import pointer_targets, record_end
    from patch_text_records import build_patches


class TextPatchTests(unittest.TestCase):
    def test_short_record_is_padded_without_changing_capacity(self):
        rom = Path("goemon3.sfc").read_bytes()
        index, start = pointer_targets(rom, 0x03C28F, 27)[0]
        boundaries = sorted({value for _, value in pointer_targets(rom, 0x03C28F, 27)})
        next_boundary = next(value for value in boundaries if value > start)
        end = record_end(rom, start, next_boundary)
        row = {
            "index": index,
            "file_start": f"${start:06X}",
            "file_end": f"${end:06X}",
            "text": "<02><03><00>",
        }
        patches = build_patches(rom, [row])
        self.assertEqual(len(patches), 1)
        self.assertEqual(len(patches[0][1]), end - start)
        self.assertEqual(patches[0][1][:3], b"\x02\x03\x00")


if __name__ == "__main__":
    unittest.main()
