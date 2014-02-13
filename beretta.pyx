import termformat
import datetime

ZERO_HOUR = datetime.datetime(1970, 1, 1, 0, 0)

cdef tuple encode_datetime(object time):
  cdef int megaseconds, seconds, microseconds
  delta = time - ZERO_HOUR
  seconds = delta.days * 24 * 60 * 60 + delta.seconds
  megaseconds = seconds // 1000000
  seconds = seconds % 1000000
  microseconds = time.microsecond
  return (":bert", ":time", megaseconds, seconds, microseconds)

cdef object decode_datetime(int megaseconds, int seconds, int microseconds):
  seconds = megaseconds * 1000000 + seconds
  timestamp = datetime.datetime.utcfromtimestamp(seconds)
  return timestamp.replace(microsecond=microseconds)


cdef encode_part(object term):
  cdef list terms
  term_type = type(term)
  if term == True and term_type != int: # python2: 1 == True
    return (':bert', ':true')
  elif term == False and term_type != int: # python2: 0 == False
    return (':bert', ':false')
  elif term == None:
    return (':bert', ':undefined')
  elif term == []:
    return (':bert', ':nil')
  elif term_type == tuple:
    terms = [encode_part(x) for x in term]
    return tuple(terms)
  elif term_type == list:
    terms = [encode_part(x) for x in term]
    return terms
  elif term_type == dict:
    terms = [encode_part(x) for x in term.items()]
    return (':bert', ':dict', terms)
  elif term_type == datetime.datetime:
    return encode_datetime(term)
  else:
    return term

cdef decode_part(object term):
  cdef list terms
  term_type = type(term)
  if term_type == tuple:
    if term[0] == ":bert":
      value_type = term[1]
      if value_type == True:
        return True
      elif value_type == False:
        return False
      elif value_type == None:
        return None
      elif value_type == ":nil":
        return []
      elif value_type == ":dict":
        dict_items = term[2]
        if not dict_items:
          return {}
        else:
          terms = [[decode_part(key), decode_part(value)] for key, value in dict_items]
          return {key:value for key, value in terms}
      elif value_type == ":time":
        megaseconds, seconds, microseconds = term[2:]
        return decode_datetime(megaseconds, seconds, microseconds)
      else:
        raise ValueError("Invalid BERT type: {0}".format(value_type))
    else:
      terms = [decode_part(x) for x in term]
      return tuple(terms)
  elif term_type == list:
    terms = [decode_part(x) for x in term]
    return terms
  else:
    return term


cpdef bytes encode(object term):
  bert = encode_part(term)
  return termformat.encode(bert)

cpdef object decode(bytes term):
  bert = termformat.decode(term)
  return decode_part(bert)
