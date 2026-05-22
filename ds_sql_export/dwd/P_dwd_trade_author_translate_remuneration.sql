----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_trade_author_translate_remuneration
-- workflow_version : 4
-- create_user      : zhugl
-- task_name        : tbl_dwd_trade_author_translate_remuneration
-- task_version     : 4
-- update_time      : 2023-12-05 18:12:30
-- sql_path         : \starrocks\tbl_dwd_trade_author_translate_remuneration\tbl_dwd_trade_author_translate_remuneration
----------------------------------------------------------------
-- 前置SQL语句
delete from dwd.dwd_trade_author_translate_remuneration  where dt >= date(DATE_SUB('${bf_1_dt}' ,INTERVAL 1 year  ));

-- SQL语句
insert into  dwd.dwd_trade_author_translate_remuneration
select
a.dt,
a.auto_id,
a.to_language,
a.book_id,
a.author_id,
a.chapter_id,
a.author_type,
a.role_type,
a.pen_name,
a.real_name,
a.book_name,
a.chapter_name,
a.font_length,
a.price,
a.total_price,
a.currency_type,
a.pay_type,
a.remuneration_time,
a.bill_date,
a.st,
a.pay_st,
a.pay_time,
a.remark_by_first,
a.remark_by_second,
a.remark_by_third,
a.remark_by_pay,
a.create_time,
a.update_time,
a.remuneration_type,
a.price_type,
a.source_book_name,
a.from_language,
a.source_book_id,
a.pay_account,
a.bank_name,
a.account_name,
a.reason_type,
a.bank_sub_branch,
a.payment_type,
a.book_type,
a.undo_reason,
c.AccountName admin_Name,
d.DayTarget day_target,
d.MonthTarget month_target,
d.AuthorName author_name,
e.yearmonthstr year_month_str,
e.china_workday_flag ,
CASE WHEN weekOFYEAR(days_sub(datestr,-4)) = 1 AND MONTH(days_sub(datestr,-4)) = 12 THEN YEAR(days_sub(datestr,-4)) + 1
WHEN weekOFYEAR(days_sub(datestr,-4))  in(52, 53) AND MONTH(days_sub(datestr,-4)) = 1 THEN YEAR(days_sub(datestr,-4)) - 1
ELSE YEAR(days_sub(datestr,-4)) END *100 + weekOFYEAR(days_sub(datestr,-4)) AS week_id,
NOW()
FROM (select *  from  dwd.dwd_content_translate_remuneration   where dt >= date(DATE_SUB('${bf_1_dt}' ,INTERVAL 1 year  )) and Object_Book_Type !=1 )  a
left join ods.ods_tidb_shuangwen_en_viscadminconfig  c
on a.To_Language  = c.SiteId
left join  ods.ods_tidb_shuangwen_en_viscauthorconfig  d
on a.To_Language = d.SiteId  and a.Author_Id = d.AuthorId and SUBSTR(a.dt,1,7)  = SUBSTR(d.MonthTime,1,7) and a.Role_Type = d.RoleType
left JOIN dim.dim_date e on SUBSTR(a.dt,1,10) = e.datestr;
