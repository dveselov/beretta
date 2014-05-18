import sys
from distutils.core import setup
from distutils.extension import Extension

base = {
  'name': 'beretta',
  'url': 'https://github.com/tyrannosaurus/beretta',
  'author': 'beretta contributors',
  'author_email': 'github@require.pm',
  'version': '0.2.5',
  'description': 'BERT (de)serializer for your Pythons',
  'license': 'MIT',
  'classifiers': (
    'Intended Audience :: Developers',
    'Programming Language :: Python :: 2.7',
    'Programming Language :: Python :: 3.3',
  ),
  'install_requires': (
    'termformat>=0.1.5',
  )
}

if hasattr(sys, 'pypy_version_info'):
  modules = {
    'packages': ['beretta'],
  }
else:
  modules = {
    'ext_modules': [
      Extension('beretta', ['beretta.c'])
    ],
  }
base.update(modules)

setup(**base)
