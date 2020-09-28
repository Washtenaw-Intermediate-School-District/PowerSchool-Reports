SELECT 
stu.dcid
,stu.lastfirst
,stu.student_number
,stu.home_room
,stu.
,CASE 
  WHEN p.firstname IS NULL AND p.lastname IS NULL THEN '-No Name-' 
else 
    p.lastname||' '||p.firstname
END ContactName
,cs.code Relationship
,(
	SELECT LISTAGG(phonenumberasentered || '-' || phonetype, ' / ') WITHIN GROUP (ORDER BY personid, phonenumberpriorityorder) 
	FROM PSSIS_Person_Phone
	WHERE personid = p.id
	GROUP BY personid
) AS Contact_Phone_Numbers
,(
	SELECT LISTAGG(emailaddress, ' / ') WITHIN GROUP(ORDER BY personid, emailaddresspriorityorder)
 	FROM PersonEmailAddressAssoc
 		INNER JOIN EmailAddress ON PersonEmailAddressAssoc.EmailAddressID = EmailAddress.EmailAddressID
 	WHERE personid = p.ID
 	GROUP BY personid
 )  AS Email_Addresses


FROM Students stu
	LEFT OUTER JOIN studentcontactassoc sca ON stu.dcid = sca.studentdcid
	LEFT OUTER  JOIN person p ON sca.personid= p.ID
	LEFT OUTER JOIN studentcontactdetail scd ON scd.studentcontactassocid = sca.studentcontactassocid 
	LEFT OUTER JOIN codeset cs ON cs.codesetid = scd.relationshiptypecodesetid 
	LEFT OUTER JOIN 

WHERE 
	stu.enroll_status = 0 
	AND stu.schoolid IN (1925,1923,3000,9404,1153,1157,2988,1705,798,2062,1938)

ORDER BY stu.lastfirst, sca.contactpriorityorder