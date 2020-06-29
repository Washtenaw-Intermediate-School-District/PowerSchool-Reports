SELECT
    s.dcid,
    s.student_number,
    s.lastfirst,
    (
      SELECT
        CASE
            WHEN lg.entry_date BETWEEN stu.entrydate AND stu.exitdate THEN stu.grade_level
            WHEN lg.entry_date BETWEEN reenrollments.entrydate AND reenrollments.exitdate THEN reenrollments.grade_level
            ELSE 5
        END
      FROM students stu JOIN reenrollments ON stu.id = reenrollments.studentid
      WHERE stu.student_number = s.student_number AND lg.entry_date BETWEEN reenrollments.entrydate AND reenrollments.exitdate
    ) AS "Grade Level",
    to_char(lg.entry_date,'MM/DD/YYYY'),
    CASE
      WHEN s.ethnicity = 'B' THEN 'African-American'
      WHEN s.ethnicity = 'A' THEN 'Asian'
      WHEN s.ethnicity = 'C' THEN 'Caucasian'
      WHEN s.ethnicity = 'H' THEN 'Hispanic'
      WHEN s.ethnicity = 'M' THEN 'Multiracial'
      WHEN s.ethnicity = 'I' THEN 'Native American'
      WHEN s.ethnicity = 'P' THEN 'Pacific Islander'
    END AS "Ethnicity",
    s.gender,
    schools.name,
    CASE
        WHEN state.flagspeced = 1 THEN 'Yes'
        ELSE 'No'
    END AS "SPED",
    CASE
        WHEN state.flaglep = 1 THEN 'Yes'
        ELSE 'No'
    END AS "LEP",
    CASE state.HomelessStatus
        WHEN '10' THEN 'Shelters'
        WHEN '11' THEN 'Transitional Housing'
        WHEN '13' THEN 'Doubled-Up'
        WHEN '14' THEN 'Hotel/Motel'
        WHEN '15' THEN 'Unsheltered'
        ELSE 'No'
    END AS "Homeless",
    lg.entry_author,
    lg.subject,
    g.valuet,
    lg.consequence,
    lg.entry


FROM Log lg
    INNER JOIN Students s ON lg.StudentID = s.ID
    LEFT OUTER JOIN Gen g ON lg.subtype = g.value AND g.cat = 'subtype' and g.name=-100000
    INNER JOIN S_MI_STU_GC_X state ON s.dcid = state.studentsdcid
    INNER JOIN schools ON lg.schoolid = schools.school_number

WHERE
    lg.logtypeid = -100000
    AND to_date(to_char(lg.entry_date,'MM/DD/YYYY'),'MM/DD/YYYY') BETWEEN to_date('%param1%','MM/DD/YYYY') and to_date('%param2%','MM/DD/YYYY')
    AND (lg.schoolid LIKE CASE WHEN ~(curschoolid)=0 then '%' ELSE '~(curschoolid)' END OR s.schoolid = 999999)

ORDER BY
  schools.name, s.lastfirst
