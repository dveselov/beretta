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

bytes = beretta.encode([{'key': 'value'}, 42]) # => b'\x83l\x00...'
beretta.decode(bytes) # => [{'key': 'value'}, 42]
```
