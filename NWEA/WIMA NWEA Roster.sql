SELECT
	sch.SCHOOL_NUMBER,
	sch.name "School Name",
	NULL "Previous Instructor ID",
	ss.users_dcid "Instructor ID",
	S_MI_SSF_TSDL_X.REPPIC "PIC",
	u.last_name "Instructor Last Name",
	u.first_name "Instructor First Name",
	substr(u.middle_name, 1, 1) "Instructor Middle Initial",
	u.email_addr "User Name",
	u.email_addr "Email Address",
	replace(crs.course_name, ',', ' ') "Class Name",
	NULL "Previous Student ID",
	s.dcid "Student ID",
	s.STATE_STUDENTNUMBER "UIC",
	s.last_name "Student Last Name",
	s.first_name "Student First Name",
	substr(s.middle_name, 1, 1) "Student Middle Initial",
	to_char(s.dob, 'MM/DD/YYYY') "Student Date of Birth",
	s.gender "Student Gender",
	CASE to_char(s.grade_level)
	WHEN '0' THEN
		'K'
	WHEN '-2' THEN
		'PK'
	WHEN '-1' THEN
		'PK'
	ELSE
		to_char(s.grade_level)
	END "Student Grade",
	CASE s.ethnicity
	WHEN 'A' THEN
		'Asian'
	WHEN 'B' THEN
		'Black or African American'
	WHEN 'H' THEN
		'Hispanic or Latino'
	WHEN 'M' THEN
		'Multi-ethnic'
	WHEN 'I' THEN
		'American Indian or Alaskan Native'
	WHEN 'P' THEN
		'Native Hawaiian or Other Pacific Islander'
	WHEN 'C' THEN
		'White'
	ELSE
		'Not Specified or Other'
	END "Student Ethnic Group Name"
	
FROM
	students s
	JOIN cc ON s.id = cc.studentid
	JOIN sections sec ON cc.sectionid = sec.id
	JOIN courses crs ON sec.course_number = crs.course_number
	JOIN schoolstaff ss ON sec.teacher = ss.id
	JOIN users u ON ss.users_dcid = u.dcid
	JOIN schools sch ON sec.schoolid = sch.school_number
	LEFT OUTER JOIN S_MI_SSF_TSDL_X ON ss.dcid = S_MI_SSF_TSDL_X.schoolstaffdcid

	
WHERE
	sysdate BETWEEN cc.dateenrolled
	AND cc.dateleft
	AND sec.schoolid = 1933
	AND u.last_name NOT LIKE ('TBA%')
	
ORDER BY
	s.last_name,
	s.first_name