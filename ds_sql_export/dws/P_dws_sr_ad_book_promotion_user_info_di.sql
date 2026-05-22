----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_sr_ad_book_promotion_user_info_di
-- workflow_version : 12
-- create_user      : yanxh
-- task_name        : dws_sr_ad_book_promotion_user_info_di
-- task_version     : 12
-- update_time      : 2024-10-16 11:19:15
-- sql_path         : \starrocks\tbl_dws_sr_ad_book_promotion_user_info_di\dws_sr_ad_book_promotion_user_info_di
----------------------------------------------------------------
-- 前置SQL语句
delete from  dws.dws_sr_ad_book_promotion_user_info_di  where dt>='${bf_1_dt}' and dt<='${dt}';

-- SQL语句
insert into  dws.dws_sr_ad_book_promotion_user_info_di
 -- 这个表只能以补数的方式跑数
-- ========================获取满足条件的用户===================================
select dt,product_id,bookid as book_id,user_id,chl as chl2,campaign,source_chl,mt,core,current_language as current_language2 ,-- unique_cdreader_id,create_time,
CONCAT('$', bookid, '@', campaign, '|SourceChl=', source_chl, '|Mt=', mt, '|Core=', core, '|Chl2=', chl, '|CurrentLanguage2=', current_language) AS adcamp_id,now() as etl_tm
from (
select tag.dt,tag.product_id,tag.create_time,tag.chl,tag.mt,tag.core,tag.unique_cdreader_id,tag.current_language,Ifnull(tag.bookid,-99) as bookid,tag.campaign,tag.source_chl,tag.user_id ,rd.user_id as read_user
from (
select a.dt,a.product_id,a.create_time,a.chl,a.mt,a.core,a.unique_cdreader_id,a.current_language,a.bookid,a.campaign,a.source_chl,b.id  as user_id
from (

select a.dt,a.product_id,a.create_time,a.chl,a.mt,a.core,a.unique_cdreader_id,a.current_language,a.bookid,a.campaign,a.source_chl from (
select dt,product_id,create_time,chl,mt,core,unique_cdreader_id,current_language,
SUBSTRING_INDEX(SUBSTRING_INDEX(decrypt_data, 'bookid=', -1), '&', 1) AS bookid,
SUBSTRING_INDEX(SUBSTRING_INDEX(decrypt_data, 'utm_campaign=', -1), '&', 1) AS campaign,
SUBSTRING_INDEX(SUBSTRING_INDEX(decrypt_data, 'utm_medium=', -1), '&', 1) AS source_chl
from  dwd.dwd_sr_ad_install_referrer_log_view
where
dt>='${bf_1_dt}' and dt<='${dt}'
and decrypt_data like 'ndaction:readonline%'    -- 推书活动---------------
and decrypt_data like '%utm_campaign=%'
and decrypt_data like '%utm_medium=%'
-- and product_id =3311  and chl='fr_core2_android_google' and mt=4 and core=2 and current_language=6    -- 验证数据
-- and SUBSTRING_INDEX(SUBSTRING_INDEX(decrypt_data, 'bookid=', -1), '&', 1)=15814410
-- and SUBSTRING_INDEX(SUBSTRING_INDEX(decrypt_data, 'utm_campaign=', -1), '&', 1)='indexfooter' --  验证数据

)  a where bookid >0  QUALIFY ROW_NUMBER() OVER(PARTITION BY dt,product_id,bookid,unique_cdreader_id ORDER BY create_time) = 1
) a
left join
dim.dim_user_account_info_view b
on a.product_id =b.product_id  and a.unique_cdreader_id=b.unique_cdreader_id and a.chl=b.chl  -- 获取用户id
)
tag
left join
-- --------近7天有阅读记录的用户---------------
(
select product_id , user_id ,book_id , create_time ,dt ,count(1) from dwd.dwd_read_user_chapter_view drucv
where dt>=DATE_SUB('${dt}',interval 8 day )  and  dt<='${dt}'
-- and user_id in (141073886)  -- 验证数据
-- and book_id=15814410
group by 1,2,3,4,5
order by 4
) rd
on
tag.product_id=rd.product_id and  tag.user_id=rd.user_id and  tag.bookid=rd.book_id
and rd.create_time<tag.create_time   -- 阅读时间要小于活动时间
and rd.dt>=date_sub(tag.dt,interval 7 day)  --   7天内

) v where read_user is null and user_id is not null   and  cast(bookid as int )>0
group by 1,2,3,4,5 ,6,7,8,9,10;
