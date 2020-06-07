SELECT
    students.dcid,
    chr(60) || 'a href=/admin/students/home.html?frn=001'||to_char(students.dcid)||'>'||students.student_number||chr(60)||'/a>',
    students.LastFirst,
    students.grade_level,
    chr(60) || 'a href=/admin/students/home.html?lsp=/admin/students/customlogentry.html%3Ffrn%3D=008' || to_char(log.dcid) || '&frn=001' || to_char(students.dcid)  || ' target=_blank' ||  '>' || to_char(log.entry_date,'MM/DD/YYYY') || chr(60) || '/a>',
    schools.name,
    log.entry_author,
    gen.valuet,
    CASE
      WHEN log.consequence = 'RC' THEN 'Restorative Conference'
      WHEN log.consequence = 'GRIZ' THEN 'Grizzly Support Center visit'
      WHEN log.consequence = 'INCL' THEN 'Handled in the classroom'
      WHEN log.consequence = 'AA' THEN 'Administrative Intervention'
      WHEN log.consequence = 'ISI' THEN 'In School Intervention'
      WHEN log.consequence = 'ISS' THEN 'In School Suspension'
      WHEN log.consequence = 'ISSL' THEN 'In School Suspension and Law Enforcement Involvement'
      WHEN log.consequence = 'OSS' THEN 'Out of School Suspension'
      WHEN log.consequence = 'OSSL' THEN 'Out of School Suspension and Law Enforcement Involvement'
      WHEN log.consequence = 'DA' THEN 'Detention - After School'
      WHEN log.consequence = 'DL' THEN 'Detention - Lunch'
      WHEN log.consequence = 'DS' THEN 'Detention - Saturday'
      WHEN log.consequence = 'PCA' THEN 'Parent Conference with Administrator'
      WHEN log.consequence = 'PCT' THEN 'Parent Conference with Teacher'
      WHEN log.consequence = 'AC' THEN 'Parent Contact by Administrator'
      WHEN log.consequence = 'TAC' THEN 'Teacher and Administrator Conference'
      WHEN log.consequence = 'SCP' THEN 'Student Must Call Parent'
      WHEN log.consequence = 'SH' THEN 'Sent Home with Parent/Guardian'
      WHEN log.consequence = 'MC' THEN 'Meet with Counselor'
      WHEN log.consequence = 'MS' THEN 'Meet with Social Worker'
      WHEN log.consequence = 'W1' THEN 'Warning - 1st'
      WHEN log.consequence = 'W2' THEN 'Warning - 2nd'
      WHEN log.consequence = 'SS' THEN 'School Service or Community Service'
      WHEN log.consequence = 'WAP' THEN 'Written Apology'
      WHEN log.consequence = 'WAS' THEN 'Writing Assignment'
      WHEN log.consequence = 'R' THEN 'Restitution'
      WHEN log.consequence = 'CC' THEN 'Cafeteria Cleanup'
      WHEN log.consequence = 'LP' THEN 'Loss of Privileges'
      WHEN log.consequence = 'RCTR' THEN 'Removed fr'||'om Class by Teacher Request'
      WHEN log.consequence = 'BS' THEN 'Suspended fr'||'om Riding Bus'
      WHEN log.consequence = 'EXP' THEN 'Expulsion (no services provided)'
      WHEN log.consequence = 'EXPS' THEN 'Expulsion (services provided)'
      WHEN log.consequence = 'O' THEN 'Other - As Specified Below'
    END,
    log.discipline_durationassigned,
    log.discipline_durationactual,
    log.discipline_actiondate,
    to_char(discipline_actiondate,'MM/DD/YYYY') || ' - ' || (
        SELECT
            LISTAGG(attendance_code.att_code,', ') WITHIN GROUP (ORDER BY attendance.att_date DESC)

        FROM
            attendance
            JOIN attendance_code ON attendance.attendance_codeid = attendance_code.id

        WHERE
            attendance.studentid = students.id
            AND att_date = log.discipline_actiondate
    ) ,
    to_char(
        CASE to_char(log.discipline_actiondate+log.discipline_durationactual,'D')
            WHEN '7' THEN log.discipline_actiondate+log.discipline_durationactual+2
            WHEN '1' THEN log.discipline_actiondate+log.discipline_durationactual+1
            ELSE log.discipline_actiondate+log.discipline_durationactual
        END
        ,'MM/DD/YYYY'
    ) || ' - ' || (
        SELECT
            LISTAGG(attendance_code.att_code,', ') WITHIN GROUP (ORDER BY attendance.att_date DESC)

        FROM
            attendance
            JOIN attendance_code ON attendance.attendance_codeid = attendance_code.id

        WHERE
            attendance.studentid = students.id
            AND att_date = CASE to_char(log.discipline_actiondate+log.discipline_durationactual,'D') WHEN '7' THEN log.discipline_actiondate+log.discipline_durationactual+2 WHEN '1' THEN log.discipline_actiondate+log.discipline_durationactual+1 ELSE log.discipline_actiondate+log.discipline_durationactual END
    )

FROM log
    INNER JOIN Students ON log.StudentID = students.ID
    LEFT OUTER JOIN gen ON log.subtype = gen.value AND gen.cat = 'subtype' and gen.name=-100000
    INNER JOIN S_MI_STU_GC_X state ON students.dcid = state.studentsdcid
    INNER JOIN schools ON students.schoolid = schools.school_number

WHERE
    (log.consequence LIKE 'OSS%' OR log.consequence LIKE 'ISS%')
    AND log.entry_date >= to_date('%param1%','MM/DD/YYYY')

ORDER BY
    students.lastfirst, log.entry_date DESC
