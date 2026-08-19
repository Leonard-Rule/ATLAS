## NewID — member identifier built from submitter + member ID
id: newid-rule
type: reference

NewID (also called SE_ID with external audiences) is created by submitter. 

[callout warning "There are many reasons we expect a single individual to have more than 1 NewID at any time:"]
- People can change payers during the year
- Having one type of coverage type (i.e., dental, medical, pharmacy) typically results in separate payers for the different payer types
- More than one payer for the same coverage type, for example: 
  - EBD retirees can and do also have Medicare.
  - The elderly and disabled can have Medicare and Medicaid.
 - Unfortunately, TPAs and PBMs (i.e., BCBS managed EBD; 99CAR1 is a PBM for some entities) will submit claims that are also submitted by the entity that is the final payer, which means the individual has two NewIDs for the same coverage.
[/callout]

For these reasons we count individuals using either the MPID or StudyID. However, there are a few cases where we would count NewIDs:
- for very rare procedures or diagnoses, for example, AIDs or HIV. 
- if we are interested in submitter specific data. This is most likely limited to studies with Medicare or Medicaid. 

When in doubt ask the Director or Assistant Directors.