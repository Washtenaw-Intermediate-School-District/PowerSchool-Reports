SELECT 
stu.dcid,
stu.lastfirst,
stu.student_number,
stu.home_room,
sca.contactpriorityorder,
CASE 
    WHEN p.firstname IS NULL AND p.lastname IS NULL THEN '-No Name-' 
    ELSE p.lastname||' '||p.firstname
END ContactName,
cs.code Relationship,
(
    SELECT LISTAGG(phonenumberasentered, ' / ') WITHIN GROUP (ORDER BY personid, phonenumberpriorityorder) 
    FROM personphonenumberassoc
    WHERE personid = p.id
    GROUP BY personid
) AS Contact_Phone_Numbers,
(
    SELECT LISTAGG(emailaddress, ' / ') WITHIN GROUP(ORDER BY personid, emailaddresspriorityorder)

    FROM PersonEmailAddressAssoc
        INNER JOIN EmailAddress ON PersonEmailAddressAssoc.EmailAddressID = EmailAddress.EmailAddressID

    WHERE personid = p.ID

    GROUP BY personid
)  AS Email_Addresses,
(CASE scd.iscustodial WHEN 1 THEN 'Yes' ELSE 'No' END) Custodial,
(CASE scd.liveswithflg WHEN 1 THEN 'Yes' ELSE 'No' END) Lives_With,
to_char(scd.startdate,'mm/dd/yyyy'),
to_char(scd.enddate,'mm/dd/yyyy')

FROM Students stu
    LEFT OUTER JOIN studentcontactassoc sca ON stu.dcid = sca.studentdcid
    LEFT OUTER  JOIN person p ON sca.personid= p.ID
    LEFT OUTER JOIN studentcontactdetail scd ON scd.studentcontactassocid = sca.studentcontactassocid 
    LEFT OUTER JOIN codeset cs ON cs.codesetid = scd.relationshiptypecodesetid 

WHERE stu.enroll_status = 0
    AND scd.isactive = 1

ORDER BY stu.lastfirst, sca.contactpriorityorder