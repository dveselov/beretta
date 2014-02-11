beretta [![Build Status](https://travis-ci.org/dieselpoweredkitten/beretta.png?branch=master)](https://travis-ci.org/dieselpoweredkitten/beretta)
=======

BERT serializer for your Pythons.

# Installation

```bash
$ pip install beretta
```

# Usage

```python
import beretta

binary = beretta.encode([{'key': 'value'}, 42]) # => b'\x83l\x00...'
beretta.decode(binary) # => [{'key': 'value'}, 42]
```
