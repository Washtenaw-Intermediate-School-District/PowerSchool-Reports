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
    LEFT JOIN (SELECT * FROM PSSIS_Attendance_Meeting /* using this table in order to filter schools based on enrollment not the student's home school */ 
    	WHERE PSSIS_Attendance_Meeting.att_date BETWEEN to_date('10/07/2020','mm/dd/yyyy') AND to_date('10/13/2020','mm/dd/yyyy')) a ON (st.id=a.studentid) -- these are the two days that need to be updated to reflect the date search range
    LEFT JOIN attendance_code ac ON ac.id=a.attendance_codeid
    LEFT JOIN Period pe ON a.periodid=pe.id
    LEFT JOIN Schools sc ON st.schoolid = sc.school_number
    LEFT JOIN CC ON a.ccid = CC.id
    LEFT JOIN teachers ON cc.TEACHERID = TEACHERS.ID



WHERE 
    (st.exitdate IS NULL OR st.exitdate > to_date('10/07/2020','mm/dd/yyyy')) -- this should be Count Day and vet students who are still active as of Count Day.
    AND (a.att_date IS NULL OR (a.att_mode_code='ATT_ModeMeeting') )
    AND st.grade_level>-1 -- excludes PreSchool students
    AND st.schoolid = 3000 -- school filter to focus in on only one school
   

GROUP BY 
	sc.name, 
	st.lastfirst, 
	st.gender, 
	st.grade_level,
	st.student_number, 
	st.ENTRYDATE, st.exitdate

HAVING SUM(CASE WHEN ac.att_code IN ('D1','EL', 'IM', 'PH', 'RLD1') THEN 1 ELSE 0 END) > 0 -- filters for anyone who has two way communication codes
	AND SUM(CASE WHEN ac.att_code IN ('F2F','FF','RLP','VP','CA') THEN 1 ELSE 0 END) = 0 -- filters out students who have any Count Day present codes

order by sc.name, st.grade_level, st.lastfirst