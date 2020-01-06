SELECT
 students.dcid,
 schools.school_number,
 schools.name,
 users.dcid,
 users.teachernumber,
 S_MI_SSF_TSDL_X.repPIC,
 users.last_name,
 users.first_name,
 SUBSTR(users.middle_name,0,1),
 users.email_addr,
 users.email_addr,
 courses.course_name,
 NULL,
 students.student_number,
 students.state_studentnumber,
 students.last_name,
 students.first_name,
 SUBSTR(students.middle_name,0,1),
 to_char(students.dob,'MM/DD/YYYY'),
 students.gender,
 CASE to_char(students.grade_level)
    WHEN '0' THEN 'K'
    WHEN '-1' THEN 'PK'
    WHEN '-2' THEN 'PK'
  ELSE to_char(students.grade_level)
 END,
 CASE students.ethnicity
  WHEN to_char('H') THEN 'Hispanic or Latino'
  WHEN to_char('C') THEN 'White'
  WHEN to_char('B') THEN 'Black or African American'
  WHEN to_char('M') THEN 'Multi-ethnic'
  ELSE 'Not Specified or Other'
 END
 
FROM
    students
    JOIN s_mi_stu_gc_x ON s_mi_stu_gc_x.studentsdcid = students.dcid
    JOIN cc ON cc.studentid = students.id
    JOIN sections ON cc.sectionid = sections.id
    JOIN courses ON courses.course_number = cc.course_number
    JOIN schools ON schools.school_number = students.schoolid
    JOIN schoolstaff ON sections.teacher = schoolstaff.id
    JOIN users ON schoolstaff.users_dcid = users.dcid
    LEFT OUTER JOIN S_MI_SSF_TSDL_X ON schoolstaff.dcid = S_MI_SSF_TSDL_X.schoolstaffdcid 
 
 
WHERE
 students.entrydate >= to_date('%param1%','MM/DD/YYYY')
 AND students.schoolid = ~(curschoolid)
 AND cc.termid >= (to_char(students.entrydate,'YYYY') - 1990) * 100
 AND courses.course_name LIKE ('AM%')
 AND students.enroll_status = 0

 
ORDER BY
 users.lastfirst,students.lastfirst
