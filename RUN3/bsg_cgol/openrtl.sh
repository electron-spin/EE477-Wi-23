#!/bin/bash

if ! command -v code &> /dev/null
then
    function code { gedit "$@"; }
fi

cd build/sim-rtl-rundir
code run.log
cd ../../
