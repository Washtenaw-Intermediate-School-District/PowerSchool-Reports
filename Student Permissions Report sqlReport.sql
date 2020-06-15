select
  chr(60) || 'a href=/admin/students/PermissionForm.html?frn=001'||to_char(students.dcid)||' target=_blank>'||students.student_number||chr(60)||'/a>',
  schools.name,
  STUDENTS.LASTFIRST,
  STUDENTS.GRADE_LEVEL,
  (CASE ps_customfields.getcf('students',students.id,'have_compUseForm') WHEN '1' THEN 'YES' WHEN '0' THEN 'NO' ELSE 'Permission Not Signed' END),
  (CASE U_FLAG.FLAG_DISTANCELEARNINGAUP WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'Permission Not Signed' END),
  (CASE U_FLAG.FLAG_TELETHERAPYAUP WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'Permission Not Signed' END),
  (CASE U_FLAG.publish_permission WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'Permission Not Signed' END),
  (CASE U_FLAG.military_release WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'Permission Not Signed' END),
  (CASE U_FLAG.health_dept_release WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'Permission Not Signed' END),
  (CASE u_flag.flag_er_medicalconsent WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'Permission Not Signed' END),
  (CASE u_flag.flag_sharemedicalinfo WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'Permission Not Signed' END),
  (CASE u_flag.flag_nocontacterpermission WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'Permission Not Signed' END)

From
  (STUDENTs left join U_FLAG on STUDENTS.DCID =U_FLAG.STUDENTSDCID)
  Left join Schools on students.schoolid =schools.school_number
  ~[if#cursel.%param1%=Yes]
      INNER JOIN ~[temp.table.current.selection:students] stusel ON stusel.dcid=students.dcid
  [/if#cursel]

WHERE
  students.enroll_status = 0
  AND students.schoolid like case when ~(curschoolid)=0 then '%' else '~(curschoolid)' end

ORDER BY
  schools.name,
  students.Last_Name,
  students.First_Name
