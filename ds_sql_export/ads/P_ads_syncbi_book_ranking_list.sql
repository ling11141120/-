----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_syncbi_book_ranking_list
-- workflow_version : 8
-- create_user      : yanxh
-- task_name        : ads_syncbi_book_ranking_list
-- task_version     : 7
-- update_time      : 2025-07-05 19:12:42
-- sql_path         : \starrocks\tbl_ads_syncbi_book_ranking_list\ads_syncbi_book_ranking_list
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_syncbi_book_ranking_list where dt = '${bf_1_dt}';

-- SQL语句
-- -=======----20--=======================
-- -week

insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,consume_num as mea_val
       ,rn
       ,0 as newc_id
       ,3 as time_type
       ,200 as type
	   ,languageid as language_id
          ,now() as etl_time
  from
(select a.product_id,a.book_id,b.book_name,a.consume_num,b.languageid,row_number() over(partition by a.product_id,b.languageid order by a.consume_num desc) as rn
from
(select product_id, dcucme.book_id,count(1) as consume_num
from dwm.dwm_consume_user_consume_mild_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where  dt > date_sub('${bf_1_dt}',interval 7 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id=40781322
and corever = 1
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2 =0 and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 20
order by product_id , rn asc;

-- SQL语句
-- -month
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,consume_num as mea_val
       ,rn
       ,0 as newc_id
       ,2 as time_type
       ,200 as type
	   ,languageid as language_id
          ,now() as etl_time
  from
(select a.product_id,a.book_id,b.book_name,a.consume_num,b.languageid,row_number() over(partition by a.product_id,b.languageid order by a.consume_num desc) as rn
from
(select product_id, dcucme.book_id,count(1) as consume_num
from dwm.dwm_consume_user_consume_mild_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where  dt > date_sub('${bf_1_dt}',interval 30 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id=40781322
and corever = 1
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2  =0 and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 20
order by product_id , rn asc;

-- SQL语句
-- -quarter
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,consume_num as mea_val
       ,rn
       ,0 as newc_id
       ,1 as time_type
       ,200 as type
	   ,languageid as language_id
          ,now() as etl_time
  from
(select a.product_id,a.book_id,b.book_name,a.consume_num,b.languageid,row_number() over(partition by a.product_id,b.languageid order by a.consume_num desc) as rn
from
(select product_id, dcucme.book_id,count(1) as consume_num
from dwm.dwm_consume_user_consume_mild_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where  dt > date_sub('${bf_1_dt}',interval 90 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id=40781322
and corever = 1
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2  =0  and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 20
order by product_id , rn asc;

-- SQL语句
-- --------------------------------------------------------
-- -============-----20--
-- -week
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,usercnt as mea_val
       ,rn
       ,0 as newc_id
       ,3 as time_type
       ,201 as type
	   ,languageid as language_id
          ,now() as etl_time
from
(select a.product_id,a.book_id,b.book_name, usercnt,languageid,row_number() over(partition by a.product_id,b.languageid order by   usercnt desc) as rn
from
(select product_id,dcucme.book_id,count(distinct user_id) as usercnt
from dws.dws_read_user_readbook_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where dt > date_sub('${bf_1_dt}',interval 7 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id =40781322
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2 =0  and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 20
order by product_id , rn asc;

-- SQL语句
-- --------------------------------------------------------
-- -============-----20--
-- -month
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,usercnt as mea_val
       ,rn
       ,0 as newc_id
       ,2 as time_type
       ,201 as type
	   ,languageid as language_id
          ,now() as etl_time
from
(select a.product_id,a.book_id,b.book_name, usercnt,languageid,row_number() over(partition by a.product_id,b.languageid order by   usercnt desc) as rn
from
(select product_id,dcucme.book_id,count(distinct user_id) as usercnt
from dws.dws_read_user_readbook_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where dt > date_sub('${bf_1_dt}',interval 30 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id =40781322
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2 =0  and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 20
order by product_id , rn asc;

-- SQL语句
-- --------------------------------------------------------
-- -============-----20--
-- -quarter
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,usercnt as mea_val
       ,rn
       ,0 as newc_id
       ,1 as time_type
       ,201 as type
	   ,languageid as language_id
          ,now() as etl_time
from
(select a.product_id,a.book_id,b.book_name, usercnt,languageid,row_number() over(partition by a.product_id,b.languageid order by   usercnt desc) as rn
from
(select product_id,dcucme.book_id,count(distinct user_id) as usercnt
from dws.dws_read_user_readbook_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where dt > date_sub('${bf_1_dt}',interval 90 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id =40781322
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2  =0  and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 20
order by product_id , rn asc;

-- SQL语句
-- --------------------------------------------------------
-- -============-----------  -------10-
-- -week
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,usercnt as mea_val
       ,rn
       ,new_cid as newc_id
       ,3 as time_type
       ,203 as type
	   ,languageid as language_id
          ,now() as etl_time
from
(select a.product_id,a.book_id,b.book_name, a.usercnt,b.languageid,b.new_cid ,row_number() over(partition by a.product_id,b.languageid,b.new_cid order by   a.usercnt desc) as rn
from
(select product_id,dcucme.book_id,count(distinct user_id) as usercnt
from dws.dws_read_user_readbook_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where dt > date_sub('${bf_1_dt}',interval 7 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id =40781322
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2  =0  and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 10
order by product_id,new_cid , rn asc;

-- SQL语句
-- -============-----------  -------10-
-- -month
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,usercnt as mea_val
       ,rn
       ,new_cid as newc_id
       ,2 as time_type
       ,203 as type
	   ,languageid as language_id
          ,now() as etl_time
from
(select a.product_id,a.book_id,b.book_name, a.usercnt,b.languageid,b.new_cid ,row_number() over(partition by a.product_id,b.languageid,b.new_cid order by   a.usercnt desc) as rn
from
(select product_id,dcucme.book_id,count(distinct user_id) as usercnt
from dws.dws_read_user_readbook_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where dt > date_sub('${bf_1_dt}',interval 30 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id =40781322
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2 =0  and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 10
order by product_id,new_cid , rn asc;

-- SQL语句
-- -============-----------  -------10-
-- -quarter
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,usercnt as mea_val
       ,rn
       ,new_cid as newc_id
       ,1 as time_type
       ,203 as type
	   ,languageid as language_id
          ,now() as etl_time
from
(select a.product_id,a.book_id,b.book_name, a.usercnt,b.languageid,b.new_cid ,row_number() over(partition by a.product_id,b.languageid,b.new_cid order by   a.usercnt desc) as rn
from
(select product_id,dcucme.book_id,count(distinct user_id) as usercnt
from dws.dws_read_user_readbook_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where dt > date_sub('${bf_1_dt}',interval 90 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id =40781322
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2  =0  and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 10
order by product_id,new_cid , rn asc;

-- SQL语句
-- ---- -------

insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,usercnt as mea_val
       ,rn
       ,0 as newc_id
       ,0 as time_type
       ,202 as type
	   ,languageid as language_id
          ,now() as etl_time
from
(select a.product_id,a.book_id,b.book_name, a.usercnt,b.languageid,row_number() over(partition by a.product_id,b.languageid order by   a.usercnt desc) as rn
from
(select product_id,dcucme.book_id,count( user_id) as usercnt
from dws.dws_read_user_readbook_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where dt > date_sub('${bf_1_dt}',interval 7 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id =40781322
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2  =0  and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 10
order by product_id , rn asc;

-- SQL语句
-- 7- ----200--	--	-/---
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,usercnt as mea_val
       ,rn
       ,0 as newc_id
       ,3 as time_type
       ,204 as type
	   ,languageid as language_id
       ,now() as etl_time
from
(select a.product_id,a.book_id,b.book_name, a.usercnt,b.languageid,row_number() over(partition by a.product_id,b.languageid order by   a.usercnt desc) as rn
from
(select product_id,dcucme.book_id,count(distinct user_id) as usercnt
from dws.dws_read_user_readbook_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where dt > date_sub('${bf_1_dt}',interval 7 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id =40781322
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2  =0  and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 200
order by product_id , rn asc;

-- SQL语句
-- 30- ----200--	--	-/---
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,usercnt as mea_val
       ,rn
       ,0 as newc_id
       ,2 as time_type
       ,204 as type
	   ,languageid as language_id
       ,now() as etl_time
from
(select a.product_id,a.book_id,b.book_name, a.usercnt,b.languageid,row_number() over(partition by a.product_id,b.languageid order by   a.usercnt desc) as rn
from
(select product_id,dcucme.book_id,count(distinct user_id) as usercnt
from dws.dws_read_user_readbook_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where dt > date_sub('${bf_1_dt}',interval 30 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id =40781322
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2  =0  and new_cid<>-99  ) b
on a.book_id = b.book_id
) x
where rn <= 200
order by product_id , rn asc;

-- SQL语句
-- 90- ----200--	--	-/---
insert into  ads.ads_syncbi_book_ranking_list
select  '${bf_1_dt}'  AS dt
         , product_id
       ,book_id
       ,book_name
       ,usercnt as mea_val
       ,rn
       ,0 as newc_id
       ,1 as time_type
       ,204 as type
	   ,languageid as language_id
       ,now() as etl_time
from
(select a.product_id,a.book_id,b.book_name, a.usercnt,b.languageid,row_number() over(partition by a.product_id,b.languageid order by   a.usercnt desc) as rn
from
(select product_id,dcucme.book_id,count(distinct user_id) as usercnt
from dws.dws_read_user_readbook_ed dcucme
left join (
    select distinct book_id from dim.dim_tag_book_info_view where tag_id in(
        select id from dim.dim_tag_config_view where is_delete = 0 and (tag like '%18%' or tag like '%19%')
    ) and is_delete = 0
) b on dcucme.book_id = b.book_id
where dt > date_sub('${bf_1_dt}',interval 90 day)  and  dt<='${bf_1_dt}' and b.book_id is null
and product_id not in (7757,8858,7777,8888)
-- and book_id =40781322
group by 1,2
) a
inner join
(select book_id,book_name,languageid,new_cid,sexy2 from dim.dim_shuangwen_book_read_consume_info dsbrci  where product_id  not in (8858)  and sexy2  =0  and new_cid<>-99 ) b
on a.book_id = b.book_id
) x
where rn <= 200
order by product_id , rn asc;
