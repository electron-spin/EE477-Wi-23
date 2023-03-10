if ! command -v code &> /dev/null
then
    function code { gedit "$@"; }
fi

make par
make sim-par
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