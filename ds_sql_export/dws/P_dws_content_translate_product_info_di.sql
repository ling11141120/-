----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_content_translate_product_info_di
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : dws_content_translate_product_info_di
-- task_version     : 7
-- update_time      : 2024-10-16 11:57:29
-- sql_path         : \starrocks\tbl_dws_content_translate_product_info_di\dws_content_translate_product_info_di
----------------------------------------------------------------
-- SQL语句
insert overwrite dws.dws_content_translate_product_info_di
select  dt , bill_date ,to_language  , author_id , pen_name,
 real_name,
max(month_target) as month_target ,
max(book_product) as book_product , max(short_video_product) as short_video_product  ,1 as  project ,now() as etl_tm
from (
select a.dt ,a.bill_date ,a.to_language  ,a.author_id ,a.pen_name,
if(a.real_name is null or a.real_name='',a.pen_name,a.real_name) as real_name,
a.MonthTarget as month_target,
 a.book_product, b.short_video_product ,1 as  project
from
(
 select a.dt ,a.bill_date ,a.to_language  ,a.author_id ,
 if(a.pen_name is null or a.pen_name='','other',a.pen_name) as pen_name ,
 a.real_name ,d.MonthTarget,
 a.book_product
 from
(
select    dt  ,bill_date   ,to_language  ,author_id  ,pen_name  ,real_name   ,role_type,
sum(font_length) as book_product -- 二校的
from   dwd.dwd_content_translate_remuneration
where
 role_type  in (3)   -- 角色类型  1：译员 3：二校 （网文的取二校的）
 and book_type !=3    -- 编辑后台上对应项目字段 book_type=3 是短剧  其他是网文
 and dt >='2024-01-01'
and bill_date>=202401  -- 账期数据从24年1月开始
  --  and author_id=597210
 --  and book_id >0
group by 1,2,3,4,5,6,7

union all

select    dt  ,bill_date   ,to_language  ,author_id  ,pen_name  ,real_name   ,role_type,
0 as book_product -- 二校的
from   dwd.dwd_content_translate_remuneration
where
 role_type  in (1)   -- 角色类型  1：译员 3：二校 （网文的取二校的）
 and book_type  =3    -- 编辑后台上对应项目字段 book_type=3 是短剧  其他是网文
 and dt >='2024-01-01'
and bill_date>=202401  -- 账期数据从24年1月开始
 --   and author_id=597210
  -- and book_id >0
group by 1,2,3,4,5,6,7

order by 1  desc
) a
-- --- 关联译员配置表--------------------------
left join
(select siteid,authorid,monthtime,roletype ,max(monthtarget) as monthtarget
from ods.ods_tidb_shuangwen_en_viscauthorconfig
where monthtime >='2024-01-01'
 --  and authorid =77350
group by 1,2,3,4) d
on a.to_language = d.siteid  and a.author_id = d.authorid and substr(a.dt,1,7)  = substr(d.monthtime,1,7) -- and a.role_type = d.roletype
order by 1
) a
left join
(
-- --------------1.短剧的 角色=译员---------------------------------
select    dt  ,bill_date   ,to_language  ,author_id  ,role_type,
            sum( font_length)   as short_video_product  -- en   -- 短语就译员的
from   dwd.dwd_content_translate_remuneration
where
 role_type  in (1)   -- 角色类型  1：译员 3：二校 （网文的取二校的）
 and book_type  =3    -- 编辑后台上对应项目字段 book_type=3 是短剧  其他是网文
 and dt >='2024-01-01'
and bill_date>=202401  -- 账期数据从24年1月开始
-- and author_id=597210
 --  and book_id >0
group by 1,2,3,4,5
order by 1  ,2
) b
on  a.dt =b.dt and a.bill_date=b.bill_date and a.to_language=b.to_language  and a.author_id =b.author_id
 ) v group by 1,2,3,4,5,6;
