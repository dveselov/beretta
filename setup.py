from distutils.core import setup
from distutils.extension import Extension


setup(
  name = 'beretta',
  author = 'beretta contributors',
  author_email = 'github@require.pm',
  url = 'https://github.com/dieselpoweredkitten/beretta',
  version = '0.2',
  description = 'BERT (de)serializer for your Pythons',
  license = 'MIT',
  ext_modules = [Extension('beretta', ['beretta.c'])],
  classifiers = (
    'Intended Audience :: Developers',
    'Programming Language :: Python :: 2.7',
    'Programming Language :: Python :: 3.3',
  ),
  install_requires = (
    'termformat>=0.1',
  )
)
