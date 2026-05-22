----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_content_translate_remuneration
-- workflow_version : 5
-- create_user      : zhengtt
-- task_name        : dwd_content_translate_remuneration
-- task_version     : 5
-- update_time      : 2024-07-04 21:00:23
-- sql_path         : \starrocks\tbl_dwd_content_translate_remuneration\dwd_content_translate_remuneration
----------------------------------------------------------------
-- SQL语句
insert into   dwd.dwd_content_translate_remuneration
select 	date(RemunerationTime) as dt,Id,a.ToLanguage,(BookId*1000+a.ToLanguage) as BookId ,AuthorId,ObjectChapterId,AuthorType,RoleType,
		PenName,RealName,BookName,ChapterName,FontLength,Price,TotalPrice,
		CurrencyType,PayType,RemunerationTime,BillDate,Status,PayStatus,PayTime,
		RemarkByFirst,RemarkBySecond,RemarkByThird,RemarkByPay,CreateTime,UpdateTime,
		RemunerationType,PriceType,SourceBookName,FromLanguage,SourceBookId,PayAccount,
		BankName,AccountName,ReasonType,BankSubBranch,PaymentType,BookType,UndoReason,ObjectBookType,IsCostRate,
		now() as etl_time
from ods.ods_tidb_shuangwen_en_translateremuneration a
left join (select  if(productid=0,3322,productid) as productid ,SwBookId ,ToLanguage,max(ObjectBookType)ObjectBookType,max(IsCostRate)IsCostRate  from ods.ods_tidb_shuangwen_en_objectbook group by 1,2,3
)b on  a.BookId  = SwBookId and a.ToLanguage =b.ToLanguage
 where    date(RemunerationTime) <= '${bf_1_dt}' and date(RemunerationTime) >= date(DATE_SUB('${bf_1_dt}' ,INTERVAL 60 day  )) and BookId > 0
union ALL
select 	date(RemunerationTime) as dt,Id,ToLanguage,BookId,AuthorId,ObjectChapterId,AuthorType,RoleType,
		PenName,RealName,BookName,ChapterName,FontLength,Price,TotalPrice,
		CurrencyType,PayType,RemunerationTime,BillDate,Status,PayStatus,PayTime,
		RemarkByFirst,RemarkBySecond,RemarkByThird,RemarkByPay,CreateTime,UpdateTime,
		RemunerationType,PriceType,SourceBookName,FromLanguage,SourceBookId,PayAccount,
		BankName,AccountName,ReasonType,BankSubBranch,PaymentType,BookType,UndoReason,
		null,null,
		now() as etl_time
from ods.ods_tidb_shuangwen_en_translateremuneration
 where  date(RemunerationTime) <= '${bf_1_dt}' and date(RemunerationTime) >= date(DATE_SUB('${bf_1_dt}' ,INTERVAL 60 day  )) and  BookId <= 0;
