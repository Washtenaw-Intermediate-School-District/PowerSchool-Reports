SELECT
  schools.school_number,
  schools.name,
  users.teachernumber,
  users.dcid,
  S_MI_SSF_TSDL_X.repPIC,
  users.last_name,
  users.first_name,
  SUBSTR(users.middle_name,0,1),
  users.email_addr,
  users.email_addr,
  courses.course_name,
  NULL,
  students.student_number, --most likely former student ID
  students.dcid,
  students.state_studentnumber,
  students.last_name,
  students.first_name,
  SUBSTR(students.middle_name,0,1),
  to_char(students.dob,'MM/DD/YYYY'),
  students.gender,
  students.grade_level,
  CASE students.ethnicity
    when 'A' then 'Asian'
    when 'B' then 'Black or African American'
    when 'H' then 'Hispanic or Latino'
    when 'M' then 'Multi-ethnic'
    when 'I' then 'American Indian or Alaskan Native'
    when 'P' then 'Native Hawaiian or Other Pacific Islander'
    when 'C' then 'White'
    else 'Not Specified or Other'
  END AS "Ethnicity"

FROM
    students
    JOIN s_mi_stu_gc_x ON s_mi_stu_gc_x.studentsdcid = students.dcid
    JOIN cc ON cc.studentid = students.id
    JOIN sections ON cc.sectionid = sections.id
    JOIN courses ON courses.course_number = cc.course_number
    JOIN schools ON schools.school_number = cc.schoolid
    LEFT OUTER JOIN schoolstaff ON sections.teacher = schoolstaff.id
    LEFT OUTER JOIN users ON schoolstaff.users_dcid = users.dcid AND schoolstaff.schoolid = cc.schoolid
    LEFT OUTER JOIN S_MI_SSF_TSDL_X ON schoolstaff.dcid = S_MI_SSF_TSDL_X.schoolstaffdcid


WHERE
 students.entrydate >= to_date('09/08/2020','MM/DD/YYYY')
 AND students.enroll_status = 0
 AND cc.termid BETWEEN 3000 AND 3001 --only rostering first semester classes
 AND students.grade_level BETWEEN 6 AND 8
 AND users.last_name NOT LIKE ('TBA%')
 

ORDER BY
 users.lastfirst, students.lastfirst
