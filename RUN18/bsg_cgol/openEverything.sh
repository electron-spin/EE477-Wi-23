#!/bin/bash

if ! command -v code &> /dev/null
then
    function code { gedit "$@"; }
fi

cd build/sim-rtl-rundir
code run.log
cd ../../

cd build/syn-rundir/reports
code final_time*
cd ../../../
cd build/sim-syn-rundir
code run.log
cd ../../

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
cd build/sim-par-rundir 
code run.log
cd ../../