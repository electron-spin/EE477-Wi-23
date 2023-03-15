#!/bin/bash

if ! command -v code &> /dev/null
then
    function code { gedit "$@"; }
fi

make rtl-hard
make sim-rtl-hard
cd build/sim-rtl-hard-rundir
code run.log
cd ../../
make view-sim-rtl-hard