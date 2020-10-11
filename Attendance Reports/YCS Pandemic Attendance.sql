SELECT
    STUDENTS.student_number,
    STUDENTS.LastFirst,
    STUDENTS.grade_level,
    SCHOOLS.name,
    STUDENTS.TRACK,
    to_char(STUDENTS.entrydate,'mm/dd/yyyy'),
    to_char(STUDENTS.exitdate,'mm/dd/yyyy'),
	SUM (CASE WHEN PRESENCE_STATUS_CD = 'Present' THEN 1 ELSE 0 END) AS "present codes",
    SUM (CASE WHEN PRESENCE_STATUS_CD = 'Absent' THEN 1 ELSE 0 END) AS "absent codes",
    OA."totalPossiblePeriods",
    ROUND( (CASE WHEN SUM(CASE WHEN PRESENCE_STATUS_CD = 'Present' THEN 1 ELSE 0 END) > OA."totalPossiblePeriods" THEN OA."totalPossiblePeriods" ELSE SUM(CASE WHEN PRESENCE_STATUS_CD = 'Present' THEN 1 ELSE 0 END) END)  / OA."totalPossiblePeriods" * 100,2) AS "pct periods",
    MEM."memValue" AS "adm attn",
    calDays."days",
    MEM."memValue" / calDays."days" * 100 AS "pct attn",
    ((CASE WHEN SUM(CASE WHEN PRESENCE_STATUS_CD = 'Present' THEN 1 ELSE 0 END) >= 2 THEN 2 ELSE SUM(CASE WHEN PRESENCE_STATUS_CD = 'Present' THEN 1 ELSE 0 END) END) / 2) AS "min two way pct"

FROM STUDENTS
    JOIN S_MI_STU_GC_X state ON STUDENTS.dcid = state.studentsdcid
    JOIN SCHOOLS ON STUDENTS.schoolid = SCHOOLS.school_number
    JOIN (
        SELECT
        s1.dcid,
        COUNT(distinct courses.course_number) * COUNT (distinct DATE_VALUE) as "totalPossiblePeriods"
	
	FROM
		STUDENTS s1
		JOIN CC ON s1.ID = CC.STUDENTID AND abs(CC.TERMID) >= 3000
		JOIN SECTIONS ON abs(CC.SECTIONID) = SECTIONS.ID
		JOIN COURSES ON SECTIONS.COURSE_NUMBER = COURSES.COURSE_NUMBER
		JOIN TERMS ON SECTIONS.TERMID = TERMS.ID
			AND SECTIONS.SCHOOLID = TERMS.SCHOOLID
		JOIN SECTION_MEETING ON SECTIONS.ID = SECTION_MEETING.SECTIONID
		JOIN TEACHERS ON SECTIONS.TEACHER = TEACHERS.ID
		JOIN PERIOD ON SECTION_MEETING.PERIOD_NUMBER = PERIOD.PERIOD_NUMBER
			AND SECTION_MEETING.SCHOOLID = PERIOD.SCHOOLID
			AND SECTION_MEETING.YEAR_ID = PERIOD.YEAR_ID
		JOIN CYCLE_DAY ON SECTION_MEETING.CYCLE_DAY_LETTER = CYCLE_DAY.LETTER
			AND SECTION_MEETING.SCHOOLID = CYCLE_DAY.SCHOOLID
			AND SECTION_MEETING.YEAR_ID = CYCLE_DAY.YEAR_ID
		JOIN CALENDAR_DAY ON SECTIONS.SCHOOLID = CALENDAR_DAY.SCHOOLID
			AND CYCLE_DAY.id = CALENDAR_DAY.CYCLE_DAY_ID
			AND CALENDAR_DAY.DATE_VALUE BETWEEN to_date('10/05/2020', 'mm/dd/yyyy') AND to_date('10/09/2020', 'mm/dd/yyyy')
		JOIN BELL_SCHEDULE_ITEMS ON BELL_SCHEDULE_ITEMS.BELL_SCHEDULE_ID = CALENDAR_DAY.BELL_SCHEDULE_ID
			AND BELL_SCHEDULE_ITEMS.PERIOD_ID = PERIOD.ID
		
	WHERE
		s1.entrydate >= to_date('09/08/2020', 'mm/dd/yyyy')
		--AND s1.exitdate > to_date('10/09/2020', 'mm/dd/yyyy')
        AND BELL_SCHEDULE_ITEMS.ADA_CODE = 1
        AND sections.EXCLUDE_ADA = 0
        AND (CASE WHEN CALENDAR_DAY.note LIKE('Independent%') THEN 'Friday' ELSE 'MTWH' END) <> 'Friday'
        AND s1.schoolid IN (1925,1923,3000,9404,1153,1157,2988,1705,798,2062,1938)
        
        
	GROUP BY s1.DCID
    ) OA ON STUDENTS.dcid = OA.dcid
    JOIN (
		SELECT
            studentid,
			sum(attendancevalue) AS "memValue"
		FROM
			PS_ADAADM_MEETING_PTOD
		WHERE
			CALENDARDATE BETWEEN to_date('10/05/2020', 'mm/dd/yyyy')
			AND to_date('10/09/2020', 'mm/dd/yyyy')
        GROUP BY studentid
    ) MEM ON STUDENTS.ID = MEM.studentid
    OUTER APPLY (
		SELECT
			count(id) AS "days"
		FROM
			CALENDAR_DAY
		WHERE
			DATE_VALUE BETWEEN to_date('10/05/2020', 'mm/dd/yyyy')
			AND to_date('10/09/2020', 'mm/dd/yyyy')
			AND SCHOOLID = STUDENTS.schoolid
			AND INSESSION = 1
    ) calDays
    LEFT OUTER JOIN PSSIS_ATTENDANCE_MEETING ATT ON STUDENTS.id = ATT.STUDENTID AND att.att_date BETWEEN to_date('10/05/2020','MM/DD/YYYY') AND to_date('10/09/2020','MM/DD/YYYY') AND ATT.ATT_CODE IS NOT NULL

WHERE
	
	students.grade_level >= 0
    --AND STUDENTS.STUDENT_NUMBER = 107237
    
GROUP BY
	STUDENTS.dcid,
	STUDENTS.student_number,
	STUDENTS.LastFirst,
	STUDENTS.grade_level,
	SCHOOLS.name,
	STUDENTS.TRACK,
	STUDENTS.ENTRYDATE,
	STUDENTS.EXITDATE,
	oa."totalPossiblePeriods",
    MEM."memValue",
    calDays."days"

ORDER BY
    STUDENTS.lastfirst