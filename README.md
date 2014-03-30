beretta [![Build Status](https://travis-ci.org/tyrannosaurus/beretta.png?branch=master)](https://travis-ci.org/tyrannosaurus/beretta)
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

# Datatypes representation

<table>
    <tr>
        <td>Type</td>
        <td>Python</td>
        <td>Erlang</td>
    </tr>
    <tr>
        <td>Time</td>
        <td>datetime.datetime</td>
        <td>{bert, time, Megaseconds, Seconds, Microseconds}</td>
    </tr>
    <tr>
        <td>Dictionary</td>
        <td>dict</td>
        <td>{bert, dict, KeysAndValues}</td>
    </tr>
    <tr>
        <td>Boolean</td>
        <td>True or False</td>
        <td>{bert, true} or {bert, false}</td>
    </tr>
    <tr>
        <td>Nil</td>
        <td>None</td>
        <td>{bert, nil}</td>
    </tr>
    <tr>
        <td>Regex</td>
        <td>re.compile</td>
        <td>{bert, regex, Source, Options}</td>
    </tr>
</table>
