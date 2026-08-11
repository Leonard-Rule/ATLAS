/* Row count from log goes immediately after the table creation  */
proc sql; /* 45,231 rows */
  create table ssdrive.raw_claims as
  select distinct * from _events_dedup;
quit;

/*test*/