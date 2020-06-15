select STUDENTS.STUDENT_NUMBER as STUDENT_NUMBER,schools.name as school,
    STUDENTS.LASTFIRST as LASTFIRST,
    STUDENTS.GRADE_LEVEL as GRADE_LEVEL,
(CASE ps_customfields.getcf('students',students.id,'have_compUseForm') WHEN '1' THEN 'YES' WHEN '0' THEN 'NO' ELSE 'PermissionNotSigned' END) AS AUP,
(CASE U_FLAG.FLAG_DISTANCELEARNINGAUP WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'PermissionNotSigned' END) AS DistanceLearningAUP,
(CASE U_FLAG.FLAG_TELETHERAPYAUP WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'PermissionNotSigned' END) AS DistanceAUP,
(CASE U_FLAG.publish_permission WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'PermissionNotSigned' END) AS publishpermission,
 (CASE U_FLAG.military_release WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'PermissionNotSigned' END) AS PermissionMilitary,
 (CASE U_FLAG.health_dept_release WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'PermissionNotSigned' END) AS HealthDept,
(CASE u_flag.flag_er_medicalconsent WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'PermissionNotSigned' END) AS ERMedical,
(CASE u_flag.flag_sharemedicalinfo WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'PermissionNotSigned' END) AS ShareMedical,
(CASE u_flag.flag_nocontacterpermission WHEN 1 THEN 'YES' WHEN 0 THEN 'NO' ELSE 'PermissionNotSigned' END) AS NoContactPermission

From (STUDENTs left join U_FLAG on STUDENTS.DCID =U_FLAG.STUDENTSDCID)
Left join Schools on students.schoolid =schools.school_number
WHERE students.enroll_status = 0
ORDER BY schools.name, students.Last_Name, students.First_Name
