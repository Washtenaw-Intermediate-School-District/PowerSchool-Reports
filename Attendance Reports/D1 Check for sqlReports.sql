SELECT
st.dcid, 
sc.name,
chr(60) || 'a href=/admin/attendance/view/meeting.html?frn=001'|| to_char(st.dcid) || ' target=_blank>' || st.student_number || chr(60) || '/a>',
st.lastfirst, 
st.gender, 
st.State_StudentNumber, 
st.grade_level, 
CASE WHEN st.enroll_status = 0 THEN 'Active' ELSE 'Exited' END,
to_char(st.entrydate,'mm/dd/yyyy'), 
to_char(st.exitdate,'mm/dd/yyyy'),
sum(CASE WHEN ac.att_code = 'D1' THEN 1 ELSE 0 END),
listagg (CASE WHEN ac.att_code = 'D1' THEN to_char(a.att_date,'mm/dd/yyyy') END , ',') WITHIN GROUP (Order By a.att_date)

FROM students st
    left JOIN (SELECT * FROM attendance WHERE attendance.att_date between '%param1%' and '%param2%') a ON (st.id=a.studentid and st.schoolid=a.schoolid)
    left JOIN attendance_code ac ON ac.id=a.attendance_codeid
    left JOIN Period pe ON a.periodid=pe.id
    LEFT JOIN Schools sc ON st.schoolid = sc.school_number
~[if#cursel.%param5%=Yes]
INNER JOIN ~[temp.table.current.selection:students] stusel ON stusel.dcid = st.dcid
[/if#cursel]

WHERE 
    (st.exitdate IS NULL OR st.exitdate>'%param1%')
    AND (a.att_date IS NULL OR (a.att_mode_code='ATT_ModeMeeting') )
    AND st.grade_level>-1
    AND st.schoolid like case when ~(curschoolid)=0 then '%' else '~(curschoolid)' end

GROUP BY st.dcid, sc.name, st.student_number, st.lastfirst, st.gender, st.grade_level,st.State_StudentNumber, st.enroll_status,st.ENTRYDATE, st.exitdate
order by sc.name, st.grade_level, st.lastfirst