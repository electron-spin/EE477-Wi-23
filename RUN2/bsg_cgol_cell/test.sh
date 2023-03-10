if ! command -v code &> /dev/null
then
    alias code='gedit'
fi

make rtl
make sim-rtl
cd build/sim-rtl-rundir
code run.log
cd ../../
make view-sim-rtl