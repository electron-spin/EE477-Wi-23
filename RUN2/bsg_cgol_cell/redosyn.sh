if ! command -v code &> /dev/null
then
    function code { gedit "$@"; }
fi

make redo-syn
cd build/syn-rundir/reports
code final_time*
cd ../../../
make redo-sim-syn
cd build/sim-syn-rundir
code run.log
cd ../../
