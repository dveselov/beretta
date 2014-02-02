beretta
=======

A BERT serializer for your Pythons.

# Installation

```bash
$ pip install beretta
```

# Usage

```python
import beretta

request = beretta.encode((":call", "DummyModule", "echo", ["hello"])) # => b'\x83h\x04d...'
response = beretta.decode(request) # => (":call", "DummyModule", ...)
```
