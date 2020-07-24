SELECT
	students.dcid,
	students.student_number,
	students.lastfirst,
	person.lastname || ', ' || person.firstname AS "Name",
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
	CASE WHEN students.street = students.mailing_street THEN 'Match' ELSE 'Review' END AS "Home = Mailing",
	CASE WHEN students.street = personaddress.street THEN 'Match' ELSE 'Review' END AS "Home = Contact"

FROM students
	JOIN studentcontactassoc ON students.dcid = studentcontactassoc.studentdcid
	JOIN person ON studentcontactassoc.personid = person.id
	JOIN studentcontactdetail ON studentcontactassoc.studentcontactassocid = studentcontactdetail.studentcontactassocid
	JOIN codeset ON studentcontactdetail.relationshiptypecodesetid = codeset.codesetid
	LEFT OUTER JOIN personaddressassoc ON person.id = personaddressassoc.personid
	LEFT OUTER JOIN personaddress ON personaddressassoc.personaddressid = personaddress.personaddressid

WHERE
	studentcontactdetail.liveswithflg = 1
    AND students.student_number IN (103212,313378,313379,313334,110448,312709,312220,311965,311773,104543,102925,310963,102551,102577,102472,312919,103494,102653,110389,102681,311241,102982,102559,109172,103735,102863,103547,311324,105897,313108,311846,105528,102793,103454,313385,310988,103638,104439,109585,107417,313277,103610,310849,102458,102455,103029,103436,109257,107966,312626,106663,104461,313342,312847,102544,102630,312953,102676,102879,102834,106923,103541,312166,103485,105878,103629,109693,102933,103531,102578,102481,103178,103496,312218,102945,103030,312563,110539,311762,102977,109918,103487,310989,312727,109852,103101,311684,312285,103662,102663,312534,104239,312969,313347,103220,311645,102694,107370,313256,103525,103597,311025,104921,312281,313101,102886,103017,311021,102691,104389,312859,103003,310762,108021,312627,312821,103132,103175,102843,102932,102571,102794,313136,106761,108868,102633,103432,110510,103118,103587,312582,102628,102850,103202,313360,110786,103623,313241,104258,312625,310820,103582,103404,103083,311621,103483,103701,312665,311328,102520,106846,103561,109118,104464,310851,102574,103721,103603,312647,109636,103151,312604)

ORDER BY
	studentcontactassoc.contactpriorityorder
