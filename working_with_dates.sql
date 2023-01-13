-- Different date functions and logics for daily use

-- Calendar view for Dashboar
date_format(chrs_taken_datm,'%Y-%v') as year_week,
date_format(chrs_taken_datm,'%Y-%m') as year_month,
quarter(chrs_taken_datm) as year_qtr,
date_format(chrs_taken_datm,'%Y') as date_year,

-- First_day_of_the WEEK 
,DATE_ADD('day', -(extract(dow from (email_sent))-1),cast(email_sent as date))

--Time difference:
date_diff('minute', senddate_utc, doc_started_date) as diff_min 

--Time_stamps Coversion

 (cast(replace(substr("meta.timestamp",1,19),'T',' ')as timestamp))

 --UCT Converstion:
 date_add('hour',6,cast(replace(substr("senddate",1,19),'T',' ')as timestamp))

 AT_TIMEZONE(from_iso8601_timestamp("meta.timestamp"),'UTC')


 --UTC TO IST 
cast(at_timezone(from_iso8601_timestamp("meta.timestamp"), 'Asia/Kolkata') as varchar)

date_add('minute',330,cast(replace(substr("meta.timestamp",1,19),'T',' ')as timestamp))

--Timestamp to Time in HH:MM:ss

,substr(cast(email_sent as varchar),11,9) as time

cast(vhcl_return_date as time) as return_time

--Day of the week

format_datetime(cast(date_column as date),'E') AS day_of_week


ifelse(${CalendarGrouping}='Quarter', toString({year_qtr})
                   ,${CalendarGrouping}='Month', toString({year_month}) 
                  ,${CalendarGrouping}='Week', {year_week}
                  ,${CalendarGrouping}='Day', toString({date})
      ,${CalendarGrouping}='Year',toString({date_year}), NULL)

      ,dataplan.id as id
--- Reservation-Person/ID--Rental_Activity

select a.rsrv_resn, a.prsn_peid_m , b.rnac_rental_activity_id
from sds_prod_rent_gg_dwh_current.rs_fct_reservations a
left join rent_shop.ra_fct_rental_activities b
on cast(a.rsrv_resn as varchar) = cast(b.rsrv_resn as varchar)
where a.rsrv_resn IN (9700536099, 9700532684,9700466326)



-- Dashboard Owner:


With Create_Dashboard As (
Select "timestamp","eventtime",substring(useridentity.principalid,position(':' IN useridentity.principalid)+1,LENGTH(useridentity.principalid)) as created_user_id,useridentity.sessioncontext.sessionissuer.username as account,
concat('https://eu-west-1.quicksight.aws.amazon.com/sn/analyses/',replace(replace(regexp_extract(serviceeventdetails, 'analysis/.*?"'),'analysis/',''),'"','')) as analysis,
concat('https://eu-west-1.quicksight.aws.amazon.com/sn/dashboards/',replace(replace(regexp_extract(serviceeventdetails, 'dashboard/.*?"'),'dashboard/',''),'"','')) as dashboard
,replace(replace(regexp_extract(serviceeventdetails, 'dashboard/.*?"'),'dashboard/',''),'"','') as dashboard_id
,replace(replace(regexp_extract(serviceeventdetails, 'analysis/.*?"'),'analysis/',''),'"','') as analysis_id
FROM "default"."quicksight_cloudtrail_logs"
WHERE eventname IN ('CreateDashboard')
AND date_parse("timestamp",'%Y/%m/%d') > date('2021-06-01')
AND year >= '2021')

select * from Create_Dashboard 
where dashboard_id = 'a3339b61-08e2-4c39-bcb4-1794a032068b'

/* Last update on 13th Jan 2023*/
