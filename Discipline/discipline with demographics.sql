SELECT
    s.dcid,
    s.student_number,
    chr(60) || 'a href=/admin/students/customlogentry.html?frn=008' || to_char(lg.dcid) || '&studentfrn=001' || to_char(s.dcid)  || ' target=_blank' ||  '>' || s.LastFirst || chr(60) || '/a>',
    s.grade_level,
    to_char(lg.entry_date,'MM/DD/YYYY'),
    CASE
      WHEN s.ethnicity = 'B' THEN 'African-American'
      WHEN s.ethnicity = 'A' THEN 'Asian'
      WHEN s.ethnicity = 'C' THEN 'Caucasian'
      WHEN s.ethnicity = 'H' THEN 'Hispanic'
      WHEN s.ethnicity = 'M' THEN 'Multiracial'
      WHEN s.ethnicity = 'I' THEN 'Native American'
      WHEN s.ethnicity = 'P' THEN 'Pacific Islander'
    END,
    s.gender,
    schools.name,
    CASE
        WHEN state.flagspeced = 1 THEN 'Yes'
        ELSE 'No'
    END,
    CASE
        WHEN state.flaglep = 1 THEN 'Yes'
        ELSE 'No'
    END,
    CASE state.HomelessStatus
        WHEN '10' THEN 'Shelters'
        WHEN '11' THEN 'Transitional Housing'
        WHEN '13' THEN 'Doubled-Up'
        WHEN '14' THEN 'Hotel/Motel'
        WHEN '15' THEN 'Unsheltered'
        ELSE 'No'
    END,
    lg.entry_author,
    lg.subject,
    g.valuet,
    lg.consequence,
    lg.entry


FROM Log lg
    INNER JOIN Students s ON lg.StudentID = s.ID
    LEFT OUTER JOIN Gen g ON lg.subtype = g.value AND g.cat = 'subtype' and g.name=-100000
    INNER JOIN S_MI_STU_GC_X state ON s.dcid = state.studentsdcid
    INNER JOIN schools ON s.schoolid = schools.school_number

WHERE
    s.enroll_status=0
    AND lg.logtypeid = -100000
    AND to_date(to_char(lg.entry_date,'MM/DD/YYYY'),'MM/DD/YYYY') between to_date('%param1%','MM/DD/YYYY') and to_date('%param2%','MM/DD/YYYY')
    AND s.schoolid LIKE CASE WHEN ~(curschoolid)=0 then '%' ELSE '~(curschoolid)' END

ORDER BY
  schools.name, s.lastfirst
