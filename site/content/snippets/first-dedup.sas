/* Keep one row per studyid — the row with the highest income_rank */
/* Step 1: sort by studyid then ranking variable descending        */
proc sort data=_members_ranked;
  by studyid descending income_rank;
run;

/* Step 2: DATA step FIRST. logic — keep first row per studyid */
data _members_top;
  set _members_ranked;
  by studyid;
  if first.studyid;
run;
/* N = _____ rows — should equal distinct studyid count from input */
