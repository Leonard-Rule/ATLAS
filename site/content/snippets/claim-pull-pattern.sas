/*NOTE: when extracting large pulls of claims always limit the number of obs to be sure*/
/*the code runs without error. Once the code runs successfully comment out the inobs=*/

/* Step 1: pull raw claims for population using inline subquery */
/* Use &med_varis. macro — no need to pull entire claim lines        */
/* Once you pull your claims you can limit to the fields that you need for your analysis*/

proc sql /*inobs=10*/; /* N rows */
  create table raw_claims as
  select distinct &med_varis.
  from apcdclms.claimtable
  where (calculated newid) in
        (select distinct newid from pop_table);
quit;

/*Always count the number of individuals as your proceed through extractions and joins*/
Proc sql;
  select count(distinct newid) as NIDcnt format = comma12.
    from raw_claims; 
/*xxxxxx*/

/* Step 2: join to bring in studyid, payer_type, and demo fields */
proc sql; /* N rows */

  create table claims_demo as
  select distinct a.studyid, a.payer_type, b.* 
  from pop_table a 
  inner join raw_claims b
    on a.newid = b.newid;
quit;

Proc sql;
  select count(distinct newid) as NIDcnt format = comma12.
    , count(distinct studyid) as SIDcnt format = comma12.
      from claims_demo; 
/*xxxxxx; xxxxxxx*/