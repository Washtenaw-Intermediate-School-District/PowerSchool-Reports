SELECT
  s.dcid,
  s.lastfirst,
  s.grade_level,
  s.student_number,
  schl.name,
  sum(ada.membershipvalue)-sum(ada.attendancevalue) absences,
  sum(ada.membershipvalue) membership,
  round((sum(ada.membershipvalue)-sum(ada.attendancevalue))/sum(ada.membershipvalue)*100,2) absenceRate
FROM students s
  JOIN schools schl ON schl.school_number = s.schoolid
  JOIN ps_adaadm_defaults_all ada ON ada.studentid = s.id
WHERE
  s.enroll_status =0
  AND to_date(ada.calendardate)  > to_date('8/01/'||(~(curyearid)+1990), 'mm/dd/yyyy')
  AND to_date(ada.calendardate) <= to_date(current_date)
  AND ada.membershipvalue > 0
  ~[if.is.a.school]AND s.schoolid = ~(curschoolid)[/if]
GROUP BY
  s.dcid,
  s.lastfirst,
  s.grade_level,
  s.student_number,
  schl.name
HAVING
  round(sum(ada.attendancevalue)/sum(ada.membershipvalue)*100,2) <= 90
ORDER BY s.lastfirst ASC
