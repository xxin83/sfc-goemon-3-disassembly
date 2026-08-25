import unittest

try:
    from .relocate_system_font import (
        FONT_POINTER_CPU,
        ROM_SIZE_HEADER,
        file_offset_to_cpu,
        patch_relocated_font,
    )
    from .export_glyph_map import lorom_file_offset
except ImportError:
    from relocate_system_font import (
        FONT_POINTER_CPU,
        ROM_SIZE_HEADER,
        file_offset_to_cpu,
        patch_relocated_font,
    )
    from export_glyph_map import lorom_file_offset


class RelocateFontTests(unittest.TestCase):
    def test_file_offset_to_lorom_cpu(self):
        self.assertEqual(file_offset_to_cpu(0x3F0000), 0xFE8000)

    def test_expands_rom_and_updates_pointer(self):
        rom = bytes(0x200000)
        font = bytes(0x600)
        result = patch_relocated_font(rom, font, 0x200000)
        self.assertEqual(len(result), 0x400000)
        pointer_file = lorom_file_offset(FONT_POINTER_CPU)
        self.assertEqual(result[pointer_file : pointer_file + 3], bytes.fromhex("00 80 C0"))
        self.assertEqual(result[ROM_SIZE_HEADER], 0x0C)


if __name__ == "__main__":
    unittest.main()
