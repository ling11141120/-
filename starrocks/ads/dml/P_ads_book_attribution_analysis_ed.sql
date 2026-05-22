----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_optimize
-- workflow_version : 95
-- create_user      : xixg
-- task_name        : ads_book_attribution_analysis_ed
-- task_version     : 2
-- update_time      : 2025-10-31 09:57:01
-- sql_path         : \starrocks\sch_ads_optimize\ads_book_attribution_analysis_ed
----------------------------------------------------------------
-- SQL语句
delete from ads.ads_book_attribution_analysis_ed where  dt>='${bf_1_dt}';

-- SQL语句
insert into ads.ads_book_attribution_analysis_ed
with cte_charge as (

    select a.dt,
        a.book_id,
        a.product_id,
        a.ad_id,
          count(distinct a.user_id) install_num,
          count(distinct a.userid) as charge_num,
          sum(a.charge_itemcount) charge_itemcount,
          sum(charge_count) charge_count ,
      count(distinct case when charge_count>=2 then  a.userid end ) as recharge_num,
    count(distinct case when a.charge_itemcount>=10 then  a.userid end ) charge_num_10,
    count( case when a.charge_itemcount>=10 then  a.userid end ) charge_count_10

from (
select  date(a.Install_Date) dt ,
        a.book_id,
        a.product_id,
        a.ad_id,
        a.user_id,
        b.userid,
        sum(b.itemcount) charge_itemcount,
        count(b.userid) charge_count

from (
SELECT
          User_Id,
          core,
          mt,
		  product_id,
		  Book_Id ,
          DATE_add(Min(Install_Date),interval -13 hour)  as Install_Date,
          max(Remarketing_Time) as Remarketing_Time,
          max(Next_Attribute_Time  ) as Next_Attribute_Time,
          Min(Ad_Id) as Ad_Id
        FROM
          dwd.dwd_user_install_info_ed_view
        WHERE
 Install_Date >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour)  and Install_Date<DATE_ADD(now(), INTERVAL 13 Hour)
        and Book_Id >0
        and Ad_Id <>'' and Ad_Id  is not null
        and User_Id >0
        and is_remarketing =0
        and  source not in ('sem')
		and IsDelete =0
        GROUP BY 1,2,3,4,5
    ) a
    left join
    (
 select ProductId,userid,   DATE_add(CreateTime,interval -13 hour) CreateTime,ItemCount ,  mt,corever,AutoId
        from dwd.dwd_trade_user_payorder  where CreateTime >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour) and CreateTime< DATE_ADD(now(), INTERVAL 13 Hour) ) b
        on a.user_id=b.userid and a.core=b.corever  and a.product_id =b.productid
        and b.createtime>=a.Install_Date
        and b.createtime<date_add(a.Install_Date,interval 24 hour )
        and b.createtime<a.Remarketing_Time
          and b.createtime<a.Next_Attribute_Time
        group by 1,2,3,4 ,5,6
      ) a
        group by 1,2,3,4
)  ,

 cte_consume as  (

select  date(a.Install_Date) dt ,
        a.book_id,
        a.product_id,
        a.ad_id,
        count(distinct b.user_id) consume_num,
         count(distinct case when types=1 then b.user_id end) consume_pay_num,
        sum(b.amount) consume_amount,
        sum( case when types=1 then b.amount end ) consume_pay_amount

from (
SELECT
          User_Id,
          core,
          mt,
		  product_id,
		  Book_Id ,
          DATE_add(Min(Install_Date),interval -13 hour)  as Install_Date,
          max(Remarketing_Time) as Remarketing_Time,
          max(Next_Attribute_Time  ) as Next_Attribute_Time,
          Min(Ad_Id) as Ad_Id
        FROM
          dwd.dwd_user_install_info_ed_view
        WHERE
 Install_Date >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour)  and Install_Date<DATE_ADD(now(), INTERVAL 13 Hour)
        and Book_Id >0
        and Ad_Id <>'' and Ad_Id  is not null
        and User_Id >0
        and is_remarketing =0
         and  source not in ('sem')
		 and IsDelete =0
        GROUP BY 1,2,3,4,5
    ) a
    left join
    (
 select Product_Id,user_id,   DATE_add(CreateTime,interval -13 hour) CreateTime,amount ,  mt,SUBSTRING(app_id,6,1) as corever  ,types,book_id
        from dwd.dwd_consume_user_consume where CreateTime >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour)  and  CreateTime< DATE_ADD(now(), INTERVAL 13 Hour)
        and  types in (1,2)
        ) b
        on a.user_id=b.user_id and a.core=b.corever  and a.product_id =b.Product_Id   and a.book_id=b.book_id

        and b.createtime>=a.Install_Date
        and b.createtime<date_add(a.Install_Date,interval 24 hour )
        and b.createtime<a.Remarketing_Time
          and b.createtime<a.Next_Attribute_Time
        group by 1,2,3,4

 ) ,

 cte_read as (

     select a.dt,
        a.book_id,
        a.product_id,
        a.ad_id,
   count(distinct a.userid) as read_num,
    count(distinct a.pay_read_userid) as read_pay_num,
      count(distinct case when read_chapter_num>=2 then  a.userid end ) as read_num_2,
    count(distinct case when read_chapter_num>=5 then  a.userid end ) as read_num_5,
       count(distinct case when read_chapter_num>=8 then  a.userid end ) as read_num_8

from
(

          select a.dt,
        a.book_id,
        a.product_id,
        a.ad_id,
        a.userid,
        a.pay_read_userid,
        count(distinct chapterid ) read_chapter_num

from (
  select  date(a.Install_Date) dt ,
        a.book_id,
        a.product_id,
        a.ad_id,
        a.user_id,
        b.userid,
        case when b.pay_chapter_id is not null then b.userid end as pay_read_userid ,
         b.chapterid

from (
SELECT
          User_Id,
          core,
          mt,
		  product_id,
		  Book_Id ,
          DATE_add(Min(Install_Date),interval -13 hour)  as Install_Date,
          max(Remarketing_Time) as Remarketing_Time,
          max(Next_Attribute_Time  ) as Next_Attribute_Time,
          Min(Ad_Id) as Ad_Id
        FROM
          dwd.dwd_user_install_info_ed_view
        WHERE
 Install_Date >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour) and Install_Date<DATE_ADD(now(), INTERVAL 13 Hour)
        and Book_Id >0
        and Ad_Id <>'' and Ad_Id  is not null
        and User_Id >0
        and is_remarketing =0
         and  source not in ('sem')
		 and IsDelete =0

        GROUP BY 1,2,3,4,5
    ) a
    left join
    (
       select product_id as ProductId,user_id as userid, DATE_add(Create_Time,interval -13 hour) as CreateTime,a.book_id as bookid,a.chapter_id as chapterid , SUBSTRING(appid,6,1) as corever ,b.chapter_id as pay_chapter_id
        from   dwd.dwd_read_user_chapter_view a
        left join
        dwd.dwd_read_pay_chapter_temp b
        on a.book_id =b.book_id and a.chapter_id=b.chapter_id
         where a.Create_Time >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour)   and a.Create_Time< DATE_ADD(now(), INTERVAL 13 Hour)
) b
        on a.user_id=b.userid and a.core=b.corever  and a.product_id =b.productid  and a.book_id =b.bookid
        and b.createtime>=a.Install_Date
        and b.createtime<date_add(a.Install_Date,interval 24 hour )
        and b.createtime<a.Remarketing_Time
          and b.createtime<a.Next_Attribute_Time

      ) a
        group by 1,2,3,4 ,5,6

 ) a group by 1,2,3,4

 )

    select cte_charge.dt,
        cte_charge.book_id,
        cte_charge.product_id,
        cte_charge.ad_id,
          cte_charge.install_num,
          cte_charge.charge_itemcount,
          cte_charge.charge_num,
          cte_charge.charge_count ,
       cte_charge.recharge_num,
     cte_charge.charge_num_10,
     cte_charge.charge_count_10 ,
      cte_read.read_num,
      cte_read.read_num_2,
         cte_read.read_pay_num,
              cte_consume.consume_num,
         cte_consume.consume_pay_num,
          cte_read.read_num_5,
       cte_read.read_num_8 ,
        cte_consume.consume_amount,
        cte_consume.consume_pay_amount,
  CURRENT_TIMESTAMP()  as etl_time
 from cte_charge
 inner join
 cte_consume
 on cte_charge.dt=cte_consume.dt and cte_charge.book_id =cte_consume.book_id and cte_charge.product_id =cte_consume.product_id and cte_charge.ad_id=cte_consume.ad_id
inner join
cte_read
on cte_charge.dt=cte_read.dt and cte_charge.book_id =cte_read.book_id and cte_charge.product_id =cte_read.product_id and cte_charge.ad_id=cte_read.ad_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_book_remarket_attribution_analysis_ed
-- workflow_version : 30
-- create_user      : yanxh
-- task_name        : ads_book_attribution_analysis_ed
-- task_version     : 9
-- update_time      : 2023-11-14 19:10:28
-- sql_path         : \starrocks\tbl_ads_book_remarket_attribution_analysis_ed\ads_book_attribution_analysis_ed
----------------------------------------------------------------
-- SQL语句
delete from ads.ads_book_attribution_analysis_ed where  dt>='${bf_1_dt}';

-- SQL语句
insert into ads.ads_book_attribution_analysis_ed
with cte_charge as (

    select a.dt,
        a.book_id,
        a.product_id,
        a.ad_id,
          count(distinct a.user_id) install_num,
          count(distinct a.userid) as charge_num,
          sum(a.charge_itemcount) charge_itemcount,
          sum(charge_count) charge_count ,
      count(distinct case when charge_count>=2 then  a.userid end ) as recharge_num,
    count(distinct case when a.charge_itemcount>=10 then  a.userid end ) charge_num_10,
    count( case when a.charge_itemcount>=10 then  a.userid end ) charge_count_10

from (
select  date(a.Install_Date) dt ,
        a.book_id,
        a.product_id,
        a.ad_id,
        a.user_id,
        b.userid,
        sum(b.itemcount) charge_itemcount,
        count(b.userid) charge_count

from (
SELECT
          User_Id,
          core,
          mt,
		  product_id,
		  Book_Id ,
          DATE_add(Min(Install_Date),interval -13 hour)  as Install_Date,
          max(Remarketing_Time) as Remarketing_Time,
          max(Next_Attribute_Time  ) as Next_Attribute_Time,
          Min(Ad_Id) as Ad_Id
        FROM
          dwd.dwd_user_install_info_ed_view
        WHERE
 Install_Date >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour)  and Install_Date<DATE_ADD(now(), INTERVAL 13 Hour)
        and Book_Id >0
        and Ad_Id <>'' and Ad_Id  is not null
        and User_Id >0
        and is_remarketing =0
        and  source not in ('sem')
		and IsDelete =0
        GROUP BY 1,2,3,4,5
    ) a
    left join
    (
 select ProductId,userid,   DATE_add(CreateTime,interval -13 hour) CreateTime,ItemCount ,  mt,corever,AutoId
        from dwd.dwd_trade_user_payorder  where CreateTime >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour) and CreateTime< DATE_ADD(now(), INTERVAL 13 Hour) ) b
        on a.user_id=b.userid and a.core=b.corever  and a.product_id =b.productid
        and b.createtime>=a.Install_Date
        and b.createtime<date_add(a.Install_Date,interval 24 hour )
        and b.createtime<a.Remarketing_Time
          and b.createtime<a.Next_Attribute_Time
        group by 1,2,3,4 ,5,6
      ) a
        group by 1,2,3,4
)  ,

 cte_consume as  (

select  date(a.Install_Date) dt ,
        a.book_id,
        a.product_id,
        a.ad_id,
        count(distinct b.user_id) consume_num,
         count(distinct case when types=1 then b.user_id end) consume_pay_num,
        sum(b.amount) consume_amount,
        sum( case when types=1 then b.amount end ) consume_pay_amount

from (
SELECT
          User_Id,
          core,
          mt,
		  product_id,
		  Book_Id ,
          DATE_add(Min(Install_Date),interval -13 hour)  as Install_Date,
          max(Remarketing_Time) as Remarketing_Time,
          max(Next_Attribute_Time  ) as Next_Attribute_Time,
          Min(Ad_Id) as Ad_Id
        FROM
          dwd.dwd_user_install_info_ed_view
        WHERE
 Install_Date >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour)  and Install_Date<DATE_ADD(now(), INTERVAL 13 Hour)
        and Book_Id >0
        and Ad_Id <>'' and Ad_Id  is not null
        and User_Id >0
        and is_remarketing =0
         and  source not in ('sem')
		 and IsDelete =0
        GROUP BY 1,2,3,4,5
    ) a
    left join
    (
 select Product_Id,user_id,   DATE_add(CreateTime,interval -13 hour) CreateTime,amount ,  mt,SUBSTRING(app_id,6,1) as corever  ,types,book_id
        from dwd.dwd_consume_user_consume where CreateTime >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour)  and  CreateTime< DATE_ADD(now(), INTERVAL 13 Hour)
        and  types in (1,2)
        ) b
        on a.user_id=b.user_id and a.core=b.corever  and a.product_id =b.Product_Id   and a.book_id=b.book_id

        and b.createtime>=a.Install_Date
        and b.createtime<date_add(a.Install_Date,interval 24 hour )
        and b.createtime<a.Remarketing_Time
          and b.createtime<a.Next_Attribute_Time
        group by 1,2,3,4

 ) ,

 cte_read as (

     select a.dt,
        a.book_id,
        a.product_id,
        a.ad_id,
   count(distinct a.userid) as read_num,
    count(distinct a.pay_read_userid) as read_pay_num,
      count(distinct case when read_chapter_num>=2 then  a.userid end ) as read_num_2,
    count(distinct case when read_chapter_num>=5 then  a.userid end ) as read_num_5,
       count(distinct case when read_chapter_num>=8 then  a.userid end ) as read_num_8

from
(

          select a.dt,
        a.book_id,
        a.product_id,
        a.ad_id,
        a.userid,
        a.pay_read_userid,
        count(distinct chapterid ) read_chapter_num

from (
  select  date(a.Install_Date) dt ,
        a.book_id,
        a.product_id,
        a.ad_id,
        a.user_id,
        b.userid,
        case when b.pay_chapter_id is not null then b.userid end as pay_read_userid ,
         b.chapterid

from (
SELECT
          User_Id,
          core,
          mt,
		  product_id,
		  Book_Id ,
          DATE_add(Min(Install_Date),interval -13 hour)  as Install_Date,
          max(Remarketing_Time) as Remarketing_Time,
          max(Next_Attribute_Time  ) as Next_Attribute_Time,
          Min(Ad_Id) as Ad_Id
        FROM
          dwd.dwd_user_install_info_ed_view
        WHERE
 Install_Date >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour) and Install_Date<DATE_ADD(now(), INTERVAL 13 Hour)
        and Book_Id >0
        and Ad_Id <>'' and Ad_Id  is not null
        and User_Id >0
        and is_remarketing =0
         and  source not in ('sem')
		 and IsDelete =0

        GROUP BY 1,2,3,4,5
    ) a
    left join
    (
       select product_id as ProductId,user_id as userid, DATE_add(Create_Time,interval -13 hour) as CreateTime,a.book_id as bookid,a.chapter_id as chapterid , SUBSTRING(appid,6,1) as corever ,b.chapter_id as pay_chapter_id
        from   dwd.dwd_read_user_chapter_view a
        left join
        dwd.dwd_read_pay_chapter_temp b
        on a.book_id =b.book_id and a.chapter_id=b.chapter_id
         where a.Create_Time >= DATE_ADD(date_sub(curdate(),interval 1 day), INTERVAL 13 Hour)   and a.Create_Time< DATE_ADD(now(), INTERVAL 13 Hour)
) b
        on a.user_id=b.userid and a.core=b.corever  and a.product_id =b.productid  and a.book_id =b.bookid
        and b.createtime>=a.Install_Date
        and b.createtime<date_add(a.Install_Date,interval 24 hour )
        and b.createtime<a.Remarketing_Time
          and b.createtime<a.Next_Attribute_Time

      ) a
        group by 1,2,3,4 ,5,6

 ) a group by 1,2,3,4

 )

    select cte_charge.dt,
        cte_charge.book_id,
        cte_charge.product_id,
        cte_charge.ad_id,
          cte_charge.install_num,
          cte_charge.charge_itemcount,
          cte_charge.charge_num,
          cte_charge.charge_count ,
       cte_charge.recharge_num,
     cte_charge.charge_num_10,
     cte_charge.charge_count_10 ,
      cte_read.read_num,
      cte_read.read_num_2,
         cte_read.read_pay_num,
              cte_consume.consume_num,
         cte_consume.consume_pay_num,
          cte_read.read_num_5,
       cte_read.read_num_8 ,
        cte_consume.consume_amount,
        cte_consume.consume_pay_amount,
  CURRENT_TIMESTAMP()  as etl_time
 from cte_charge
 inner join
 cte_consume
 on cte_charge.dt=cte_consume.dt and cte_charge.book_id =cte_consume.book_id and cte_charge.product_id =cte_consume.product_id and cte_charge.ad_id=cte_consume.ad_id
inner join
cte_read
on cte_charge.dt=cte_read.dt and cte_charge.book_id =cte_read.book_id and cte_charge.product_id =cte_read.product_id and cte_charge.ad_id=cte_read.ad_id;
