SELECT
	students.student_number,
	students.lastfirst,
	students.grade_level,
	schools.name,
	students.street,
	students.city,
	students.zip,
	students.mailing_street,
	students.mailing_city,
	students.mailing_zip,
	students.geocode

FROM
	students
	JOIN schools ON students.schoolid = schools.school_number

WHERE
	students.enroll_status IN (-1,0)
	AND schoolid IN (1925,1923,3000,9404,1153,1157,2988,1705,798,2062,1938)
	AND (to_char(students.entrydate,'YYYY')-1990) >= ~(curyearid)
