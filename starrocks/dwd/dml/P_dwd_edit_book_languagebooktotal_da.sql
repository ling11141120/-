----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_edit_book_languagebooktotal_da
-- workflow_version : 3
-- create_user      : zhugl
-- task_name        : tbl_dwd_edit_book_languagebooktotal_da
-- task_version     : 3
-- update_time      : 2024-07-05 09:50:25
-- sql_path         : \starrocks\tbl_dwd_edit_book_languagebooktotal_da\tbl_dwd_edit_book_languagebooktotal_da
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_edit_book_languagebooktotal_da
select
	date(StatisticsDate)  dt,
	tobookid * 1000 + tolanguage as tobookid,
	FromBookId,
	Productid,
	Id,
	ToBookName,
	FromBookName,
	ToBookId ,
	ToLanguage,
	FromLanguage,
	EditPublishNumber,
	EditProofreadNumber,
	AppPublishCount,
	ProofreadCount,
	ForeigningCount,
	ProofreadingCount,
	PublishingCount,
	ProofreadNumber,
	ForeignResidue,
	UpdateTime,
	StatisticsDate,
	StrConent,
	CNBookName,
	RollbackSequenceNum,
	ForeignedDayCount,
	CheckDayCount,
	BookStatus,
	MinProofreadNumber,
	ForeignNumber,
	InterpreterNumber,
	MinForeignNumber,
	MinInterpreterNumber,
	null as RowVersion,
	ChapterStatus,
	ChapterPlusNumByDay,
	ChapterPlusNumByWeek,
	CollectionByForeign,
	StopUpdateNum,
	PublishLength,
	BookCode,
	Remark,
	cast( publishingcount  / ChapterPlusNumByDay as int),
	NOW()
from
	ods.ods_edit_book_LanguageBookTotal
where
	(case
		when FromBookId in (92641090, 168177, 104925090) then ToLanguage != 375
		else 1 = 1
	end) and  ( UpdateTime >='${bf_2_dt}' or  StatisticsDate >='${bf_2_dt}');
