## SAS setup for efficiently running your code
id: ssdrive-path
type: sop
snippet: ssdrive-setup

Each analyst's computer should have four encrypted solid-state drives (SSDs). The SSDrive must point to a different folder than where SASWORK tables are saved — each project gets its own named subfolder. Trial and error has suggested the following drive configuration works most efficiently:

- C:\ — Operating system
- Second largest SSD (not C:\) — dedicated solely to the work library and SASWORK. Edit the -WORK line in sasv9.cfg located at C:\Program Files\SASHome\SASFoundation\9.4\nls\en  →  -WORK "E:\SASWORK\SAS Temporary Files"
- While in sasv9.cfg, also set (if not already present): -MEMSIZE 58G  |  -SORTSIZE 48G  |  -SUMSIZE 58G  |  -CPUCOUNT 60
- Remaining SSD — SSDrive for project working datasets, one named subfolder per project

[callout warning "Back up sasv9.cfg before editing"]
Before changing the config file be sure to save a backup copy of the original.
[/callout]
