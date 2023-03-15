if ! command -v code &> /dev/null
then
    function code { gedit "$@"; }
fi

cd build/syn-rundir/reports
code final_time*
cd ../../../
cd build/sim-syn-rundir
code run.log
cd ../../
