create or replace view dwd.dwd_advertisement_video_cn_dailyinsightbyhour_view (
     dt                comment "日期，根据date_start转换"
    ,id                comment "自增id"
    ,ad_id             comment "广告id"
    ,ad_status         comment "广告状态"
    ,date_start        comment "投放开始时间"
    ,date_stop         comment "投放结束时间"
    ,ad_name           comment "广告名"
    ,spend             comment "花费金额"
    ,put_data          comment "投放数据"
    ,installs          comment "安装数"
    ,clicks            comment "点击数"
    ,impressions       comment "展示数"
    ,cpc               comment "Cpc"
    ,cpm               comment "Cpm"
    ,cpp               comment "Cpp"
    ,ctr               comment "Ctr"
    ,update_time       comment "更新时间"
    ,mt                comment "平台"
    ,core              comment "core"
    ,product_id        comment "产品id"
    ,roas              comment "Roas"
    ,ad_set_id         comment "广告系列"
    ,ad_camp_id        comment "广告组"
    ,country           comment "国家"
    ,amount            comment "金额"
    ,source_chl        comment "来源渠道"
    ,chl2              comment "Chl2"
    ,create_user
    ,create_type
    ,create_num
    ,rowversion        comment "数据更新版本"
    ,current_language2 comment "注册时语言"
    ,is_remarketing    comment "是否再营销"
    ,account           comment "广告所属账号"
    ,link_click        comment "链接点击数"
    ,conversion        comment "offset转换数"
    ,registration
    ,temp_state
    ,account_id        comment "广告投放账号ID"
)
comment "国内短剧投放小时统计试图"
as
select date(date_start) as dt
     , Id
     , AdId             as ad_id
     , AdStatus         as ad_status
     , date_start
     , date_stop
     , AdName           as ad_name
     , Spend
     , PutData          as put_data
     , Installs
     , Clicks
     , Impressions
     , Cpc
     , Cpm
     , Cpp
     , Ctr
     , UpdateTime       as update_time
     , Mt
     , Core
     , ProductId        as product_id
     , Roas
     , AdSetId          as ad_set_id
     , AdCampId         as ad_camp_id
     , Country
     , Amount
     , SourceChl        as source_chl
     , Chl2
     , CreateUser       as create_user
     , CreateType       as create_type
     , CreateNum        as create_num
     , RowVersion
     , CurrentLanguage2 as current_language2
     , IsRemarketing    as is_remarketing
     , Account
     , LinkClick        as link_click
     , Conversion
     , Registration
     , TempState        as temp_state
     , AccountId        as account_id
  from ods.ods_tidb_sharpengine_ads_global_videoltvdailyinsightbyhour
;