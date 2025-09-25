insert overwrite  dim.dim_shuangwen_book_read_consume_info
 -- ------------获取书籍的超点章节数 -----------------------
with ft as (
    select  BookId ,langid from  ods.ods_tidb_readernovel_tidb_tag_center_book
    where BookId in (
        select  book_id from (
            select book_id,speed_chapter_num,count(1)
            from (  -- 繁体的书在英语和繁体种都有 需要排除掉
                select BookId as book_id,SpeedChapterNum as speed_chapter_num ,ChapterCount,langid from ods.ods_tidb_readernovel_tidb_tag_center_book  where LangId !=1 group by 1 ,2 ,3,4  having count(1)=1  -- 排除简体的书
            )  a
        where langid in (2,3)
        group by 1,2 having count(1)>1
        )  b
  ) and langid!=1
),speed_chapter as(
   select BookId as book_id,SpeedChapterNum as speed_chapter_num ,ChapterCount
   from ods.ods_tidb_readernovel_tidb_tag_center_book
   where LangId !=1 and concat(BookId,LangId) not in(
       select  concat(BookId,LangId)
       from ft
       where LangId=3
       )
       group by 1 ,2 ,3  having count(1)=1  -- 排除简体的书
)
select
    s3.productid,
    s3.bookid,
    s3.yt,
    if(s3.bookname is not null and bookname !='',s3.bookname,'-') bookname,
    if(s3.createtime is null or s3.createtime = '','1970-01-01 00:00:00',s3.createtime) as create_time,
    if(s3.updatetime is null or s3.updatetime = '','1970-01-01 00:00:00',s3.updatetime) as update_time,
    if(s3.booknature is null,'-',s3.booknature) as book_nature,
    if(s3.SignType is null,'-',s3.SignType) as sign_type,
    if(s3.Channel is null,'-',s3.Channel) as channel,
    if(s3.isfull is null,0,s3.isfull) as is_full,
    if(s3.siteid is null,'-',s3.siteid) as site_id,
    if(s3.siteid2 is null,'-',s3.siteid2) as site_id2,
    if(s3.priceperthousand is null,'-',s3.priceperthousand) as price_per_thousand,
    if(s3.NEWCID is null,'-',s3.NEWCID) as new_cid,
    if(s3.newcname is null or s3.newcname = '','-',s3.newcname) as new_cname,
    if(s3.Sexy2 is null,'-',s3.Sexy2) as sexy2,
    if(s3.normalchapternum_f is null,'-',s3.normalchapternum_f) as normal_chapter_num_f,-- 发布章节数
    if(s3.BuildTime is null or s3.BuildTime = '','1970-01-01 00:00:00',s3.BuildTime) as build_time,
    if(s3.BlockName is null or s3.BlockName = '','-',s3.BlockName) as block_name,
    s3.Fontlength as font_length,
    if(s3.BookCode is null or s3.BookCode = '','-',s3.BookCode) as book_code,
    s3.fulltime as full_time,
    s3.languageid,
    s3.public_fontlength,
    s3.authorid as author_id,
    s3.authorname as author_name,
    s3.free_chapter_num as Free_ChapterNum,
    if(s3.LatestUpdateTime is null or s3.LatestUpdateTime = '','1970-01-01 00:00:00',s3.LatestUpdateTime) as latest_update_time ,
    s3.ChapterNum as total_chapter_num , -- 总章节数
    IFNULL(speed_chapter_num ,0) as speed_chapter_num ,-- 超点章节数
    s3.IsPutdown,s3.PutdownLevel,s3.PenName,s3.AuthorType,
    now() as etl_time
from (
         -- 3311 fr  3501 id 3511 th  -----------------------------
         select 	s1.productid ,s1.bookid ,date(s1.createtime) as yt,s1.bookname ,s1.createtime ,s1.updatetime ,
     (case when s1.booknature is null then 0 else s1.booknature end) as booknature,
     s1.signtype ,s1.channel ,s1.isfull ,s1.siteid ,s1.siteid as siteid2,
     s1.priceperthousand ,c.newcid ,c.newcname ,
     c.sexy2 ,c.normalchapternum_f ,
     c.buildtime ,s1.blockname,s1.fontlength,s1.bookcode,s1.fulltime,s1.languageid,c.length as public_fontlength,s1.authorid ,s1.authorname ,c.latestupdatetime,
     speed_chapter.ChapterCount as ChapterNum -- 总章节数
        ,speed_chapter.speed_chapter_num -- 超点章节数
        ,free_num.free_chapter_num  -- 免费章节数
        ,s1.IsPutdown,s1.PutdownLevel,s1.PenName,s1.AuthorType
    from (
			select 	 case when a.siteid=410 then 3311 when a.siteid=414 then 3501 when a.siteid=433 then 3511 when a.siteid=412 then 3366 end  as productid ,(a.bookid*1000) +a.siteid as bookid, a.bookname ,a.createtime ,a.updatetime ,
					(case when b.authortype=4 and a.booknature not in (6,9) then 4  else a.booknature end)  booknature,
					a.signtype ,a.channel ,a.isfull ,a.siteid ,a.priceperthousand ,a.fontlength,a.bookcode,
					a.fulltime,a.language as languageid,a.authorid ,a.authorname,a.IsPutdown,a.PutdownLevel,b.PenName,b.AuthorType,x.blockname
			from   ods.ods_edit_book a   -- shuangwen_fr.book
			left join
			 ods.ods_edit_author b
			on a.authorid = b.accountid and b.productid =3311
			left join
			ods.ods_panda_publishermanager x
			 on a.siteid  = x.siteid
			where a.productid = 3311 and a.siteid in (410,412,414,433)

		) s1
	left join (
		select a.productid,bookid,a.newcid,b.cname as newcname,a.sexy2,a.normalchapternum_f,a.buildtime,length,latestupdatetime
			   from ods.ods_book_novel_book_m a
			   left join
			   ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new b
		on a.productid=b.productid  and  a.`language` =b.`language`  and a.newcid =b.cid
		where (a.productid = 3501 and a.siteid=414) or (a.productid = 3511 and a.siteid=433)  or (a.productid = 3311 and a.siteid=410) OR (a.productid = 3311 and a.siteid=412)
		) c
on s1.bookid=c.bookid
    left join
    -- ---获取书籍的超点章节数
    speed_chapter
    on  s1.bookid=speed_chapter.book_id
    left join  -- ---获取免费章节数
    dim.dim_book_free_chapter_num_temp free_num
    on s1.bookid=free_num.book_id
union all
-- 3322 pt -----------------------------
select 	s1.productid ,s1.bookid ,date(s1.createtime) as yt,s1.bookname ,s1.createtime ,s1.updatetime ,
    (case when s1.booknature is null then 0 else s1.booknature end) as booknature,
    s1.signtype ,s1.channel ,s1.isfull ,s1.siteid ,s1.siteid as siteid2,
    s1.priceperthousand ,c.newcid ,c.newcname ,
    c.sexy2 ,c.normalchapternum_f ,
    c.buildtime ,s1.blockname,s1.fontlength,s1.bookcode,s1.fulltime,s1.languageid,c.length as public_fontlength,s1.authorid ,s1.authorname ,c.latestupdatetime ,
    speed_chapter.ChapterCount as ChapterNum -- 总章节数
        ,speed_chapter.speed_chapter_num -- 超点章节数
        ,free_num.free_chapter_num  -- 免费章节数
        ,s1.IsPutdown,s1.PutdownLevel,s1.PenName,s1.AuthorType
from (

    select 	a.productid ,(a.bookid*1000) +a.siteid as bookid, a.bookname ,a.createtime ,a.updatetime ,
    (case when b.authortype=4 and a.booknature not in (6,9) then 4  else a.booknature end)  booknature,
    a.signtype ,a.channel ,a.isfull ,a.siteid ,a.priceperthousand ,a.fontlength,a.bookcode,
    a.fulltime,a.language as languageid,a.authorid ,a.authorname ,a.IsPutdown,a.PutdownLevel,b.PenName,b.AuthorType,x.blockname
    from   ods.ods_edit_book a
    left join
    ods.ods_edit_author b
    on a.authorid = b.accountid and b.productid =3322
    left join
    ods.ods_panda_publishermanager x
    on a.siteid  = x.siteid
    where a.productid = 3322 and a.siteid=409
    ) s1
    left join (
    select a.productid,bookid,a.newcid,b.cname as newcname,a.sexy2,a.normalchapternum_f,a.buildtime,length,latestupdatetime
    from ods.ods_book_novel_book_m a
    left join
    ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new b
    on a.productid=b.productid  and  a.`language` =b.`language`  and a.newcid =b.cid
    where a.productid = 3322 and a.siteid=409
    ) c
on s1.bookid=c.bookid
    left join
    -- ---获取书籍的超点章节数
    speed_chapter
    on  s1.bookid=speed_chapter.book_id
    left join -- ---获取免费章节数
    dim.dim_book_free_chapter_num_temp free_num
    on s1.bookid=free_num.book_id
union all
-- 3366 en ko tl  -----------------------------
select 	s1.productid ,s1.bookid ,date(s1.createtime) as yt,s1.bookname ,s1.createtime ,s1.updatetime ,
    (case when s1.booknature is null then 0 else s1.booknature end) as booknature,
    s1.signtype ,s1.channel ,s1.isfull ,s1.siteid ,s1.siteid as siteid2,
    s1.priceperthousand ,c.newcid ,c.newcname ,
    c.sexy2 ,c.normalchapternum_f ,
    c.buildtime ,s1.blockname,s1.fontlength,s1.bookcode,s1.fulltime,s1.languageid,c.length as public_fontlength,s1.authorid ,s1.authorname ,c.latestupdatetime ,
    speed_chapter.ChapterCount as ChapterNum -- 总章节数
        ,speed_chapter.speed_chapter_num -- 超点章节数
        ,free_num.free_chapter_num  -- 免费章节数
        ,s1.IsPutdown,s1.PutdownLevel,s1.PenName,s1.AuthorType
from (
    select 	a.productid ,(a.bookid*1000) +a.siteid as bookid, a.bookname ,a.createtime ,a.updatetime ,
    (case when b.authortype=4 and a.booknature not in (6,9) then 4  else a.booknature end)  booknature,
    a.signtype ,a.channel ,a.isfull ,a.siteid ,a.priceperthousand ,a.fontlength,a.bookcode,
    a.fulltime,case when a.siteid=322 then 3
    when a.siteid=436 then 14 when a.siteid=445 then 15 when a.siteid=435 then 13 when a.siteid=497 then 22 end as languageid,a.authorid ,a.authorname,a.IsPutdown,a.PutdownLevel,b.PenName,b.AuthorType,x.blockname
    from   ods.ods_edit_book a
    left join
    ods.ods_edit_author b
    on a.authorid = b.accountid and b.productid =3366
    left join
    ods.ods_panda_publishermanager x
    on a.siteid  = x.siteid
    where a.productid = 3366 and a.siteid in (322,436,445,435,497)
    ) s1
    left join (
    select a.productid,bookid,a.newcid,b.cname as newcname,a.sexy2,a.normalchapternum_f,a.buildtime,length,latestupdatetime
    from ods.ods_book_novel_book_m a
    left join
    ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new b
    on     a.newcid =b.cid and b.`Language` =3
    where a.productid = 3366 and a.siteid in (322,436,445,435,497)
    ) c	on s1.bookid=c.bookid
    left join
    -- ---获取书籍的超点章节数
    speed_chapter
    on  s1.bookid=speed_chapter.book_id
    left join -- ---获取免费章节数
    dim.dim_book_free_chapter_num_temp free_num
    on s1.bookid=free_num.book_id
union all
-- 3388 sp 3371 ru 3399 jp  -----------------------------
select 	s1.productid ,s1.bookid ,date(s1.createtime) as yt,s1.bookname ,s1.createtime ,s1.updatetime ,
    (case when s1.booknature is null then 0 else s1.booknature end) as booknature,
    s1.signtype ,s1.channel ,s1.isfull ,s1.siteid ,s1.siteid as siteid2,
    s1.priceperthousand ,c.newcid ,c.newcname ,
    c.sexy2 ,c.normalchapternum_f ,
    c.buildtime ,s1.blockname,s1.fontlength,s1.bookcode,s1.fulltime,s1.languageid,c.length as public_fontlength,s1.authorid ,s1.authorname ,c.latestupdatetime ,
    speed_chapter.ChapterCount as ChapterNum -- 总章节数
        ,speed_chapter.speed_chapter_num -- 超点章节数
        ,free_num.free_chapter_num  -- 免费章节数
        ,s1.IsPutdown,s1.PutdownLevel,s1.PenName,s1.AuthorType
from (

    select 	case when a.siteid=375 then 3388 when a.siteid=418 then 3371 when a.siteid=419 then 3399 end  as productid  ,(a.bookid*1000) +a.siteid as bookid, a.bookname ,a.createtime ,a.updatetime ,
    (case when b.authortype=4 and a.booknature not in (6,9) then 4  else a.booknature end)  booknature,
    a.signtype ,a.channel ,a.isfull ,a.siteid ,a.priceperthousand ,a.fontlength,a.bookcode,
    a.fulltime,if(a.siteid=419,9,a.language)  as languageid,a.authorid ,a.authorname,a.IsPutdown,a.PutdownLevel,b.PenName,b.AuthorType,x.blockname
    from   ods.ods_edit_book a
    left join
    ods.ods_edit_author b
    on a.authorid = b.accountid and b.productid =3388
    left join
    ods.ods_panda_publishermanager x
    on a.siteid  = x.siteid
    where a.productid = 3388 and a.siteid in (375,418,419)
    ) s1
    left join (
    select a.productid,bookid,a.newcid,b.cname as newcname,a.sexy2,a.normalchapternum_f,a.buildtime,length,latestupdatetime
    from ods.ods_book_novel_book_m a
    left join
    ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new b
    on a.productid=b.productid  and  a.`language` =b.`language`  and a.newcid =b.cid
    where (a.productid = 3388 and a.siteid=375) or (a.productid = 3371 and a.siteid=418) or (a.productid = 3399 and a.siteid=419)
    ) c
on s1.bookid=c.bookid
    left join
    -- ---获取书籍的超点章节数
    speed_chapter
    on  s1.bookid=speed_chapter.book_id
    left join -- ---获取免费章节数
    dim.dim_book_free_chapter_num_temp free_num
    on s1.bookid=free_num.book_id
union all
-- ------------3333-------------------------------------
SELECT 	'3333' as productid,a.bookid,date(a.BuildTime) as yt,a.bookname,a.row_create_time as createtime,a.updatetime,
    (case when a.booknature is null then 0
    when right(a.bookid,3)='450' then 4
          -- when right(a.bookid,3) in (090,446,449) then 2
    when (right(a.bookid,3) ='090') or (right(a.bookid,3) ='449' and d.DepartmentType=1 ) then '凤鸣轩'
    when right(a.bookid,3) ='446' then '精修编辑部'
    when right(a.bookid,3) ='449' and d.DepartmentType=0 then '内容编辑部'
    else a.booknature end) as booknature,
    case when a.source in (1,2) then 0 else 2 end as SignType,a.Channel,
			a.isfull,a.siteid,333 as siteid2,a.priceperthousand,a.NEWCID,c.newcname,a.Sexy2,a.normalchapternum_f,a.BuildTime,x.BlockName as blockname,Length as Fontlength,b.BookNo as BookCode,a.fulltime,
			if(a.Language=0 ,2,a.Language) Languageid,a.Length as public_fontlength,a.authorid,a.authorname,a.LatestUpdateTime,a.normalchapternum_f as ChapterNum -- 这是总章节数
			,speed_chapter.speed_chapter_num -- 超点章节数
			,free_num.free_chapter_num  -- 免费章节数
			,null as IsPutdown,null as PutdownLevel,null as PenName,null as AuthorType
	FROM ods.ods_book_novel_book_m a
	left join
	( -- 获取繁体的书籍代号----
		 select BookId ,max(BookNo) as  BookNo
	 from (
	 -- 繁体配置的书
	select  BookId ,BookNo  from ods.ods_tidb_readernovel_tidb_tag_center_book_information where  LangId =2  and BookNo  !=''  group by 1,2
	union all
	 -- 新掌中的书  449 090的书
	 select BookId*1000+SiteId as BookId  ,BookCode as BookNo  from ods.ods_mysql_zhangzhong_xzz_Book  group by 1,2
	 ) a  group by 1
	) b
	on a.bookid =b.bookid -- 获取书籍的 书籍分类 CName ,SEXY 等----
	left join
	(select  cid,sexy as Sexy2,cname as newcname from ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new  WHERE productid =3333 ) c
	on a.NEWCID=c.cid
					left join
		-- ---获取书籍的超点章节数
		speed_chapter
		on  a.bookid=speed_chapter.book_id
		left join -- ---获取免费章节数
		dim.dim_book_free_chapter_num_temp free_num
		on a.bookid=free_num.book_id
	left join
	--  DepartmentType '部门类型 0内容编辑部 1凤鸣轩'  凤鸣轩新的书是在新掌中站点创建的，虽然书的siteid=449但是书的来源还是属于凤鸣轩
	(select  BookID*1000+siteid as book_id,DepartmentType from  ods.ods_mysql_zhangzhong_xzz_Book where SiteID =449  order by 2 ,1 ) d
	on a.bookid=d.book_id
	left join ods.ods_panda_publishermanager x on a.siteid  = x.siteid
	 where a.productid = 3333

	UNION ALL
	-- 2025-04-21 增加海外简体的书  Language = 19
SELECT 	productid,a.bookid,date(a.BuildTime) as yt,a.bookname,a.row_create_time as createtime,a.updatetime,
    (case when a.booknature is null then 0
    when right(a.bookid,3)='450' then 4
          -- when right(a.bookid,3) in (090,446,449) then 2
    when (right(a.bookid,3) ='090') or (right(a.bookid,3) ='449' and d.DepartmentType=1 ) then '凤鸣轩'
    when right(a.bookid,3) ='446' then '精修编辑部'
    when right(a.bookid,3) ='449' and d.DepartmentType=0 then '内容编辑部'
    else a.booknature end) as booknature,
    case when a.source in (1,2) then 0 else 2 end as SignType,a.Channel,
			a.isfull,a.siteid,a.siteid as siteid2,a.priceperthousand,a.NEWCID,c.newcname,a.Sexy2,a.normalchapternum_f,a.BuildTime,x.BlockName as blockname,Length as Fontlength,b.BookNo as BookCode,a.fulltime,
			if(a.Language=0 ,2,a.Language) Languageid,a.Length as public_fontlength,a.authorid,a.authorname,a.LatestUpdateTime,a.normalchapternum_f as ChapterNum -- 这是总章节数
			,speed_chapter.speed_chapter_num -- 超点章节数
			,free_num.free_chapter_num  -- 免费章节数
			,null as IsPutdown,null as PutdownLevel,null as PenName,null as AuthorType
	FROM ods.ods_book_novel_book_m a
	left join
	( -- 获取繁体的书籍代号----
		 select BookId ,max(BookNo) as  BookNo
	 from (
	 -- 繁体配置的书
	select  BookId ,BookNo  from ods.ods_tidb_readernovel_tidb_tag_center_book_information where  LangId =2  and BookNo  !=''  group by 1,2
	union all
	 -- 新掌中的书  449 090的书
	 select BookId*1000+SiteId as BookId  ,BookCode as BookNo  from ods.ods_mysql_zhangzhong_xzz_Book  group by 1,2
	 ) a  group by 1
	) b
	on a.bookid =b.bookid -- 获取书籍的 书籍分类 CName ,SEXY 等----
	left join
	(select  cid,sexy as Sexy2,cname as newcname from ods.ods_tidb_readernovel_tidb_en_novel_bookcategory_new  WHERE productid =3333 ) c
	on a.NEWCID=c.cid
					left join
		-- ---获取书籍的超点章节数
		speed_chapter
		on  a.bookid=speed_chapter.book_id
		left join -- ---获取免费章节数
		dim.dim_book_free_chapter_num_temp free_num
		on a.bookid=free_num.book_id
	left join
	--  DepartmentType '部门类型 0内容编辑部 1凤鸣轩'  凤鸣轩新的书是在新掌中站点创建的，虽然书的siteid=449但是书的来源还是属于凤鸣轩
	(select  BookID*1000+siteid as book_id,DepartmentType from  ods.ods_mysql_zhangzhong_xzz_Book where SiteID =449  order by 2 ,1 ) d
	on a.bookid=d.book_id
	left join ods.ods_panda_publishermanager x on a.siteid  = x.siteid
	 where a.Language = 19

	union all -- --------------3333  ------------------------------
select 	'3333' as productid,voicebookid*1000+990 as bookid,date(createtime) as yt,bookname,createtime,updatetime,
    8 as booknature,0 as SignType,null as Channel,isfull,null as siteid,333 as siteid2,null as priceperthousand,
    null as NEWCID,null as newcname,Sexy as Sexy2,null as normalchapternum_f,createtime as BuildTime,null as blockname,null as Fontlength,null as BookCode,null as fulltime,
    2 as Languageid,null as public_fontlength,null as authorid,authorname,'1970-01-01 00:00:00' as LatestUpdateTime,null as ChapterNum,
    0 as speed_chapter_num -- 超点章节数
        ,0 as free_chapter_num -- 免费章节数
        ,null as IsPutdown,null as PutdownLevel,null as PenName,null as AuthorType
from ods.ods_voice_book
    ) s3;