SELECT

        stu.DCID,

        stu.STUDENT_NUMBER,

        stu.LASTFIRST,

        stu.GRADE_LEVEL,

        att.att_code,

        SUM(adaadm.MEMBERSHIPVALUE) EnrolledDays,

        SUM(adaadm.ATTENDANCEVALUE) Attended,

        SUM(adaadm.MEMBERSHIPVALUE)-SUM(adaadm.ATTENDANCEVALUE) AS Absences,

        --Total UNEXCUSED absences using the unexcused absence codes    

        SUM(adaadm.MEMBERSHIPVALUE)-SUM(CASE 

           WHEN att.ATT_CODE IN('A','CR','IO','R','U','U3','U4','U4','U5','U5','U6','U7','U8','U9') 

              THEN adaadm.ATTENDANCEVALUE 

           ELSE adaadm.MEMBERSHIPVALUE END) AS Unexcused,

        --Percentage UNEXCUSED absences percentage using the unexcused absence codes      

        ROUND((SUM(adaadm.MEMBERSHIPVALUE)-SUM(CASE 

            WHEN att.ATT_CODE IN('A','CR','IO','R','U','U3','U4','U4','U5','U5','U6','U7','U8','U9') 

            THEN adaadm.ATTENDANCEVALUE 

            ELSE adaadm.MEMBERSHIPVALUE END))/NULLIF(SUM(adaadm.MEMBERSHIPVALUE),0)*100,2) as UnexcusedPct

FROM

        STUDENTS stu

        INNER JOIN PS_ADAADM_DEFAULTS_ALL adaadm

                ON stu.ID = adaadm.STUDENTID AND adaadm.schoolid = stu.schoolid

        LEFT OUTER JOIN (

                SELECT

                        ATTENDANCE.STUDENTID,

                        ATTENDANCE.ATT_DATE,

                        ATTENDANCE_CODE.ATT_CODE

                FROM

                        ATTENDANCE

                        JOIN ATTENDANCE_CODE ON ATTENDANCE.ATTENDANCE_CODEID = ATTENDANCE_CODE.ID

                WHERE

                        ATT_DATE BETWEEN TO_DATE('8/17/2019','MM/DD/YYYY') AND TO_DATE('5/20/2020','MM/DD/YYYY')

                        and ATTENDANCE.ATT_MODE_CODE='ATT_ModeDaily'

                ) att

                ON stu.ID = att.STUDENTID

                AND adaadm.CALENDARDATE = att.ATT_DATE

               

WHERE

        adaadm.CALENDARDATE BETWEEN TO_DATE('8/17/2019','MM/DD/YYYY') AND TO_DATE('5/20/2020','MM/DD/YYYY')

        --AND stu.SCHOOLID = 8

        

GROUP BY

        stu.DCID,

        stu.STUDENT_NUMBER,

        stu.LASTFIRST,

        stu.GRADE_LEVEL,

        att.att_code

 

ORDER BY

        stu.GRADE_LEVEL,

        stu.LASTFIRST