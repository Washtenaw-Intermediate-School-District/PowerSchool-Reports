SELECT  
sc.name, 
chr(60) || 'a href=/attendance/view/meeting.html?frn=001'||to_char(students.dcid)||' target=_blank>'||st.lastfirst||chr(60)||'/a>', 
st.gender, 
st.State_StudentNumber, 
st.grade_level, 
to_date(st.entrydate,'mm/dd/yyyy'), 
to_date(st.exitdate,'mm/dd/yyyy'),
count(CASE WHEN ac.att_code='' AND a.schoolid IN(7697,1933) THEN 1 WHEN ac.att_code='D1' THEN 1 ELSE NULL END) AS Present,
count(CASE WHEN ac.att_code='' AND a.schoolid NOT IN (7697,1933) THEN 1 ELSE NULL END) AS BLANKCODE,
count(CASE WHEN ac.att_code='AEX' THEN 1 ELSE NULL END) AS AdminExc,
count(CASE WHEN ac.att_code='EL' THEN 1 ELSE NULL END) AS Email,
count(CASE WHEN ac.att_code='EX' THEN 1 ELSE NULL END) AS Exc,
count(CASE WHEN ac.att_code='F2F' THEN 1 ELSE NULL END) AS PhysPres,
count(CASE WHEN ac.att_code='FF' THEN 1 ELSE NULL END) AS InPersOffCamp,
count(CASE WHEN ac.att_code='IM' THEN 1 ELSE NULL END) AS Messaging,
count(CASE WHEN ac.att_code='NA' THEN 1 ELSE NULL END) AS NoAtt,
count(CASE WHEN ac.att_code='PH' THEN 1 ELSE NULL END) AS Phone,
count(CASE WHEN ac.att_code='RLA' THEN 1 ELSE NULL END) AS RemLearnAbsent,
count(CASE WHEN ac.att_code IN ('RLP','RLD1') THEN 1 ELSE NULL END) AS RemLearnPresent,
count(CASE WHEN ac.att_code='T' THEN 1 ELSE NULL END) AS Tardy,
count(CASE WHEN ac.att_code='T1' THEN 1 ELSE NULL END) AS ExtTardy,
count(CASE WHEN ac.att_code='TE' THEN 1 ELSE NULL END) AS TardyExc,
count(CASE WHEN ac.att_code='U' THEN 1 ELSE NULL END) AS Unexc,
count(CASE WHEN ac.att_code='VP' THEN 1 ELSE NULL END) AS VirtPres,

SUM(CASE WHEN ac.att_code IN ('','AEX', 'D1','EL', 'EX', 'FF', 'IM', 'NA', 'PH', 'RLA', 'RLD1','RLP','T','T1','TE','U','VP') THEN 1 ELSE 0 END) As Total,
SUM(CASE WHEN ac.att_code='' AND a.schoolid IN(7697,1933) THEN 1 WHEN ac.att_code IN ('D1','EL','F2F','FF','IM','PH','RLP','RLD1','T','TE') THEN 1 ELSE 0 END) As TwoWays,
CASE WHEN SUM(CASE WHEN ac.att_code='' AND a.schoolid IN(7697,1933) THEN 1 WHEN ac.att_code IN ('D1','EL','F2F','FF','IM','PH','RLP','RLD1','T','TE') THEN 1 ELSE 0 END) >0 THEN 1 ELSE 0 END As TwoWays2,
CASE WHEN SUM(CASE WHEN ac.att_code='' AND a.schoolid IN(7697,1933) THEN 1 WHEN ac.att_code IN ('D1','EL','F2F','FF','IM','PH','RLP','RLD1','T','TE') THEN 1 ELSE 0 END) >1 THEN 1 ELSE 0 END As TwoWays3,
count(CASE WHEN ac.att_code NOT IN ('','AEX', 'D1','EL', 'EX', 'FF', 'IM', 'NA', 'PH', 'RLA', 'RLD1','RLP','T','T1','TE','U','VP') THEN 1 ELSE NULL END) AS Unclassified

FROM students st
    left JOIN (SELECT * FROM attendance WHERE attendance.att_date between '%param1%' and '%param2%') a ON (st.id=a.studentid and st.schoolid=a.schoolid)
    left JOIN attendance_code ac ON ac.id=a.attendance_codeid
    left JOIN Period pe ON a.periodid=pe.id
    LEFT JOIN Schools sc ON st.schoolid = sc.school_number

WHERE 
    (st.exitdate IS NULL OR st.exitdate>='%param1%')
    AND (a.att_date IS NULL OR (a.att_mode_code='ATT_ModeMeeting') )
    AND st.grade_level>-1
    AND st.schoolid like case when ~(curschoolid)=0 then '%' else '~(curschoolid)' end

GROUP BY sc.name, st.lastfirst, st.gender, st.grade_level,st.State_StudentNumber, st.ENTRYDATE, st.exitdate
order by sc.name, st.grade_level, st.lastfirst