SELECT
 schools.school_number,
 schools.name,
 NULL,
 schoolstaff.id,
 S_MI_SSF_TSDL_X.repPIC,
 users.last_name,
 users.first_name,
 users.middle_name,
 users.email_addr,
 users.email_addr,
 courses.course_name,
 NULL,
 students.student_number,
 students.state_studentnumber,
 students.last_name,
 students.first_name,
 SUBSTR(users.middle_name,0,1),
 students.dob,
 students.gender,
 CASE to_char(students.grade_level)
    WHEN '0' THEN 'K'
    WHEN '-1' THEN 'PK'
    WHEN '-2' THEN 'PK'
  ELSE to_char(students.grade_level)
 END,
 CASE students.ethnicity
   when 'A' then 'Asian'
   when 'B' then 'Black or African American'
   when 'H' then 'Hispanic or Latino'
   when 'M' then 'Multi-ethnic'
   when 'I' then 'American Indian or Alaskan Native'
   when 'P' then 'Native Hawaiian or Other Pacific Islander'
   when 'C' then 'White'
   else 'Not Specified or Other'
 END,
 CASE s_mi_stu_gc_x.flaglep
  WHEN 1 THEN 'Yes'
  ELSE 'No'
 END,
 CASE s_mi_stu_gc_x.flagspeced
  WHEN 1 THEN 'Yes'
  ELSE 'No'
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


ORDER BY
 users.lastfirst, courses.course_name, students.lastfirst
