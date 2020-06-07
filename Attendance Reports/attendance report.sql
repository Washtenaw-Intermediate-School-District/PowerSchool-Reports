WITH secmeets AS (
    SELECT
        cc.id    ccid,
        sec.id   secid,
        s.id     sid,
        s.lastfirst,
        cc.studentid,
        cc.schoolid,
        sm.period_number,
        sm.cycle_day_letter,
        cc.dateenrolled,
        cc.dateleft
    FROM
        cc
        JOIN sections          sec ON abs(cc.sectionid) = sec.id
        JOIN students          s ON cc.studentid = s.id
        JOIN section_meeting   sm ON sec.id = sm.sectionid
    WHERE
        s.schoolid = 1923
        AND s.id = 435
),
caldays as (select cd.schoolid,p.period_number, cyd.abbreviation, cd.date_value
from calendar_day cd
join bell_schedule bs on cd.bell_schedule_id=bs.id
join bell_schedule_items bsi on bs.id=bsi.bell_schedule_id
join period p on bsi.period_id=p.id
join cycle_day cyd on cd.cycle_day_id=cyd.id
where cd.insession=1
and cd.date_value >= to_date('09/03/2019','MM/DD/YYYY')
order by cd.schoolid, cd.date_value, p.period_number
),
pa as (select att.studentid, to_char(att.att_date, 'MM/DD/YYYY') adate, count(atc.att_code) acount
from attendance att
join attendance_code atc on att.attendance_codeid = atc.id
join cc on att.ccid = cc.id
join sections sec on abs(cc.sectionid) = sec.id and sec.exclude_ada<>1
join courses crs on sec.course_number = crs.course_number and crs.exclude_ada<>1
join schools sch on att.schoolid = sch.school_number
where atc.att_code in ('U','EX','OSS','OSSL') AND att.att_date >= to_date('09/03/2019','MM/DD/YYYY')
group by att.studentid, to_char(att.att_date, 'MM/DD/YYYY')
),
pp as (select secmeets.studentid, to_char(caldays.date_value, 'MM/DD/YYYY') pdate, count(secmeets.studentid) pcount
from secmeets
join caldays on secmeets.period_number=caldays.period_number and secmeets.cycle_day_letter=caldays.abbreviation and secmeets.schoolid=caldays.schoolid and caldays.date_value between secmeets.dateenrolled and secmeets.dateleft
join schools sch on secmeets.schoolid = sch.school_number
group by secmeets.studentid, to_char(caldays.date_value, 'MM/DD/YYYY'))

select pp.studentid, pp.pdate, pa.acount, pp.pcount, round((pa.acount/pp.pcount)*100,2)
from pp
join pa on pp.studentid = pa.studentid and pp.pdate=pa.adate
order by to_date(pp.pdate,'MM/DD/YYYY')
