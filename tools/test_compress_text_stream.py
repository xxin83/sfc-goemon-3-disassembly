import unittest

try:
    from .compress_text_stream import compress_stream
except ImportError:
    from compress_text_stream import compress_stream


class TextCompressionTests(unittest.TestCase):
    def test_dictionary_and_repeats(self):
        self.assertEqual(compress_stream(bytes.fromhex("9C 69 6A 6B 18 7B")), b"\xD4")
        self.assertEqual(compress_stream(b"\x18\x18\x18"), b"\xDC")
        self.assertEqual(compress_stream(b"\x1E\x1E\x1E"), b"\xE0\x1E")

    def test_b5_descriptor_is_opaque(self):
        data = bytes.fromhex("B5 00 00 03 78 19 04 FF 18 18 03 00")
        self.assertEqual(compress_stream(data), bytes.fromhex("B5 00 00 03 78 19 04 FF DD 03 00"))


if __name__ == "__main__":
    unittest.main()
