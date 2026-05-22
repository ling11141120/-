----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_ft_book_info
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : dim_ft_book_info_090
-- task_version     : 9
-- update_time      : 2024-06-13 20:12:05
-- sql_path         : \starrocks\tbl_dim_ft_book_info\dim_ft_book_info_090
----------------------------------------------------------------
-- SQL语句
insert into  dim.dim_ft_book_info

-- ============================== 090 凤鸣轩的书 ==============================

with pub_090 as (

select '${bf_1_dt}' as dt,book_id,book_name,book_code,
       sum(app_chapter) as app_chapter,   -- 实际是累计的发布
       sum(app_font_length)  as app_font_length      -- 实际是累计的发布
       from (
SELECT
        date(`b`.`PublishTime`) AS `publish_tm`,
        (`ods`.`a`.`bookid` * 1000) + 90 AS `book_id`,
        `a`.`bookname` AS `book_name`,
        `c`.`bookno` AS `book_code`,
        count(if(((`b`.`status` = 2) AND (`b`.`delstatus` = 0)) AND (`b`.`publishtime` < (current_date())), 1, NULL)) AS `app_chapter`,
        sum(if(((`b`.`status` = 2) AND (`b`.`delstatus` = 0)) AND (`b`.`publishtime` < (current_date())), `b`.`fontlength`, 0)) AS `app_font_length`
FROM  `ods`.`ods_mysql_Fmx_Book` AS `a`
 inner JOIN
    (  select PublishTime,status,delstatus,fontlength,BookId ,createtime ,updatetime  from ods.ods_mysql_zhangzhong_xzz_Chapter_090
 union all
  select PublishTime,status,delstatus,fontlength,BookId ,createtime ,updatetime from `ods`.`ods_mysql_Fmx_Chapter`     where bookid not in (select distinct BookId from  ods.ods_mysql_zhangzhong_xzz_Chapter_090 )
  ) b
ON  `ods`.`a`.`bookid` = `b`.`bookid`
LEFT   JOIN (  -- -------获取书的代号------------------------
        SELECT   `bookid`,  `bookno` FROM  `ods`.`ods_tidb_readernovel_tidb_tag_center_book_information`
                    WHERE `langid` = 2 AND `bookno` != '' AND right(`bookid`,3)= '090' ) c
                    ON ((`ods`.`a`.`bookid` * 1000) + 90) = `c`.`bookid`
 --  where a.bookid=130702
GROUP BY 1, 2,3, 4
) a
where  publish_tm <='${bf_1_dt}'
group by 1,2,3,4
order by 1
)
,

git as (
select '${bf_1_dt}'  as sub_dt,
       book_id,
	   book_name,book_code,
       sum(sub_chapter)-sum(lst_sub_chapter) as sub_chapter,
       sum(sub_chapter)  sub_total_chapter ,
       sum(sub_font_length) as sub_font_length
       from (
SELECT
        date(ifnull(b.createtime,b.updatetime)) AS `sub_dt`,
        (`ods`.`a`.`bookid` * 1000) + 90 AS `book_id`,
		 `a`.`bookname` AS `book_name`,
        `c`.`bookno` AS `book_code`,
         count(if(`b`.`delstatus` = 0, 1, NULL)) AS `sub_chapter`,
         sum(if(`b`.`delstatus` = 0 and b.status!=0, `b`.`fontlength`, 0)) AS `sub_font_length`,
         LAG(count(if(`b`.`delstatus` = 0  , 1, NULL)),1,0) OVER (partition by (`ods`.`a`.`bookid` * 1000) + 90  ORDER BY   date(ifnull(b.createtime,b.updatetime)))  lst_sub_chapter
FROM  `ods`.`ods_mysql_Fmx_Book` AS `a`
 inner JOIN
       (  select PublishTime,status,delstatus,fontlength,BookId ,createtime ,updatetime  from ods.ods_mysql_zhangzhong_xzz_Chapter_090
 union all
  select PublishTime,status,delstatus,fontlength,BookId ,createtime ,updatetime from `ods`.`ods_mysql_Fmx_Chapter`     where bookid not in (select distinct BookId from  ods.ods_mysql_zhangzhong_xzz_Chapter_090 )
  ) b
ON  `ods`.`a`.`bookid` = `b`.`bookid`
LEFT   JOIN (  -- -------获取书的代号------------------------
        SELECT   `bookid`,  `bookno` FROM  `ods`.`ods_tidb_readernovel_tidb_tag_center_book_information`
                    WHERE `langid` = 2 AND `bookno` != '' AND right(`bookid`,3)= '090' ) c
                    ON ((`ods`.`a`.`bookid` * 1000) + 90) = `c`.`bookid`
   -- where a.bookid=130704
GROUP BY 1, 2 ,3,4
) a
 where  sub_dt <='${bf_1_dt}'
 group by 1,2 ,3,4
order by 1
)

select IFNULL(pub_090.dt,git.sub_dt) as dt, ifnull(pub_090.book_id,git.book_id) as book_id,ifnull(pub_090.book_name,git.book_name) as book_name, ifnull(pub_090.book_code,git.book_code)  as book_code,
       pub_090.app_chapter,   -- 实际是累计的发布
       pub_090.app_font_length ,     -- 实际是累计的发布
       git.sub_dt,
       git.sub_chapter,
       git.sub_total_chapter,
       git.sub_font_length ,now() as etl_tm
from pub_090
right join
git
on pub_090.dt=git.sub_dt and pub_090.book_id=git.book_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_ft_book_info
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : dim_ft_book_info_446
-- task_version     : 9
-- update_time      : 2024-04-29 13:50:22
-- sql_path         : \starrocks\tbl_dim_ft_book_info\dim_ft_book_info_446
----------------------------------------------------------------
-- 前置SQL语句
delete from dim.dim_ft_book_info  where dt='${bf_1_dt}';

-- SQL语句
insert into   dim.dim_ft_book_info
with pub_446 as
(    -- ============ 446的书 ==============

-- ---已经确定的逻辑 以dt算当前发布的章节数和字数---------------
select  '${bf_1_dt}'  as dt,book_id,book_name,book_code,
        sum(app_chapter) as app_chapter ,
        sum(app_font_length) as app_font_length
       from (
SELECT
       date(PublishTime) as publish_tm,
        (`a`.`bookid` * 1000) + 446 AS `book_id`,
        `a`.`bookname` AS `book_name`,
        `a`.`bookcode` AS `book_code`,
        count(if(((`b`.`status` = 2) AND (`b`.`delstatus` = 0))AND (`b`.`publishtime` < (current_date())) , 1, NULL)) AS `app_chapter`, -- app_chapter
        sum(if(((`b`.`status` = 2) AND (`b`.`delstatus` = 0)) AND (`b`.`publishtime` < (current_date())), `b`.`fontlength`, 0)) AS `app_font_length` -- app_font_length
FROM  `ods`.`ods_edit_book` AS `a`
inner JOIN
  `ods`.`ods_tidb_shuangwen_xx_chapter`  b
 ON   (`a`.`bookid` = `b`.`bookid`) AND   (`a`.`productid` = `b`.`ProductId`) -- and  b.`PublishTime` < now()
WHERE (`a`.`productid` = 3311) aND (`a`.`siteid` = 446)
 --  and a.bookid in (16442,14753)
GROUP BY 1, 2,3,4
order by 1
) a
where  publish_tm <='${bf_1_dt}'
 group by 1,2,3,4
 order by 1
) ,

-- ------================= 446的书 以内容提交的角度来算的===================
  git as
(
 select '${bf_1_dt}'  as sub_dt,
       v.book_id,
	   s.bookname as book_name,s.bookcode as book_code ,
    sum(v.sub_chapter)-sum(v.lst_sub_chapter) as sub_chapter,
 sum(v.sub_chapter)  sub_total_chapter ,
 sum(v.sub_font_length) as sub_font_length
from (
select date(createtime) as sub_dt,book_id,count(distinct chapterid) as sub_chapter,sum(FontLength) sub_font_length
     ,LAG(count(distinct chapterid),1,0) OVER (partition by book_id  ORDER BY date(createtime))  lst_sub_chapter
from (
 SELECT
                           --   `a`.`id`,
                            `a`.`SiteBookId`*1000+446 as book_id ,
							 b.chapterid,
                             b.FontLength,
                             max(b.createtime) as  createtime
                FROM `ods`.`ods_tidb_shuangwen_en_custombook` AS `a`
                inner JOIN ods.`ods_tidb_shuangwen_en_CustomChapterLog_da`  AS `b`
                      ON  `a`.`id` = b.`BookId`
where b.LogType =5 -- 终稿后 发布到编辑平台
and a.issync=1 -- 是否同步繁体
  --  and a.SiteBookId in (16442)
group by 1,2,3
 ) a
 group by 1 ,2
 order by 1 ,2
 ) v
 left join
 (select (bookid*1000) + 446 AS book_id,bookname,bookcode  from ods.ods_edit_book where productid = 3311 and siteid = 446 group by 1,2,3) s
 on v.book_id=s.book_id
 where  v.sub_dt <='${bf_1_dt}'
 group by 1,2 ,3,4
 )

select IFNULL(pub_446.dt,git.sub_dt) as dt ,ifnull(pub_446.book_id,git.book_id) as book_id,ifnull(pub_446.book_name,git.book_name) as book_name, ifnull(pub_446.book_code,git.book_code)  as book_code,
       pub_446.app_chapter,   -- 实际是累计的发布
       pub_446.app_font_length ,     -- 实际是累计的发布
       git.sub_dt,
       git.sub_chapter,
       git.sub_total_chapter,
       git.sub_font_length
	   ,now() as etl_tm
from pub_446
right  join
git
on pub_446.dt=git.sub_dt and pub_446.book_id=git.book_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_ft_book_info
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : dim_ft_book_info_449
-- task_version     : 9
-- update_time      : 2024-06-13 20:12:05
-- sql_path         : \starrocks\tbl_dim_ft_book_info\dim_ft_book_info_449
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_ft_book_info
-- ============================== 新掌中 449  ==============================
with pub_449 as (
-- -------------------------------假设从23年1月到现在的，从此时开始补数跑批---------------------------
-- 090 449的书用创建时间做内容提交时间

select '${bf_1_dt}' as dt,book_id,book_name,book_code,
       sum(app_chapter) as app_chapter,   -- 实际是累计的发布
       sum(app_font_length)  as app_font_length      -- 实际是累计的发布
       from (
SELECT
         date(`b`.`PublishTime`) AS `publish_tm`,
        (`a`.`bookid` * 1000) + 449 AS `book_id`,
        `a`.`bookname` AS `book_name`,
        `a`.`bookcode` AS `book_code`,
        count(if(((`b`.`status` in (1,2) ) AND (`b`.`delstatus` = 0)) AND (`b`.`publishtime` < (current_date())), 1, NULL)) AS `app_chapter`,
        sum(if(((`b`.`status` in (1, 2)) AND (`b`.`delstatus` = 0)) AND (`b`.`publishtime` < (current_date())), `b`.`fontlength`, 0)) AS `app_font_length`
FROM `ods`.`ods_mysql_zhangzhong_xzz_Book` AS `a`
inner JOIN
 `ods`.`ods_mysql_zhangzhong_xzz_Chapter` b
  ON  `ods`.`a`.`bookid` = `b`.`bookid`
 -- where a.bookid=10020
 where a.siteid=449
GROUP BY 1, 2, 3, 4
order by 1
) a
where  publish_tm <='${bf_1_dt}'
group by 1,2,3,4
order by 1
)
 , git as (

-- -------------------sub_dt-------------------------
select '${bf_1_dt}'  as sub_dt,
       book_id, book_name,book_code,
       sum(sub_chapter)-sum(lst_sub_chapter) as sub_chapter,
       sum(sub_chapter)  sub_total_chapter ,
       sum(sub_font_length) as sub_font_length
       from (
SELECT
        date(ifnull(b.createtime,b.updatetime)) AS `sub_dt`,
        (`a`.`bookid` * 1000) + 449 AS `book_id`,
		 `a`.`bookname` AS `book_name`,
        `a`.`bookcode` AS `book_code`,
        count(if(`b`.`delstatus` = 0  , 1, NULL)) AS `sub_chapter`,
        sum(if(`b`.`delstatus` = 0 and b.status!=0, `b`.`fontlength`, 0)) AS `sub_font_length` ,
       LAG(count(if(`b`.`delstatus` = 0  , 1, NULL)),1,0) OVER (partition by (`a`.`bookid` * 1000) + 449   ORDER BY date(ifnull(b.createtime,b.updatetime)))  lst_sub_chapter

FROM `ods`.`ods_mysql_zhangzhong_xzz_Book` AS `a`
inner JOIN
 `ods`.`ods_mysql_zhangzhong_xzz_Chapter` b
  ON  `ods`.`a`.`bookid` = `b`.`bookid`
 -- where a.bookid=10020
  where a.siteid=449
GROUP BY 1, 2,3,4
order by 1
) a
 where  sub_dt <='${bf_1_dt}'
 group by 1,2 ,3,4
order by 1
)

select IFNULL(pub_449.dt,git.sub_dt) , ifnull(pub_449.book_id,git.book_id) as book_id,ifnull(pub_449.book_name,git.book_name) as book_name, ifnull(pub_449.book_code,git.book_code)  as book_code,
       pub_449.app_chapter,   -- 实际是累计的发布
       pub_449.app_font_length ,     -- 实际是累计的发布
       git.sub_dt,
       git.sub_chapter,
       git.sub_total_chapter,
       git.sub_font_length ,now() as etl_tm
from pub_449
right join
git
on pub_449.dt=git.sub_dt and pub_449.book_id=git.book_id;
