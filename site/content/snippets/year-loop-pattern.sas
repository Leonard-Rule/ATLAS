/*NS: I would recommend using this method for years:*/
%macro pull_by_year;
%do yr = 2021 %to 2024; 
    proc sql;
      create table _claims_&yr. as
      select distinct &med_varis.
      from apcdclms.claims&yr.
      where year(dateofservicefrom) = &yr.;
    quit;
 % end;
 %mend;
%pull_by_year;

