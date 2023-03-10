if ! command -v code &> /dev/null
then
    function code { gedit "$@"; }
fi

make redo-syn
make redo-sim-syn
cd build/syn-rundir/reports
code final_time*
cd ../../
cd sim-syn-rundir
code run.log
cd ../../
