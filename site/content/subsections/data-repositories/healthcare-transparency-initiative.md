## Healthcare Transparency Initiative (HTI)
id: health-transparency-initiative-hti
type: reference

The purpose of the HTI was created to build a centralized, statewide source of administrative healthcare data. Its goal is to make healthcare utilization, pricing, and quality metrics accessible to consumers, researchers, and policymakers to support cost control, research, and population health strategies. It was authorized under the Arkansas General Assembly Act 1233 of 2015 and expanded upon in Act 948 and Act 979 both of 2017.\

It contains the Arkansas All-Payer Claims Database, the medical marijuana cardholder data, the ADH birth and death records, and hospital and emergency department discharge for ONLY uninsured individuals.\

To link claims records to member enrollment records we use the NewID. To link different coverage types, such as medical and pharmacy, we use the StudyID or MPID. To link to the ADH records we use StudyID or MPID. The use of StudyID or MPID is dependent on the type of analysis.

### APCD
The APCD contains member enrollment, medical, pharmacy, and dental claims for all payers providing coverage in Arkansas except those that are private self-funded plans, such as those covering Walmart or Tyson employees, or for payers with less than 2,000 covered lives.\
Note that Walmart and Tyson as well as a couple of other large employers that offer self-funded plans are primarily located in Northwest Arkansas. This means we have less insight to this area when we are dealing with the APCD commercial claims.

### ADH Data
Technically, we have access to ADH data through both the HDI and the HTI. However, for several reasons, we connect to the ADH data that is on the HDI server. For birth and death records we have the same level of access across both the HDI and HTI. However, this is not the case for the hospital and emergency department discharge data. Always make sure you know which Initiative you are accessing the data under.

### Medicare Data
We receive Medicare data from ResDAC (Research Data Assistance Center). Currently we receive two extractions one under the HDI and one under the HTI. The only difference is that the one under the HDI DUA include the name and address file. The ResDAC data layout includes the table of beneficiaries and 7 tables of claims that are specific to provider type (inpatient, outpatient, part B, pharmacy, home health, skilled nursing facilities, and hospice) and each of these tables have several other tables associated with them. In order to streamline our analyses we have developed a Medicare to APCD transformation process. Because the data contained in the ResDAC database is much richer than what is contained in the APCD layout we sometimes need to go back to the ResDAC tables, especially the bene_sum table. This table contains a lot of monthly data indicating if the beneficiary has Part C coverage (aka Medicare Advantage), the product type, if they have Part D coverage, and much more.

### Which data source should we use? How do we decide?
Coming soon...

### Required External Reviews
There are very specific requirements for each data source that requires review before public release. We are working on building a system in Jira to capture which reviews are required for each product we create. Typically, anything using the APCD must be reviewed by the HTI advisory board and anything using data from ADH needs approval. We rely on the Director of Health Policy/Privacy officer to handle getting approvals for the data, but she may not be aware of a product that needs review.