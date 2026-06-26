----------------------------------------------------------------
-- 程序功能：海阅书籍评论同步至海剧 TiDB 源表
-- 目标表：ads.ads_bi_short_video_novel_comment_item_di
-- 开发日期：2026-06-24
----------------------------------------------------------------

drop table if exists ads.ads_bi_short_video_novel_comment_item_di;
create table ads.ads_bi_short_video_novel_comment_item_di (
     id                   bigint          not null                    comment "评论唯一主键ID"
    ,account_id           bigint          not null                    comment "评论发送人用户ID"
    ,nickname             varchar(765)                                comment "评论发送人用户昵称"
    ,avatar               varchar(1536)                               comment "评论发送人头像URL"
    ,book_id              bigint          not null                    comment "书籍ID"
    ,chapter_id           bigint                                      comment "评论所属章节ID"
    ,ex_comment_id        bigint          not null                    comment "父级评论ID，回复评论时关联上级评论"
    ,title                varchar(765)                                comment "评论标题"
    ,content              varchar(65533)  not null                    comment "评论内容"
    ,score                int             not null                    comment "书籍评分"
    ,comment_status       int             not null                    comment "评论状态：0正常、1屏蔽、2删除、3待审核"
    ,top_time             datetime                                    comment "评论置顶时间"
    ,is_top               tinyint         not null                    comment "是否置顶：0否，1是"
    ,is_choice            tinyint         not null                    comment "是否精选评论：0否，1是"
    ,is_author            tinyint         not null                    comment "是否作者本人评论：0否，1是"
    ,support_count        int             not null                    comment "评论点赞/支持数量"
    ,reply_count          int             not null                    comment "评论回复数量"
    ,classify             int             not null                    comment "评论分类枚举值"
    ,classification       varchar(765)                                comment "评论分类文字描述"
    ,comment_source       int                                         comment "评论发布来源端"
    ,my_classify          double                                      comment "AI自动分类打分值"
    ,hot_num              int                                         comment "评论热度分值"
    ,audit_status         tinyint                                     comment "是否完成内容审核：0未审核，1已审核"
    ,spam_source          int                                         comment "被标记为垃圾评论时，标记来源"
    ,book_comment_type    bigint                                      comment "书籍评论类型：0 用户评论，1 AI评论"
    ,send_time            datetime        not null                    comment "评论发布时间"
    ,send_timestamp       bigint                                      comment "评论发送时间戳（秒级Unix）"
    ,create_time          datetime        not null                    comment "创建时间"
    ,update_time          datetime        not null                    comment "最后更新时间"
)
primary key(id)
comment "海阅书籍评论同步至海剧 TiDB 源表"
distributed by hash(id) buckets 3
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
);
