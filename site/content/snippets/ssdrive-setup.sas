%let ssdpath = E:\SSDRIVE\Project Name
%let rpath= R:\Project Name\Data;

libname ssdrive "&ssdpath";
libname rdrive "&rpath";

libname APCDclms "D:\APCD claims\XXX";
libname mcrclms "D:\APCD claims\medicare";

libname geoinfo "D:\GeoInfo";
libname lookup "R:\Lookup";

libname apcdlu 	ODBC noprompt = "UID=;PWD=;DSN=VIC-DATA-RES.ad.uams.edu;SERVER=VIC-DATA-RES.ad.uams.edu;DATABASE=APCD_ETL" SCHEMA=lookups ;

libname hdi 		ODBC  NOPROMPT="DSN=VIC-DATA-RES.ad.uams.edu;SERVER=VIC-DATA-RES.ad.uams.edu;DATABASE=HDI_PROD"	SCHEMA=dbo;

libname xwalk 		ODBC  NOPROMPT="DSN=VIC-DATA-RES.ad.uams.edu;SERVER=VIC-DATA-RES.ad.uams.edu;DATABASE=ACHI_Analytics"	SCHEMA=dbo;

options compress=yes;
options symbolgen;
option mprint mlogic;

%let mem_varis =  compress(ME998_APCDUniqueId||ME013_MemberGender||ME014_MemberDateOfBirth) as studyid 
				  , compress(ME001_Submitter||ME107_CarrierSpecificUniqueMembe) as newid
	              , ME001_Submitter
				  , ME002_NationalPlanId
				  , ME003_InsuranceType_ProductCode
				  , ME013_MemberGender
				  , ME014_MemberDateOfBirth
                  , ME016_MemberStateOrProvince
				  , ME017_MemberZipCode
				  , ME021_MemberRace1
				  , ME022_MemberRace2
				  , ME025_MemberEthnicity1
				  , ME026_MemberEthnicity2
				  , ME040_ProductIdentifier
				  , ME057_DateOfDeath
				  , ME059_DisabilityIndicator
				  , ME063_BenefitStatus
				  , ME107_CarrierSpecificUniqueMembe
				  , ME162A_DateOfFirstEnrollment
				  , ME163A_DateOfDisenrollment
			      , ME164A_HealthPlan
				  , ME173A_MemberCounty
				  , ME992_HIOS_ID
				  , ME998_APCDUniqueId
				  , PeriodEndingDate;

%let med_varis = compress(MC001_Submitter||MC137_CarrierSpecificUniqueMembe) as newid
				, MC001_Submitter,MC137_CarrierSpecificUniqueMembe, MC004_PayerClaimcontrolNumber,MC005_LineNumber
				, MC012_MemberGender, MC013_MemberDateOfBirth, MC016_MemberZipCode
				, MC020_AdmissionType, MC023_FinalDischargeStatus, MC024_ServiceProviderNumber
				, MC026_NationalServiceProviderID,MC030_ServiceProviderLastNameOrO, MC033_ServiceProviderCity, MC034_ServiceProviderState,MC035_ServiceProviderZipCode
				, MC036_TypeOfBill_Institutional,MC037_FacilityType
				, MC134_NationalServiceOrganizatio
				, MC077_NationalBillingProviderID,MC078_BillingProviderLastNameOrO,MC208_BillingProviderCity, MC209_BillingProviderState, MC210_BillingProviderZipCode
				, MC041_PrincipalDiagnosis
				, MC042_OtherDiagnosis1,MC043_OtherDiagnosis2, MC044_Otherdiagnosis3,MC045_OtherDiagnosis4,MC046_OtherDiagnosis5,MC047_OtherDiagnosis6
				, MC048_OtherDiagnosis7,MC049_OtherDiagnosis8, MC050_OtherDiagnosis9,MC051_OtherDiagnosis10,MC052_OtherDiagnosis11,MC053_OtherDiagnosis12
				, MC054_RevenueCode
				, MC055_ProcedureCode, MC056_ProcedureModifier1,MC061_Quantity
				, MC057_ProcedureModifier2,MC057B_ProcedureModifier3,MC057C_ProcedureModifier4, MC058_Principal_ICD_9_CM_Or_ICD_
				, MC058A_Other_ICD_9_CM_Or_ICD_10_
				, MC058B_Other_ICD_9_CM_Or_ICD_10_, MC058C_Other_ICD_9_CM_Or_ICD_10_, MC058D_Other_ICD_9_CM_Or_ICD_10_, MC058E_Other_ICD_9_CM_Or_ICD_10_, MC058EA_Other_ICD_9_CM_Or_ICD_10
				, MC058F_Other_ICD_9_CM_Or_ICD_10_, MC058G_Other_ICD_9_CM_Or_ICD_10_, MC058H_Other_ICD_9_CM_Or_ICD_10_, MC058J_Other_ICD_9_CM_Or_ICD_10_, MC058K_Other_ICD_9_CM_Or_ICD_10_
				, MC058L_Other_ICD_9_CM_Or_ICD_10_,MC059_DateOfServiceFrom,MC018_AdmissionDate, MC060_DateOfServiceThru
				, MC069_DischargeDate, MC062_ChargeAmount,MC063_PaidAmount
				, MC063A_HeaderLinePaymentIndicato,MC063C_WithholdAmount,MC065_CopayAmount, MC064_CapitationAmount
				, MC066_CoinsuranceAmount,MC067_DeductibleAmount,MC094_TypeOfClaim;


%let proc_list =  MC058_Principal_ICD_9_CM_Or_ICD_, MC058A_Other_ICD_9_CM_Or_ICD_10_
				, MC058B_Other_ICD_9_CM_Or_ICD_10_, MC058C_Other_ICD_9_CM_Or_ICD_10_
				, MC058D_Other_ICD_9_CM_Or_ICD_10_, MC058E_Other_ICD_9_CM_Or_ICD_10_
				, MC058EA_Other_ICD_9_CM_Or_ICD_10, MC058F_Other_ICD_9_CM_Or_ICD_10_
				, MC058G_Other_ICD_9_CM_Or_ICD_10_, MC058H_Other_ICD_9_CM_Or_ICD_10_
				, MC058J_Other_ICD_9_CM_Or_ICD_10_, MC058K_Other_ICD_9_CM_Or_ICD_10_
				, MC058L_Other_ICD_9_CM_Or_ICD_10_;



%let diag_codes = MC041_PrincipalDiagnosis
				, MC042_OtherDiagnosis1
				, MC043_OtherDiagnosis2
				, MC044_OtherDiagnosis3
				, MC045_OtherDiagnosis4
				, MC046_OtherDiagnosis5
				, MC047_OtherDiagnosis6
				, MC048_OtherDiagnosis7
				, MC049_OtherDiagnosis8
				, MC050_OtherDiagnosis9
				, MC051_OtherDiagnosis10
				, MC052_OtherDiagnosis11
				, MC053_OtherDiagnosis12;
