----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ods_tidb_readernovel_tidb_tag_center_book
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : ods_tidb_readernovel_tidb_tag_center_book_source
-- task_version     : 3
-- update_time      : 2025-01-10 16:47:05
-- sql_path         : \starrocks\sch_ods_tidb_readernovel_tidb_tag_center_book\ods_tidb_readernovel_tidb_tag_center_book_source
----------------------------------------------------------------
-- SQL语句
INSERT INTO ods.ods_tidb_readernovel_tidb_tag_center_book
select
a.BookId,
a.LangId,
a.BookName,
a.BookNo,
a.AuthorId,
a.AuthorName,
a.BookNature,
a.Channel,
a.CId,
a.CName,
a.TotalLength,
a.ChapterCount,
a.VipChapterCount,
a.PublishChapterCount,
a.PricePerThousand,
a.IsFull,
a.IsPutaway,
ifnull(b.Score, a.Score),
a.IsMutex,
a.ReadCount,
a.SignType,
a.ImgSrc,
a.Introduce,
a.CreateTime,
a.TagIds,
a.FreeChapterNum,
a.IsBookStore,
a.UpdateTime,
a.TotalPublishLength,
a.RealTimeScore,
a.RealTimeScoreTime,
a.RealTimeScoreNum,
a.SiteId,
a.Sexy2,
a.SpeedChapterNum,
a.sr_createtime,
a.sr_updatetime
from ods.ods_tidb_readernovel_tidb_tag_center_book_source a
LEFT  JOIN ods.ods_tidb_readernovel_tidb_tag_center_book_information b
ON a.BookId = b.BookId
AND a.LangId = b.LangId;
