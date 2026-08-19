## StudyID — de-identified person-level identifier
id: studyid-rule
type: reference

The StudyID is a concatenated variable used to link member records and count distinct individuals within a single year. It is also used to link records across data sources. It is a concatenation of the HashID, sex, and date of birth.  

[callout warning "StudyIDs have limitations"]
Since HashIDs are based on a person's last name and date of birth it is possible to have individuals with the same HashID, for instance, twins. This is why we include sex in StudyID. When more than 1 individual is associated with a single StudyID we call this a "collision."
Every member record and every record ACHI receives gets a HashID.  Unfortunately, there are several situations that can break a StudyID linkage:
- a typo in the DOB or last name
- a last name change that has not been updated across all data sources
- different ways of handling special characters such as apostrophes, hyphens, or spaces. 
When any ID representing an individual has more than one StudyID we consider this a "divergence."

Note: While the HashID already includes the date of birth in the hash, we include it in our StudyID to use as a quick check if needed.
[/callout]
