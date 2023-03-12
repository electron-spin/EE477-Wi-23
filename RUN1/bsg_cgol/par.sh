if ! command -v code &> /dev/null
then
    function code { gedit "$@"; }
fi

make par
cd build/par-rundir/timingReports
rm -rf *postRoute_all.tarpt
rm -rf *postRoute_all_hold.tarpt
zcat *postRoute_all.tarpt.gz > *postRoute_all.tarpt
zcat *postRoute_all_hold.tarpt.gz > *postRoute_all_hold.tarpt
code *postRoute_all.tarpt
code *postRoute_all_hold.tarpt
cd ../
code *area.rpt
code *power.rpt
cd ../../
make sim-par
cd build/sim-par-rundir 
code run.log
cd ../../
make drc
make lvs