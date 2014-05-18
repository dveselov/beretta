test:
	cython beretta.pyx
	python setup.py build_ext --inplace
	nosetests
release:
	cython termformat.pyx
	python setup.py sdist upload
