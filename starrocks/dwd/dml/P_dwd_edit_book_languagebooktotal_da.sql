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
	end) and  ( UpdateTime >='${bf_2_dt}' or  StatisticsDate >='${bf_2_dt}')