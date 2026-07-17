
*------ STEP 1: STACK RAW FIELDS ------;/**/
%macro stack_race(first, last);
	proc sql;
		create table member_demographics as /**/
		%do yr=%eval(&first.) %to &last.;
			%if &yr. ne &first. %then union;
				select distinct studyid, newid, payer_type
                        , ME021_MemberRace1, ME025_MemberEthnicity1
						, ME001_Submitter
			from ssdrive.medcov_&yr.
		%end;
		;
	quit;
%mend;

%stack_race(2020, 2023)


*------ STEP 2: CLASSIFY RACE, ETHNICITY, AND GENDER ------;/**/
proc sql;
    create table Demographics_classified as
        select distinct studyid, newid, payer_type, ME001_Submitter,
            ME021_MemberRace1, ME025_MemberEthnicity1,
            case
                when ME021_MemberRace1 in ("1002-5","1004-1","1072-8")                                    then "Native American"
                when ME021_MemberRace1 in ("2028-9","2029-7","2034-7","2039-6","2040-4","2041-2","2047-9") then "Asian"
                when ME021_MemberRace1 in ("2054-5","2056-0","2058-6")                                    then "Black"
                when ME021_MemberRace1 in ("2036-2","2076-8","2079-2","2080-0","2086-7","2500-7")         then "Pacific Islander"
                when ME021_MemberRace1 in ("2106-3","2110-5","2116-2")                                    then "White"
                when ME021_MemberRace1 in ("1886-1","2131-1")                                             then "Other"
                else "Unknown"
            end as race,
            case
                when ME021_MemberRace1 in ("1002-5","1004-1","1072-8")                                    then 2
                when ME021_MemberRace1 in ("2028-9","2029-7","2034-7","2039-6","2040-4","2041-2","2047-9") then 3
                when ME021_MemberRace1 in ("2054-5","2056-0","2058-6")                                    then 5
                when ME021_MemberRace1 in ("2036-2","2076-8","2079-2","2080-0","2086-7","2500-7")         then 1
                when ME021_MemberRace1 in ("2106-3","2110-5","2116-2")                                    then 6
                when ME021_MemberRace1 in ("1886-1","2131-1")                                             then 4
                else 7
            end as racenumber,
            case
                when ME025_MemberEthnicity1 in ("13","14","15","16","17","18","19","20","21","22","34") then "Y"
                when ME025_MemberEthnicity1 in ("03","04","05","06","07","08","09","10","11","12","33") then "N"
                else "U"
            end as ethnicity,
            case
                when ME025_MemberEthnicity1 in ("13","14","15","16","17","18","19","20","21","22","34") then 1
                when ME025_MemberEthnicity1 in ("03","04","05","06","07","08","09","10","11","12","33") then 2
                else 3
            end as ethnicitynumber
        from member_demographics
		order by studyid;
quit;


*------ STEP 3: MCD QHP RACE/ETHNICITY REPLACEMENT ------;
/*replace the MCD QHP race and ethnicity with that of HCIP*/
proc sql;
    create table qhp_replacements as /**/
        select distinct a.studyid, a.newid, a.payer_type, a.ME001_Submitter
					, b.race, b.racenumber, b.ethnicity, b.ethnicitynumber
        from (select distinct * from Demographics_classified where payer_type = "MCD QHP") a
        inner join (select distinct * from demographics_classified where payer_type = 'HCIP') b
            on a.studyid = b.studyid;

    create table re_qhp_fixed as /*8,383,220*/
        select distinct
            a.studyid, a.newid, a.payer_type, a.ME001_Submitter,
            case
                when a.payer_type = "MCD QHP" and a.studyid is not null and b.race is not null        then b.race
                when a.payer_type = "MCD QHP" and a.studyid is not null and b.race is null            then "Unknown"
                else a.race
            end as race,
            case
                when a.payer_type = "MCD QHP" and a.studyid is not null and b.racenumber is not null  then b.racenumber
                when a.payer_type = "MCD QHP" and a.studyid is not null and b.racenumber is null      then 7
                else a.racenumber
            end as racenumber,
            case
                when a.payer_type = "MCD QHP" and a.studyid is not null and b.ethnicity is not null   then b.ethnicity
                when a.payer_type = "MCD QHP" and a.studyid is not null and b.ethnicity is null       then "U"
                else a.ethnicity
            end as ethnicity,
            case
                when a.payer_type = "MCD QHP" and a.studyid is not null and b.ethnicitynumber is not null then b.ethnicitynumber
                when a.payer_type = "MCD QHP" and a.studyid is not null and b.ethnicitynumber is null     then 3
                else a.ethnicitynumber
            end as ethnicitynumber
        from Demographics_classified a
            left join qhp_replacements b on a.studyid = b.studyid;
quit;


*------ STEP 4: RANK-ORDER DEDUPLICATION — RACE ------;/**/
proc sql;
    create table re_race_ranked as /**/
        select distinct studyid, race, racenumber
        from re_qhp_fixed
        order by studyid, racenumber;
quit;

data re_race_final;
    set re_race_ranked;
    by studyid racenumber;
    if first.studyid then output;
run;


*------ STEP 5: RANK-ORDER DEDUPLICATION — ETHNICITY ------;
proc sql;
    create table re_eth_ranked as /**/
        select distinct studyid, ethnicity, ethnicitynumber
        from re_qhp_fixed
        order by studyid, ethnicitynumber;
quit;

data re_eth_final; /**/
    set re_eth_ranked;
    by studyid ethnicitynumber;
    if first.studyid then output;
run;


*------ STEP 8: COMBINE INTO FINAL REFERENCE TABLE ------;
proc sql;
	create table ssdrive.member_demographics_ref as /**/
		select distinct a.studyid, a.newid
					, a.payer_type
					, b.race
					, c.ethnicity
					, case
						when c.ethnicity = 'Y' then 'Hispanic'
						else b.race
					end as race_ethnicity
		from member_demographics a
				left join re_race_final b on a.studyid = b.studyid
				left join re_eth_final c on a.studyid = c.studyid
		where a.payer_type ne 'HCIP';
quit;
