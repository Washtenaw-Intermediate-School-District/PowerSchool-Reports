SELECT
	CASE WHEN PS_AdaAdm_Meeting_Ptod.SCHOOLID != ~(curschoolid) THEN chr(60) || 'span style='||chr(34)||'background-color'||chr(58)||'#F08080'||chr(59)||'display'||chr(58)||'block'||chr(34)||'>'||STUDENTS.home_room|| chr(60) || '/span>' ELSE STUDENTS.hoome_room END,
	SUM(PS_ADAADM_MEETING_PTOD.MEMBERSHIPVALUE),
	SUM(PS_ADAADM_MEETING_PTOD.ATTENDANCEVALUE)

FROM STUDENTS
	JOIN SCHOOLS ON STUDENTS.SCHOOLID = SCHOOLS.SCHOOL_NUMBER
    JOIN PS_AdaAdm_Meeting_Ptod ON STUDENTS.id = PS_ADAADM_MEETING_PTOD.STUDENTID AND PS_ADAADM_MEETING_PTOD.CALENDARDATE = to_date('%param2%','mm/dd/yyyy')	
	
WHERE
	STUDENTS.schoolid like case when ~(curschoolid)=0 then '%' else '~(curschoolid)' end
	AND (STUDENTS.ENTRYDATE >= to_date('%param1%','mm/dd/yyyy') AND STUDENTS.EXITDATE > to_date('%param2%','mm/dd/yyyy'))
	

GROUP BY STUDENTS.HOME_ROOM

ORDER BY STUDENTS.HOME_ROOM