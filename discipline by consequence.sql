select 
	case when to_char(l.consequence) is null then 'No Subtype Given' else to_char(l.consequence) end as sub, count(l.id)

from log l

where l.logtypeid = -100000
	and l.schoolid = 1153
	and to_date(to_char(l.entry_date, 'MM/DD/YYYY'),'MM/DD/YYYY') between to_date('09/03/2019', 'MM/DD/YYYY') and to_date('12/12/2019', 'MM/DD/YYYY')

group by to_char(l.consequence)

order by count(l.id) DESC
