with secmeets as (
  select
    cc.id ccid,
    sec.id secid,
    s.id sid,
    cc.studentid,
    cc.schoolid,
    sm.period_number,
    sm.cycle_day_letter,
    cc.dateenrolled,
    cc.dateleft
  from cc
    join sections sec on abs(cc.sectionid)=sec.id
    join students s on cc.studentid=s.id
    join section_meeting sm on sec.id=sm.sectionid
  ),
  caldays as (
    select
      cd.schoolid,
      p.period_number,
      cyd.abbreviation,
      cd.date_value
    from calendar_day cd
      join bell_schedule bs on cd.bell_schedule_id=bs.id
      join bell_schedule_items bsi on bs.id=bsi.bell_schedule_id
      join period p on bsi.period_id=p.id
      join cycle_day cyd on cd.cycle_day_id=cyd.id
    where
      cd.insession=1
      and cd.date_value < sysdate
    order by
      cd.schoolid,
      cd.date_value,
      p.period_number
  ),
  pa as (
    select
      sch.name aname,
      to_char(att.att_date, 'MONTH,YYYY') adate,
      count(atc.att_code) acount
    from attendance att
      join attendance_code atc on att.attendance_codeid = atc.id
      join cc on att.ccid = cc.id
      join sections sec on abs(cc.sectionid) = sec.id and sec.exclude_ada<>1
      join courses crs on sec.course_number = crs.course_number and crs.exclude_ada<>1
      join schools sch on att.schoolid = sch.school_number
    where
      atc.att_code in ('U','EX','OSS','OSSL')
    group by
      sch.name,
      to_char(att.att_date, 'MONTH,YYYY')
    order by
      sch.name,
      to_char(att.att_date, 'MONTH,YYYY')
  ),
  pp as (
    select
      sch.name pname,
      to_char(caldays.date_value, 'MONTH,YYYY') pdate,
      count(secmeets.studentid) pcount
    from secmeets
      join caldays on secmeets.period_number=caldays.period_number and secmeets.cycle_day_letter=caldays.abbreviation and secmeets.schoolid=caldays.schoolid and caldays.date_value between secmeets.dateenrolled and secmeets.dateleft
      join schools sch on secmeets.schoolid = sch.school_number
    group by
      sch.name,
      to_char(caldays.date_value, 'MONTH,YYYY')
    order by
      sch.name,
      to_char(caldays.date_value, 'MONTH,YYYY')
  )

select
  pp.pname,
  pp.pdate,
  pp.pcount,
  pa.acount,
  cast(round((pa.acount/pp.pcount)*100,2) as varchar(10))||'%' as absent_percentage

from pp
  join pa on pp.pname=pa.aname and pp.pdate=pa.adate
