#/bin/bash

rm Makefile
cp Makefile\ \(tests\) Makefile
rm ../tests/*.in.out
make
./tests_rapido.sh
rm Makefile
cp Makefile\ \(propio\) Makefile


