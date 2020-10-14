/* Report to Show Ony Students Who Have Had a EL, PH, IM, or D1 between two days */

SELECT  
sc.name, 
st.lastfirst, 
st.student_number, 
st.grade_level, 
to_char(st.entrydate,'mm/dd/yyyy'), 
to_char(st.exitdate,'mm/dd/yyyy'),
count(CASE WHEN ac.att_code='' AND a.schoolid NOT IN (7697,1933) THEN 1 ELSE NULL END) AS Blank,
count(CASE WHEN ac.att_code='D1' THEN 1 ELSE NULL END) AS D1,
count(CASE WHEN ac.att_code='EL' THEN 1 ELSE NULL END) AS EL,
count(CASE WHEN ac.att_code='IM' THEN 1 ELSE NULL END) AS IM,
count(CASE WHEN ac.att_code='PH' THEN 1 ELSE NULL END) AS PH,
SUM(CASE WHEN ac.att_code IN ('D1','EL', 'IM', 'PH') THEN 1 ELSE 0 END) As Total,
SUM(CASE WHEN ac.att_code IN ('F2F','FF','RLP','VP','CA') THEN 1 ELSE 0 END) As P_Total

FROM students st
    left JOIN (SELECT * FROM PSSIS_Attendance_Meeting WHERE PSSIS_Attendance_Meeting.att_date BETWEEN to_date('10/07/2020','mm/dd/yyyy') AND to_date('10/13/2020','mm/dd/yyyy')) a ON (st.id=a.studentid)
    left JOIN attendance_code ac ON ac.id=a.attendance_codeid
    left JOIN Period pe ON a.periodid=pe.id
    LEFT JOIN Schools sc ON st.schoolid = sc.school_number
    	left JOIN CC ON a.ccid = CC.id
    left JOIN teachers ON cc.TEACHERID = TEACHERS.ID



WHERE 
    (st.exitdate IS NULL OR st.exitdate>= to_date('10/07/2020','mm/dd/yyyy'))
    AND (a.att_date IS NULL OR (a.att_mode_code='ATT_ModeMeeting') )
    AND st.grade_level>-1
    AND st.schoolid = 3000
   

GROUP BY 
	sc.name, 
	st.lastfirst, 
	st.gender, 
	st.grade_level,
	st.student_number, 
	st.ENTRYDATE, st.exitdate

HAVING SUM(CASE WHEN ac.att_code IN ('D1','EL', 'IM', 'PH', 'RLD1') THEN 1 ELSE 0 END) > 0
	AND SUM(CASE WHEN ac.att_code IN ('F2F','FF','RLP','VP','CA') THEN 1 ELSE 0 END) = 0

order by sc.name, st.grade_level, st.lastfirst