import termformat


cdef encode_part(object term):
  cdef list terms
  term_type = type(term)
  if term == True:
    return (':bert', ':true')
  elif term == False:
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
    return (':bert', ':dict', list(terms))
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
        if dict_items == []:
          return {}
        else:
          terms = [[decode_part(key), decode_part(value)] for key, value in dict_items]
          return {key:value for key, value in terms}
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
