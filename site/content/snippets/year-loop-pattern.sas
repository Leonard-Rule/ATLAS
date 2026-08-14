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


/* Year loop using %do %while and %scan                          */
/* Define macro variables globally before the macro call         */
%let years = 2021 2022 2023 2024;

%macro pull_by_year;
  %let i = 1;
  %do %while (%scan(&years., &i.) ne );
    %let yr = %scan(&years., &i.);

    proc sql;
      create table _claims_&yr. as
      select distinct &med_varis.
      from apcdclms.claims&yr.
      where year(dateofservicefrom) = &yr.;
    quit;

    %let i = %eval(&i. + 1);
  %end;
%mend pull_by_year;

%pull_by_year;
