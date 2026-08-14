/*NOTE: when extracting large pulls of claims always limit the number of obs to be sure*/
/*the code runs without error. Once the code runs successfully comment out the inobs=*/

/* Step 1: pull raw claims for population using inline subquery */
/* Use &med_varis. macro — no need to pull entire claim lines        */
proc sql /*inobs=10*/; /* N rows */
  create table raw_claims as
  select distinct &med_varis.
  from apcdclms.claimtable
  where (calculated newid) in
        (select distinct newid from pop_table);
quit;

/* Step 2: join to bring in studyid, payer_type, and demo fields */
proc sql; /* N rows */

  create table claims_demo as
  select distinct a.*, b.studyid, b.payer_type
  from raw_claims as a
  inner join pop_table as b
    on a.newid = b.newid;
quit;

/*test*/ /*test*/