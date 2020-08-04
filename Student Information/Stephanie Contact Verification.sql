select
    students.lastfirst,
    contacts.person1_lastname,
    contacts.person1_firstname,
    contacts.person1_email1,
    contacts.person1_phonenumber1,
    contacts.person1_address1,
    contacts.person2_lastname,
    contacts.person2_firstname,
    contacts.person2_email1,
    contacts.person2_phonenumber1,
    contacts.person2_address1,
    contacts.person3_lastname,
    contacts.person3_firstname,
    contacts.person3_email1,
    contacts.person3_phonenumber1,
    contacts.person3_address1
from
    students
    left outer join (
        select
            *
        from (
            select
                studentcontactassoc.studentdcid,
                row_number() over (partition by studentcontactassoc.studentdcid order by studentcontactassoc.contactpriorityorder) R,
                person.lastname,
                person.firstname,
                personemail.email1,
                personemail.email2,
                personemail.email3,
                personphonenumber.phonenumber1,
                personphonenumber.phonenumber2,
                personphonenumber.phonenumber3,
                personaddress.address1,
                personaddress.address2,
                personaddress.address3
            from   
                studentcontactassoc
                left outer join person on studentcontactassoc.personid = person.id   
                left outer join (
                    select
                        *
                    from (       
                        select
                            personemailaddressassoc.personid,
                            emailaddress.emailaddress,
                            row_number() over (partition by personemailaddressassoc.personid order by personemailaddressassoc.emailaddresspriorityorder) R
                        from
                            personemailaddressassoc
                            left outer join emailaddress on personemailaddressassoc.emailaddressid = emailaddress.emailaddressid
                    )
                    pivot (
                        max(emailaddress)
                        for R in (1 email1, 2 email2, 3 email3)
                    )
                ) personemail on person.id = personemail.personid   
                left outer join (
                    select
                        *
                    from (       
                        select
                            personphonenumberassoc.personid,
                            phonenumber.phonenumber,
                            row_number() over (partition by personphonenumberassoc.personid order by personphonenumberassoc.phonenumberpriorityorder) R
                        from
                            personphonenumberassoc
                            left outer join phonenumber on personphonenumberassoc.phonenumberid = phonenumber.phonenumberid
                    )
                    pivot (
                        max(phonenumber)
                        for R in (1 phonenumber1, 2 phonenumber2, 3 phonenumber3)
                    )
                ) personphonenumber on person.id = personphonenumber.personid   
                left outer join (
                    select
                        *
                    from (       
                        select
                            personaddressassoc.personid,
                            case when personaddress.personaddressid is not null then personaddress.street || ' / ' || personaddress.city || ', ' || state.code || personaddress.postalcode else '' end address,
                            row_number() over (partition by personaddressassoc.personid order by personaddressassoc.addresspriorityorder) R
                        from
                            personaddressassoc
                            left outer join personaddress on personaddressassoc.personaddressid = personaddress.personaddressid
                            left outer join codeset state on personaddress.statescodesetid = state.codesetid
                    )
                    pivot (
                        max(address)
                        for R in (1 address1, 2 address2, 3 address3)
                    )
                ) personaddress on person.id = personaddress.personid   
        )
        pivot (
            max(lastname) lastname,
            max(firstname) firstname,
            max(email1) email1,
            max(email2) email2,
            max(email3) email3,
            max(phonenumber1) phonenumber1,
            max(phonenumber2) phonenumber2,
            max(phonenumber3) phonenumber3,
            max(address1) address1,
            max(address2) address2,
            max(address3) address3
            for R in (1 person1, 2 person2, 3 person3, 4 person4, 5 person5, 6 person6)
        )
    ) contacts on students.dcid = contacts.studentdcid
where
    students.enroll_status = 0
    --and students.schoolid = 7871
   -- and students.grade_level = 9
   AND students.grade_level = 11
   AND students.schoolid IN (1925,1923,3000,9404,1153,1157,2988,1705,798,2062,1938)
order by
    students.lastfirst