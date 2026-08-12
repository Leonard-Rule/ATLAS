## Remove events that are completely contained within another event
id: nested-dates-rule
type: code
snippet: nested-dates-removal

Some events will have other events completely within them — generally we want to remove those before creating visit sequences or counting episodes. The macro below iteratively removes nested date ranges until none remain, then builds a gap-based sequence so you can identify readmissions and roll up nearby visits.
