proc sql;
  create table dnp as
  select distinct
    case
      when ME003_InsuranceType_ProductCode = "MD" then "MCRAdv Pharm"
      when ME003_InsuranceType_ProductCode = "PBM" or me001_submitter in ('99CAR1',"99MDI1","12231","99MDI2","99MDI3","99MAG1") then "COM Pharm"
      when me001_submitter in ('99NAV1',"99MDI4","99MDI5") then "EBD PBM"
    end as payer_type
    ,compress(ME001_Submitter||ME107_CarrierSpecificUniqueMembe) as newid
    ,ME001_Submitter
    ,ME001_CAT
    ,ME107_CarrierSpecificUniqueMembe
    ,compress(ME998_APCDUniqueId||ME013_MemberGender||put(ME014_MemberDateOfBirth,date9.)) as studyid
    ,ME998_APCDUniqueId
    ,ME014_MemberDateOfBirth
    ,ME013_MemberGender
    ,ME003_InsuranceType_ProductCode
    ,ME164A_HealthPlan
    ,ME018_MedicalServicesIndicator
    ,ME019_PharmacyServicesIndicator
    ,ME020_DentalServicesIndicator
    ,ME030_MarketCategory
    ,ME040_ProductIdentifier
    ,ME057_DateOfDeath
    ,ME063_BenefitStatus
    ,ME032_GroupName
    ,ME162A_DateOfFirstEnrollment
    ,ME163A_DateOfDisenrollment
    ,ME992_HIOS_ID
    ,PeriodBeginDate
    ,PeriodEndingDate
  from membertable
  where (ME001_Submitter in ('99CAR1',"99MDI1","99MDI2","99MDI3","99MDI4","99MDI5","99SSC1","99MAG1","99NAV1" /* known PBMs pharmacy payers */ ,"67369F","70408","99DAR1", "99PRM1", "99ESA1")
      or ME003_InsuranceType_ProductCode in ('MD' /* MCRadv partD */ ,'PBM')
      or ME019_PharmacyServicesIndicator = "1")
    and ME003_InsuranceType_ProductCode not in (/* MCR FFS/MCRadv */ 'HN','HS','MCR','MA','MB','MDV','MH','MHO','MI','MPO')
    and ME013_MemberGender ne "U"
  order by newid, PeriodEndingDate, ME162A_DateOfFirstEnrollment;
quit;