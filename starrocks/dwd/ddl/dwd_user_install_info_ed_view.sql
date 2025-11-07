create or replace view dwd.dwd_user_install_info_ed_view
as select id
      ,dt
      ,productid                    as product_id
      ,userid                       as user_id
      ,source
      ,adid                         as ad_id
      ,adtype                       as ad_type
      ,installdate                  as install_date
      ,adaccountid                  as adaccount_id
      ,adsetid                      as adset_id
      ,bookid                       as book_id
      ,creative
      ,installoriginalrequest       as install_original_request
      ,login
      ,uniquecdreaderid             as unique_cdreaderid
      ,country
      ,if(mt is not null and mt <> 0, mt, rawmt)    as mt
      ,core
      ,datainsertdate               as datainsert_date
      ,networkname                  as network_name
      ,chl2
      ,createtime                   as create_time
      ,adgroup_name
      ,currentlanguage2             as current_language2
      ,remarketingtime              as remarketing_time
      ,adqualitystatus              as adquality_status
      ,installdateest               as install_dateest
      ,reinstalldate                as reinstall_date
      ,analysisserverstatus         as analysis_server_status
      ,nextattributetime            as next_attribute_time
      ,nextattributeadid            as next_attribute_adid
      ,nextattributesource          as next_attribute_source
      ,preattributetime             as pre_attribute_time
      ,preattributeadid             as pre_attribute_adid
      ,preattributesource           as pre_attribute_source
      ,isreinstall                  as is_reinstall
      ,preattributedataid           as pre_attribute_dataid
      ,nextattributedataid          as next_attribute_dataid
      ,rawadid                      as raw_ad_id
      ,traceid                      as trace_id
      ,pixelid                      as pixel_id
      ,at
      ,isremarketing                as is_remarketing
      ,nextattributeisremarketing   as next_attribute_isremarketing
      ,preattributeisremarketing    as pre_attribute_isremarketing
      ,remarktimesendtoappserver    as remarktime_sendto_appserver
      ,customaudiences              as custom_audiences
      ,isdelete
      ,row_update_tim
      ,c2rtime
  from ods.ods_sharpengine_ads_hk_bak_if_user_installreferrer
 where productid <> 6883
 union all
select id
      ,date(installdate)             as dt
      ,productid                     as product_id
      ,userid                        as user_id
      ,source,
      ,adid                          as ad_id
      ,adtype                        as ad_type
      ,installdate                   as install_date
      ,adaccountid                   as adaccount_id
      ,adsetid                       as adset_id
      ,bookid                        as book_id
      ,creative,
      ,installoriginalrequest        as install_original_request
      ,login
      ,uniquecdreaderid              as unique_cdreaderid
      ,country
      ,mt
      ,core
      ,datainsertdate                as datainsert_dat
      ,networkname                   as network_name
      ,chl2
      ,createtime                    as create_time
      ,adgroup_name
      ,currentlanguage2              as current_language2
      ,remarketingtime               as remarketing_time
      ,adqualitystatus               as adquality_status
      ,installdateest                as install_dateest
      ,reinstalldate                 as reinstall_date
      ,analysisserverstatus          as analysis_server_status
      ,nextattributetime             as next_attribute_time
      ,nextattributeadid             as next_attribute_adid
      ,nextattributesource           as next_attribute_source
      ,preattributetime              as pre_attribute_time
      ,preattributeadid              as pre_attribute_adid
      ,preattributesource            as pre_attribute_source
      ,isreinstall                   as is_reinstall
      ,preattributedataid            as pre_attribute_dataid
      ,nextattributedataid           as next_attribute_dataid
      ,rawadid                       as raw_ad_id
      ,traceid                       as trace_id
      ,pixelid                       as pixel_id
      ,at
      ,isremarketing                 as is_remarketing
      ,nextattributeisremarketing    as next_attribute_isremarketing
      ,preattributeisremarketing     as pre_attribute_isremarketing
      ,remarktimesendtoappserver     as remarktime_sendto_appserver
      ,customaudiences               as custom_audiences
      ,isdelete
      ,null                          as row_update_time
      ,null                          as c2rtime
from ods.ods_tidb_cdvideo_tidb_xcx_user_attribution
;
