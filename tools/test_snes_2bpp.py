import unittest

from PIL import Image

from .snes_2bpp import chr_to_image, image_to_chr


class Snes2bppTests(unittest.TestCase):
    def test_tile_round_trip(self):
        source = bytes((index * 37) & 0xFF for index in range(32))
        self.assertEqual(image_to_chr(chr_to_image(source, 2), 2), source)

    def test_levels_are_four_values(self):
        image = Image.new("L", (8, 8), 255)
        self.assertEqual(image_to_chr(image, 1), bytes([255] * 16))


if __name__ == "__main__":
    unittest.main()
