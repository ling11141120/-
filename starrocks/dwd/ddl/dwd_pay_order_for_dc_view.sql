create view dwd.dwd_pay_order_for_dc_view 
as
select date(ordercreatetime)    as dt
      ,id                       as id
      ,account                  as account
      ,userid                   as userid
      ,accountcreatetime        as accountcreatetime
      ,installdate              as installdate
      ,orderserialid            as orderserialid
      ,amount                   as amount
      ,baseamount               as baseamount
      ,rateamount               as rateamount
      ,paysubname               as paysubname
      ,payname                  as payname
      ,country                  as country
      ,ordercreatetime          as ordercreatetime
      ,paysource                as paysource
      ,paysourcename            as paysourcename
      ,appid                    as appid
      ,ostype                   as ostype
      ,dc                       as dc
      ,dcaccount                as dcaccount
      ,mediatype                as mediatype
      ,adcampname               as adcampaignname
      ,adsetname                as adsetname
      ,adname                   as adname
      ,firstopenres             as firstopenres
      ,adid                     as adid
      ,firstopenresid           as firstopenresid
      ,paychanelid              as paychanelid
      ,lp                       as lp
      ,deeplink                 as deeplink
      ,adsetid                  as adsetid
      ,adcampid                 as adcampaignid
      ,shopitemid               as shopitemid
      ,cdcode                   as cdcode
      ,datainserttime           as datainserttime
      ,cooextstatus             as cooextstatus
      ,orderid                  as orderid
      ,notifyadstatus           as notifyadstatus
      ,core                     as core
from ods.ods_tidb_sr_sharpengine_pay_sync_pay_order_for_dc_di
;
