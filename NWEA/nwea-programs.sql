WITH programs AS (
	SELECT
		s.dcid,
		CASE gcx.flaglep WHEN 1 THEN 'English Language Learner (ELL)'
		ELSE NULL
		END LEP,
		CASE gcx.flagspeced WHEN 1 THEN 'Special Education (SPED)'
		ELSE NULL
		END SpecEd,
		CASE gcx.flagtitle1 WHEN 1 THEN 'Title 1'
		ELSE NULL
		END title_1,
		CASE gcx.flagunacyouth WHEN 1 THEN 'Unaccompanied Youth'
		ELSE NULL
		END unaccyouth,
		CASE gcx.flagearlyon WHEN 1 THEN 'Early On Intervention Student'
		ELSE NULL
		END earlyon,
		CASE gcx.flagadvanced WHEN 1 THEN 'Advanced and Accelerated'
		ELSE NULL
		END advanced,
		CASE gcx.flagalternateed WHEN 1 THEN 'Alternative Education Student'
		ELSE NULL
		END alternative_ed,
		CASE gcx.flagatrisk WHEN 1 THEN 'At Risk Student'
		ELSE NULL
		END atrisk,
		CASE gcx.flagdevretkinder WHEN 1 THEN 'Developmental Retention K'
		ELSE NULL
		END devretkinder,
		CASE gcx.flagearlycollege WHEN 1 THEN 'Early Middle College'
		ELSE NULL
		END earlycollege,
		CASE gcx.flag21cclc WHEN 1 THEN '21st Century Community Learning Cen'
		ELSE NULL
		END CCLC,
		CASE gcx.flagexchangestu WHEN 1 THEN 'Exchange Student'
		ELSE NULL
		END exchangestudent,
		CASE gcx.flaginternational WHEN 1 THEN 'International Student'
		ELSE NULL
		END internationalstudent,
		CASE gcx.flagmigrant WHEN 1 THEN 'Migrant Student'
		ELSE NULL
		END migrantstudent,
		CASE gcx.flagoutofstate WHEN 1 THEN 'Out of State Resident Student'
		ELSE NULL
		END outofstate,
		CASE gcx.flagseattimewaiver WHEN 1 THEN 'Seat-Time Waiver Participant'
		ELSE NULL
		END seattimewaiver,
		CASE gcx.flagsection504 WHEN 1 THEN 'Section 504'
		ELSE NULL
		END section504,
		s.schoolid
	FROM
		students s
		JOIN s_mi_stu_gc_x gcx ON s.dcid = gcx.studentsdcid
	WHERE
		s.enroll_status = 0
),
unpiv AS (
	SELECT
		*
	FROM
		programs unpivot (program_name FOR prgm IN(LEP AS 'LEP',
				speced AS 'SE',
				Title_1 AS 'T1',
				unaccyouth AS 'UY',
				earlyon AS 'EO',
				advanced AS 'AV',
				alternative_ed AS 'AED',
				atrisk AS 'AR',
				devretkinder AS 'DEVK',
				earlycollege AS 'ECOL',
				CCLC AS 'CC',
				exchangestudent AS 'EXCHG',
				internationalstudent AS 'INT',
				migrantstudent AS 'MIG',
				outofstate AS 'OOS',
				seattimewaiver AS 'STW',
				section504 AS 'SEC'))
)
SELECT
	unpiv.dcid,
	unpiv.program_name
FROM
	unpiv
WHERE
	unpiv.schoolid = 9404