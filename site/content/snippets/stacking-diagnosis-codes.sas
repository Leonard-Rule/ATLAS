proc sql;
  create table dev_delay_diags as
  select distinct
    bpid
    ,mpid
    ,MC059_DateOfServiceFrom
    ,&diagcodes. /* this is the list of diagnosis variables, with a comma between */
  from ssdrive.find_dev_delay_dx_all;
quit;

data dev_delay_diags_stack; /* 757,628,987 */
  set dev_delay_diags;
  keep bpid mpid eventid dxtype MC059_DateOfServiceFrom diagnosiscode;
  length dxtype $10;

  eventid = compress(mpid||put(MC059_DateOfServiceFrom,date9.));

  array diag[13] &diagcodes_nocom.; /* this is the same list of diagnosis code variables but without the commas in between */

  do i = 1 to 13;
    if i = 1 then dxtype = "primary";
      else dxtype = "secondary";
    diagnosiscode = diag[i];
    if diagnosiscode in (&speech., &dev_dis., &motor., &del_mil., &autism.) then output; /* diag codes of interest for the study if needed */
  end;

run;