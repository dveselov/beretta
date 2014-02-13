import beretta
import unittest
import datetime


class EncodeTestCase(unittest.TestCase):

  def test_encode_tuple(self):
    bytes = beretta.encode((":call", "Module", "function", [True]))
    self.assertEqual(bytes, b'\x83h\x04d\x00\x04callm\x00\x00\x00'
                            b'\x06Modulem\x00\x00\x00\x08functionl'
                            b'\x00\x00\x00\x01h\x02d\x00\x04bertd'
                            b'\x00\x04truej')

  def test_encode_list(self):
    bytes = beretta.encode([1, 2, False])
    self.assertEqual(bytes, b'\x83l\x00\x00\x00\x03a\x01a\x02h\x02d'
                            b'\x00\x04bertd\x00\x05falsej')

  def test_encode_empty_list(self):
    bytes = beretta.encode([])
    self.assertEqual(bytes, b'\x83h\x02d\x00\x04bertd\x00\x03nil')

  def test_encode_true(self):
    bytes = beretta.encode(True)
    self.assertEqual(bytes, b'\x83h\x02d\x00\x04bertd\x00\x04true')

  def test_encode_false(self):
    bytes = beretta.encode(False)
    self.assertEqual(bytes, b'\x83h\x02d\x00\x04bertd\x00\x05false')

  def test_encode_none(self):
    bytes = beretta.encode(None)
    self.assertEqual(bytes, b'\x83h\x02d\x00\x04bertd\x00\tundefined')

  def test_encode_dict(self):
    bytes = beretta.encode({'key': 'value'})
    self.assertEqual(bytes, b'\x83h\x03d\x00\x04bertd\x00\x04dictl'
                            b'\x00\x00\x00\x01h\x02m\x00\x00\x00\x03'
                            b'keym\x00\x00\x00\x05valuej')

  def test_encode_empty_dict(self):
    bytes = beretta.encode({})
    self.assertEqual(bytes, b'\x83h\x03d\x00\x04bertd\x00\x04dictj')

  def test_encode_datetime(self):
    bytes = beretta.encode(datetime.datetime(2014, 2, 10, 6, 2, 51, 36215))
    self.assertEqual(bytes, b'\x83h\x05d\x00\x04bertd\x00\x04timeb'
                            b'\x00\x00\x05pb\x00\x00/\x8bb\x00\x00\x8dw')

  def test_encode_0(self):
    bytes = beretta.encode(0)
    self.assertEqual(bytes, b'\x83a\x00')

  def test_encode_1(self):
    bytes = beretta.encode(1)
    self.assertEqual(bytes, b'\x83a\x01')

