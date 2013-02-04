#!/bin/sh
cd `dirname $0`
exec erl -pa $PWD/ebin $PWD/deps/*/ebin $PWD/../ssp/ebin -sname node1 -boot start_sasl -s reloader -s enouk_core
