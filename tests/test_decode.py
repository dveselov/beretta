import beretta
import unittest
import datetime


class DecodeTestCase(unittest.TestCase):

  def test_decode_tuple(self):
    result = beretta.decode(b'\x83h\x04d\x00\x04callm\x00\x00\x00'
                            b'\x06Modulem\x00\x00\x00\x08functionl'
                            b'\x00\x00\x00\x01h\x02d\x00\x04bertd'
                            b'\x00\x04truej')
    self.assertEqual(result, (":call", "Module", "function", [True]))

  def test_decode_list(self):
    result = beretta.decode(b'\x83l\x00\x00\x00\x03h\x02d\x00\x04'
                            b'bertd\x00\x04truea\x02h\x02d\x00\x04'
                            b'bertd\x00\x05falsej')
    self.assertEqual(result, [1, 2, False])

  def test_decode_empty_list(self):
    result = beretta.decode(b'\x83h\x02d\x00\x04bertd\x00\x03nil')
    self.assertEqual(result, [])

  def test_decode_true(self):
    result = beretta.decode(b'\x83h\x02d\x00\x04bertd\x00\x04true')
    self.assertEqual(result, True)

  def test_decode_false(self):
    result = beretta.decode(b'\x83h\x02d\x00\x04bertd\x00\x05false')
    self.assertEqual(result, False)

  def test_decode_none(self):
    result = beretta.decode(b'\x83h\x02d\x00\x04bertd\x00\tundefined')
    self.assertEqual(result, None)

  def test_decode_dict(self):
    result = beretta.decode(b'\x83h\x03d\x00\x04bertd\x00\x04dictl'
                            b'\x00\x00\x00\x01h\x02m\x00\x00\x00\x03'
                            b'keym\x00\x00\x00\x05valuej')
    self.assertEqual(result, {'key': 'value'})

  def test_decode_empty_dict(self):
    result = beretta.decode(b'\x83h\x03d\x00\x04bertd\x00\x04dictj')
    self.assertEqual(result, {})

  def test_decode_datetime(self):
    result = beretta.decode(b'\x83h\x05d\x00\x04bertd\x00\x04timeb'
                            b'\x00\x00\x05pb\x00\x00/\x8bb\x00\x00\x8dw')
    self.assertEqual(result, datetime.datetime(2014, 2, 10, 6, 2, 51, 36215))

  def test_decode_unknown_bert_type(self):
    with self.assertRaises(ValueError):
      # tuple = (":bert", ":kittens", [])
      # ValueError: Invalid BERT type: :kittens
      result = beretta.decode(b'\x83h\x03d\x00\x04bertd\x00\x07'
                              b'kittensh\x02d\x00\x04bertd\x00\x03nil')

  def test_decode_zero_float(self):
    result = beretta.decode(b'\x83c0.00000000000000000000e+00\x00\x00\x00\x00\x00')
    self.assertEqual(result, 0.0)
