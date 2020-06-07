SELECT
  s.dcid,
  s.lastfirst,
  s.grade_level,
  s.ethnicity,
  s.gender,
  s.lunchstatus,
  s_mi_stu_gc_x.flaglep,
  s_mi_stu_gc_x.flagspeced,
  s.student_number,
  schl.name,
  sum(ada.membershipvalue)-sum(ada.attendancevalue) absences,
  sum(ada.membershipvalue) membership,
  round((sum(ada.membershipvalue)-sum(ada.attendancevalue))/sum(ada.membershipvalue)*100,2) absenceRate

FROM students s
  JOIN schools schl ON schl.school_number = s.schoolid
  JOIN ps_adaadm_defaults_all ada ON ada.studentid = s.id
  JOIN s_mi_stu_gc_x ON s.dcid = s_mi_stu_gc_x.studentsdcid

WHERE
  s.enroll_status =0
  AND to_date(ada.calendardate)  > to_date('09/03/2019', 'mm/dd/yyyy')
  AND to_date(ada.calendardate) <= to_date('12/20/2019','mm/dd/yyyy')
  AND ada.membershipvalue > 0
  AND s.schoolid = 9404

GROUP BY
  s.dcid,
  s.lastfirst,
  s.grade_level,
  s.ethnicity,
  s.gender,
  s.lunchstatus,
  s_mi_stu_gc_x.flaglep,
  s_mi_stu_gc_x.flagspeced,
  s.student_number,
  schl.name

HAVING
  round(sum(ada.attendancevalue)/sum(ada.membershipvalue)*100,2) <= 90
ORDER BY s.lastfirst ASC
