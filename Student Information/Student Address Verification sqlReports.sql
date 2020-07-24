SELECT
	students.dcid,
	chr(60) || 'a href=/admin/students/generaldemographics.html?frn=001'||to_char(students.dcid)||' target=_blank>'||students.student_number||chr(60)||'/a>',
	students.lastfirst,
	chr(60) || 'a href=/admin/contacts/edit.html#?contactid=' || to_char(person.id) || ' target=_blank>' || person.lastname || ', ' || person.firstname || chr(60) || '/a>',
	codeset.code,
	students.street,
	students.city,
	students.zip,
	students.mailing_street,
	students.mailing_city,
	students.mailing_zip,
	personaddress.street,
	personaddress.city,
	personaddress.postalcode,
	chr(60) || 'a href=/admin/students/generaldemographics.html?frn=001'||to_char(students.dcid)||' target=_blank>'|| CASE WHEN students.street = students.mailing_street THEN 'Match' ELSE 'Review' END ||chr(60)||'/a>',
	chr(60) || 'a href=/admin/contacts/edit.html#?contactid=' || to_char(person.id) || ' target=_blank>' || CASE WHEN students.street = personaddress.street THEN 'Match' ELSE 'Review' END || chr(60) || '/a>'

FROM students
	~[if#cursel.%param1%=Yes]
      INNER JOIN ~[temp.table.current.selection:students] stusel ON stusel.dcid=students.dcid
    [/if#cursel]
	JOIN studentcontactassoc ON students.dcid = studentcontactassoc.studentdcid
	JOIN person ON studentcontactassoc.personid = person.id
	JOIN studentcontactdetail ON studentcontactassoc.studentcontactassocid = studentcontactdetail.studentcontactassocid
	JOIN codeset ON studentcontactdetail.relationshiptypecodesetid = codeset.codesetid
	LEFT OUTER JOIN personaddressassoc ON person.id = personaddressassoc.personid
	LEFT OUTER JOIN personaddress ON personaddressassoc.personaddressid = personaddress.personaddressid

WHERE
	studentcontactdetail.liveswithflg = 1
    AND students.schoolid like case when ~(curschoolid)=0 then '%' else '~(curschoolid)' end

ORDER BY
	studentcontactassoc.contactpriorityorder
