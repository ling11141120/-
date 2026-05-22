----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_qa_advertise_alarm
-- workflow_version : 12
-- create_user      : linq
-- task_name        : ads_qa_advertise_alarm
-- task_version     : 4
-- update_time      : 2024-10-16 11:52:00
-- sql_path         : \starrocks\tbl_ads_qa_advertise_alarm\ads_qa_advertise_alarm
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_qa_advertise_alarm where dt='${bf_1_dt}';

-- SQL语句
insert into ads.ads_qa_advertise_alarm
with base as(
    select dt,
           product_id,
           case mt when 1 then 'iOS' when 4 then 'Android' else mt end as mt,
           corever,
           book_id,
           case user_type
               when 1 then '新用户'
               when 2 then '老用户' end as user_type,
           case f3_h1
               when 14 then '剪贴板'
               when 1 then 'firebase deeplink'
               when 0 then 'facebook deeplink'
               when 12 then 'install referral'
               when 7 then 'MMP(kochava)'
               when -1 then '不是动态链接'
           else f3_h1
           end as f3,total_num,read_num,read_rate
    from(
        select dt,
               product_id,mt,corever,book_id,
               case when  reg_num=0 then '1'
                   when  reg_num>0 then '2' end as  user_type ,
               if (f3=17,( case when f8=0 then 'DL'
                                when f8=1 then 'UAC归因'
                                when f8=2 then 'IP+UA匹配'
                                when f8=3 then 'IP+core+productid+mt匹配'
                                when f8=4 then 'IP+UA+productid+core)'
                                when f8=5 then 'IP+mt匹配'
                                when f8=6 then 'IP+lazzUA+productid+core'
                                when f8=7 then 'IP+lazzUA'
                            end), f3) as f3_h1,
               count(distinct user_id) as total_num,
               count(distinct first_userid ) read_num,
               count(distinct first_userid )/count(distinct user_id) read_rate
        from ads.ads_report_read_action_info
        where dt ='${bf_1_dt}'
        group by 1,2,3,4,5,6,7
    )a
)
select dt,product_id,ProductTypeName,mt,corever,book_id,user_type,f3,total_num,read_num,read_rate,now() as etl_time
from(
    select base.dt,base.product_id,b.ProductTypeName,base.mt,base.corever,base.book_id,base.user_type,if(base.f3='DL','DL=0',base.f3) as f3,
           total_num,read_num,round(read_rate,4) as read_rate
    from base
    left join (
        SELECT productid, ProductTypeName FROM dim.DIM_ProductType where ProductTypeName not in ('韩语阅读', '菲律宾语')
    )b on base.product_id=b.Productid
)t1
where total_num>10 and
      read_rate<case when f3 in('DL=0') then 0.3
                else 0.7 end
order by 1 desc;

-- SQL语句
-- 不加排序会漏数据;
