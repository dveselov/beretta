# coding: utf-8
import re
import datetime
import termformat


__version__ = "0.2.6"
__is_cython__ = True


REGEX_TYPE = type(re.compile("kittens"))
ZERO_HOUR = datetime.datetime(1970, 1, 1, 0, 0)

cdef inline tuple encode_datetime(object time):
  cdef int megaseconds, seconds, microseconds
  delta = time - ZERO_HOUR
  seconds = delta.days * 24 * 60 * 60 + delta.seconds
  megaseconds = seconds // 1000000
  seconds = seconds % 1000000
  microseconds = time.microsecond
  return (":bert", ":time", megaseconds, seconds, microseconds)

cdef inline object decode_datetime(int megaseconds, int seconds, int microseconds):
  seconds = megaseconds * 1000000 + seconds
  timestamp = datetime.datetime.utcfromtimestamp(seconds)
  return timestamp.replace(microsecond=microseconds)

cdef inline object encode_term(object term):
  cdef list terms
  term_type = type(term)
  if term is True:
    return (":bert", ":true")
  elif term is False:
    return (":bert", ":false")
  elif term is None:
    return (":bert", ":undefined")
  elif term == []:
    return (":bert", ":nil")
  elif term_type == tuple:
    terms = [encode_term(x) for x in term]
    return tuple(terms)
  elif term_type == list:
    terms = [encode_term(x) for x in term]
    return terms
  elif term_type == dict:
    terms = [encode_term(x) for x in term.items()]
    return (":bert", ":dict", terms)
  elif term_type == datetime.datetime:
    return encode_datetime(term)
  elif term_type == REGEX_TYPE:
    flags = []
    if term.flags & re.VERBOSE:
      flags.append(":extended")
    if term.flags & re.IGNORECASE:
      flags.append(":caseless")
    if term.flags & re.MULTILINE:
      flags.append(":multiline")
    if term.flags & re.DOTALL:
      flags.append(":dotall")
    return (":bert", ":regex", term.pattern, tuple(flags))
  else:
    return term

cdef inline object decode_term(object term):
  cdef list terms
  cdef int flags
  term_type = type(term)
  if term_type == tuple:
    if term[0] == ":bert":
      value_type = term[1]
      if value_type == ":true":
        return True
      elif value_type == ":false":
        return False
      elif value_type == ":undefined":
        return None
      elif value_type == ":nil":
        return []
      elif value_type == ":dict":
        dict_items = term[2]
        if not dict_items:
          return {}
        else:
          terms = [[decode_term(key), decode_term(value)] for key, value in dict_items]
          return {key:value for key, value in terms}
      elif value_type == ":time":
        megaseconds, seconds, microseconds = term[2:]
        return decode_datetime(megaseconds, seconds, microseconds)
      elif value_type == ":regex":
        flags = 0
        pattern, options = term[2:4]
        if ":extended" in options:
          flags |= re.VERBOSE
        if ":caseless" in options:
          flags |= re.IGNORECASE
        if ":multiline" in options:
          flags |= re.MULTILINE
        if ":dotall" in options:
          flags |= re.DOTALL
        return re.compile(pattern, flags)
      else:
        raise ValueError("Invalid BERT type: {0}".format(value_type))
    else:
      return tuple([decode_term(x) for x in term])
  elif term_type == list:
    return [decode_term(x) for x in term]
  else:
    return term


cpdef bytes encode(object term):
  bert = encode_term(term)
  return termformat.encode(bert)

cpdef object decode(bytes term):
  bert = termformat.decode(term)
  return decode_term(bert)
