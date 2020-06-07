SELECT
  s.dcid,
  s.lastfirst,
  s.grade_level,
  CASE
    WHEN s.ethnicity = 'B' THEN 'African-American'
    WHEN s.ethnicity = 'A' THEN 'Asian'
    WHEN s.ethnicity = 'C' THEN 'Caucasian'
    WHEN s.ethnicity = 'H' THEN 'Hispanic'
    WHEN s.ethnicity = 'M' THEN 'Multiracial'
    WHEN s.ethnicity = 'I' THEN 'Native American'
    WHEN s.ethnicity = 'P' THEN 'Pacific Islander'
  END,
  s.gender,
  CASE s.lunchstatus
    WHEN 'FDC' THEN 'Free'
    WHEN 'F' THEN 'Free'
    WHEN 'P' THEN 'Paid'
  ELSE 'Reduced'
  END,
  CASE
    WHEN s_mi_stu_gc_x.HomelessStatus = '10' THEN '(10) Shelters'
    WHEN s_mi_stu_gc_x.HomelessStatus = '11' THEN '(11) Transitional Housing'
    WHEN s_mi_stu_gc_x.HomelessStatus = '13' THEN '(13) Doubled Up'
    WHEN s_mi_stu_gc_x.HomelessStatus = '14' THEN '(14) Hotel/Motel'
    WHEN s_mi_stu_gc_x.HomelessStatus = '15' THEN '(15) Unsheltered'
  END,
  CASE
      WHEN state.flagspeced = 1 THEN 'Yes'
      ELSE 'No'
  END,
  CASE
      WHEN state.flaglep = 1 THEN 'Yes'
      ELSE 'No'
  END,
  s.student_number,
  schl.name,
  sum(ada.membershipvalue)-sum(ada.attendancevalue),
  sum(ada.membershipvalue),
  round((sum(ada.membershipvalue)-sum(ada.attendancevalue))/sum(ada.membershipvalue)*100,2)

FROM students s
  JOIN schools schl ON schl.school_number = s.schoolid
  JOIN ps_adaadm_defaults_all ada ON ada.studentid = s.id
  JOIN s_mi_stu_gc_x ON s.dcid = s_mi_stu_gc_x.studentsdcid

WHERE
  s.enroll_status =0
  AND to_date(ada.calendardate)  > to_date('%param1%', 'mm/dd/yyyy')
  AND to_date(ada.calendardate) <= to_date('%param2%', 'mm/dd/yyyy')
  AND ada.membershipvalue > 0
  AND s.schoolid != 1515
  AND s.schoolid like case when ~(curschoolid)=0 then '%' else '~(curschoolid)' end

GROUP BY
s.dcid,
s.lastfirst,
s.grade_level,
CASE
  WHEN s.ethnicity = 'B' THEN 'African-American'
  WHEN s.ethnicity = 'A' THEN 'Asian'
  WHEN s.ethnicity = 'C' THEN 'Caucasian'
  WHEN s.ethnicity = 'H' THEN 'Hispanic'
  WHEN s.ethnicity = 'M' THEN 'Multiracial'
  WHEN s.ethnicity = 'I' THEN 'Native American'
  WHEN s.ethnicity = 'P' THEN 'Pacific Islander'
END,
s.gender,
s.lunchstatus,
CASE
  WHEN s_mi_stu_gc_x.HomelessStatus = '10' THEN '(10) Shelters'
  WHEN s_mi_stu_gc_x.HomelessStatus = '11' THEN '(11) Transitional Housing'
  WHEN s_mi_stu_gc_x.HomelessStatus = '13' THEN '(13) Doubled Up'
  WHEN s_mi_stu_gc_x.HomelessStatus = '14' THEN '(14) Hotel/Motel'
  WHEN s_mi_stu_gc_x.HomelessStatus = '15' THEN '(15) Unsheltered'
END,
CASE
    WHEN state.flagspeced = 1 THEN 'Yes'
    ELSE 'No'
END,
CASE
    WHEN state.flaglep = 1 THEN 'Yes'
    ELSE 'No'
END,
s.student_number,
schl.name

HAVING
  100-round(sum(ada.attendancevalue)/sum(ada.membershipvalue)*100,2) >= %param3%

ORDER BY s.lastfirst ASC


/* This is where the file drump from PS lives

<ReportName>Chronically Absent (Add'l Info)</ReportName>
<ReportTitle>Chronically Absent (Add'l Info)</ReportTitle>
<AfterTitle></AfterTitle>
<ReportDescription><textarea>Shows chronic absences by student along with demographic information. Also allows user to select date range.</textarea></ReportDescription>
<ReportGroup>Attendance</ReportGroup>
<SQLQuery><textarea>SELECT
  s.dcid,
  s.lastfirst,
  s.grade_level,
  s.ethnicity,
  s.gender,
  s.lunchstatus,
  s_mi_stu_gc_x.flaglep,
  s_mi_stu_gc_x.flagspeced,
  s.student_number,
  schl.name,
  sum(ada.membershipvalue)-sum(ada.attendancevalue),
  sum(ada.membershipvalue),
  round((sum(ada.membershipvalue)-sum(ada.attendancevalue))/sum(ada.membershipvalue)*100,2)

FROM students s
  JOIN schools schl ON schl.school_number = s.schoolid
  JOIN ps_adaadm_defaults_all ada ON ada.studentid = s.id
  JOIN s_mi_stu_gc_x ON s.dcid = s_mi_stu_gc_x.studentsdcid

WHERE
  s.enroll_status =0
  AND to_date(ada.calendardate)  &gt; to_date('%param1%', 'mm/dd/yyyy')
  AND to_date(ada.calendardate) &lt;= to_date('%param2%', 'mm/dd/yyyy')
  AND ada.membershipvalue &gt; 0
  tilde[if.is.a.school]AND s.schoolid = tilde(curschoolid)[/if]

GROUP BY
  s.dcid,
  s.lastfirst,
  s.grade_level,
  s.ethnicity,
  s.gender,
  s.lunchstatus,
  s_mi_stu_gc_x.flaglep,
  s_mi_stu_gc_x.flagspeced,
  s.student_number,
  schl.name

HAVING
  round(sum(ada.attendancevalue)/sum(ada.membershipvalue)*100,2) &lt;= (100 -%param3%)

ORDER BY s.lastfirst ASC
</textarea></SQLQuery>
<ReportHeader><th CLASS="DCID">DCID</th><th>Name</th><th>Grade Level</th><th>Ethnicity</th><th>Gender</th><th>SES</th><th>LEP</th><th>SPED</th><th>PS#</th><th>School</th><th>Absences</th><th>membership</th><th>Absence Rate</th></ReportHeader>
<FLSMapField><textarea></textarea></FLSMapField>
<ExcFrmList></ExcFrmList>
<sqlReportsQ></sqlReportsQ>
<sqlExportsReport></sqlExportsReport>
<ReportDirections><textarea>&lt;strong&gt;Enter a percentage of absenteeism you would like to check&lt;/strong&gt;: Enter a whole number only</textarea></ReportDirections>
<ParameterName1>Start Date</ParameterName1>
<ParameterVal1>9/3/2019</ParameterVal1>
<ParameterCal1>1</ParameterCal1>
<ParameterOpt1></ParameterOpt1>
<ParameterName2>End Date</ParameterName2>
<ParameterVal2>12/20/2019</ParameterVal2>
<ParameterCal2>1</ParameterCal2>
<ParameterOpt2></ParameterOpt2>
<ParameterName3>Enter a percentage of absenteeism you would like to check</ParameterName3>
<ParameterVal3>10</ParameterVal3>
<ParameterCal3></ParameterCal3>
<ParameterOpt3></ParameterOpt3>
<ParameterName4></ParameterName4>
<ParameterVal4></ParameterVal4>
<ParameterCal4></ParameterCal4>
<ParameterOpt4></ParameterOpt4>
<ParameterName5></ParameterName5>
<ParameterVal5></ParameterVal5>
<ParameterCal5></ParameterCal5>
<ParameterOpt5></ParameterOpt5>
<ParameterName6></ParameterName6>
<ParameterVal6></ParameterVal6>
<ParameterCal6></ParameterCal6>
<ParameterOpt6></ParameterOpt6>
<ParameterName7></ParameterName7>
<ParameterVal7></ParameterVal7>
<ParameterCal7></ParameterCal7>
<ParameterOpt7></ParameterOpt7>
<ParameterName8></ParameterName8>
<ParameterVal8></ParameterVal8>
<ParameterCal8></ParameterCal8>
<ParameterOpt8></ParameterOpt8>
<CreateStudentSelectionB>1</CreateStudentSelectionB>
<AddToCurSel>1</AddToCurSel>
<ShowCurSelLine>1</ShowCurSelLine>
<CreateStudentSelection>0</CreateStudentSelection>
<StudentSelectionQuery></StudentSelectionQuery>
<ExecGrp></ExecGrp>
<sqlReportHeader><textarea></textarea></sqlReportHeader>
<sqlReportFooter><textarea></textarea></sqlReportFooter>
<sqlChartsReport></sqlChartsReport>
<InitialsqlChart></InitialsqlChart>
<InitialChartName></InitialChartName>
<HideCopyButton></HideCopyButton>
<HideCSVButton></HideCSVButton>
<HideTabButton></HideTabButton>
<HidePrint></HidePrint>
<HidePDFButton></HidePDFButton>
<ShowJSON></ShowJSON>
<ShowSHC></ShowSHC>
<PdfOrientation></PdfOrientation>
<NoCSVQuotes></NoCSVQuotes>
<NoHeaderRow></NoHeaderRow>
<NoFooterRow></NoFooterRow>
<NoTitleOrHeaderCopy></NoTitleOrHeaderCopy>
<OpeninNewWindow>0</OpeninNewWindow>
<ValueLi3>0</ValueLi3>
<HideParams></HideParams>
<ShowGridlines></ShowGridlines>
<IncludeRowNumber>0</IncludeRowNumber>
<ShowSearchBox>1</ShowSearchBox>
<ShowResultsInfoTop></ShowResultsInfoTop>
<ShowResultsInfo></ShowResultsInfo>
<UseColFilt>1</UseColFilt>
<UseColRe></UseColRe>
<UseFixHdr>1</UseFixHdr>
<NoRowSel></NoRowSel>
<UseRowGroups></UseRowGroups>
<UseRowGroupsOptions>Opt1</UseRowGroupsOptions>
<RowGroupsDesc></RowGroupsDesc>
<DisplayRowGroupsCol></DisplayRowGroupsCol>
<DisplaySubGroupsCol></DisplaySubGroupsCol>
<UseRowGroupsCounts></UseRowGroupsCounts>
<UseRowGroupsPageBreaks></UseRowGroupsPageBreaks>
<ReportNotes><textarea></textarea></ReportNotes>

*/
