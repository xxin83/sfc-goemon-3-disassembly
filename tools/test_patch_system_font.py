import unittest

from .patch_system_font import FONT_CAPACITY, patch_font


class SystemFontPatchTests(unittest.TestCase):
    def test_original_font_fits(self):
        rom = bytes(0xC0000)
        font = bytes(0x600)
        patched = patch_font(rom, font)
        self.assertEqual(len(patched), len(rom))

    def test_oversized_compressed_font_is_rejected(self):
        rom = bytes(0xC0000)
        state = 0x12345678
        values = []
        for _ in range(0x600):
            state = (state * 1103515245 + 12345) & 0xFFFFFFFF
            values.append((state >> 16) & 0xFF)
        font = bytes(values)
        with self.assertRaises(ValueError):
            patch_font(rom, font)


if __name__ == "__main__":
    unittest.main()
