SELECT
	students.grade_level,
    sum(PS_ADAADM_MEETING_PTOD.MEMBERSHIPVALUE),
    sum(PS_ADAADM_MEETING_PTOD.ATTENDANCEVALUE)
    


FROM STUDENTS
	JOIN SCHOOLS ON STUDENTS.SCHOOLID = SCHOOLS.SCHOOL_NUMBER
    JOIN PS_AdaAdm_Meeting_Ptod ON STUDENTS.id = PS_ADAADM_MEETING_PTOD.STUDENTID AND PS_ADAADM_MEETING_PTOD.CALENDARDATE = to_date('%param2%','mm/dd/yyyy')
	
WHERE
	(STUDENTS.ENTRYDATE >= to_date('%param1%','mm/dd/yyyy') AND STUDENTS.EXITDATE > to_date('%param2%','mm/dd/yyyy'))
    AND STUDENTS.schoolid like case when ~(curschoolid)=0 then '%' else '~(curschoolid)' end
	
GROUP BY students.grade_level
	
ORDER BY
	STUDENTS.GRADE_LEVEL