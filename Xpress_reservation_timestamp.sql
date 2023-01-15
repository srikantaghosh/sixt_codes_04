-- Xpress- Manual timestampm for reservations

with doc_started as (
select reservation_id , 
'1.doc_started' AS Event,
AT_TIMEZONE(from_iso8601_timestamp("meta.timestamp"),'UTC') AS TIME
from sds_prod_ingestion_store_public_datalake.reservationbaseddocumentverificationcreatedv1  
where provider = '4' )
,

Doc_Compelted as (

select reservation_id ,
'2.Doc_Compelted' AS Event,
AT_TIMEZONE(from_iso8601_timestamp("meta.timestamp"),'UTC')  AS TIME
from research_Development_shop.reservationbaseddocumentverificationapprovedv1 
where provider = '4' )
,


VehicleListStarted AS (select
cast(b.rsrv_resn as varchar) as reservation_id, 
'3.VehicleListStarted' AS Event,
AT_TIMEZONE(from_iso8601_timestamp(a."meta.timestamp"),'UTC')  AS TIME

from rent_shop.rentreservationvehicleselectionconfigurationcreatedv1  a
inner join rent_shop.ra_fct_rental_activities b
on a.reservation_id = b.rnac_rental_activity_id
where a.source_platform='DC' )

,


Vehicle_EntryScreen AS (

select reservation_id , 
'4.Vehicle_EntryScreen' AS Event,
AT_TIMEZONE(from_iso8601_timestamp("meta.timestamp"),'UTC') AS TIME
from research_development_shop.DigitalCheckoutSummaryLoadsInstrumentEventV1 )

,
entry_screen_error AS (
select reservation_id , 
'5.entry_screen_error' AS Event,
AT_TIMEZONE(from_iso8601_timestamp("meta.timestamp"),'UTC') AS TIME
from "research_development_shop"."digitalcheckoutpaymentinstrumenteventV1"  
where stage in ('ENTRY' ) 
)
,

PaymentCompleted AS (

select reservation_id , 
'6.PaymentCompleted' AS Event,
AT_TIMEZONE(from_iso8601_timestamp("meta.timestamp"),'UTC') AS TIME
from "research_development_shop"."digitalcheckoutpaymentinstrumenteventV1"
where  payment_success = 'True' and stage = 'AUTHORIZE' )
,

final as(
Select * from doc_started
union all
Select * from Doc_Compelted
union all
Select * from VehicleListStarted
union all
Select * from Vehicle_EntryScreen
union all
Select * from entry_screen_error
union all
Select * from PaymentCompleted)

select * from final
where reservation_id='9925764512'
order by Event 
