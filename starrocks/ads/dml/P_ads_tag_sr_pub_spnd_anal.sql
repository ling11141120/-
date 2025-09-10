----------------------------------------------------------------
-- 程序功能： TAG海阅上架与消耗分析
-- 程序名： P_ads_tag_sr_pub_spnd_anal
-- 目标表： ads.ads_tag_sr_pub_spnd_anal
-- 负责人： qhr
-- 开发日期： 2025-09-10
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_tag_sr_pub_spnd_anal

     dt                     DATETIME      NOT NULL COMMENT '日期'
    ,book_id                BIGINT        NOT NULL COMMENT '书籍id'
    ,lang_cd                INT                    COMMENT '语言编码'
    ,lang_name              VARCHAR(50)            COMMENT '语言名称'
    ,rcoin_giftvchr_amt_30d DECIMAL(10,0)          COMMENT '近30日阅币礼券消耗数额'
    ,rec_time               DATETIME               COMMENT '推荐时间'
    ,etl_time               DATETIME               COMMENT 'etl时间'

-- ①书籍上架时间：在 120 天到 600 天之间    dim_novel_book_info_view.build_time
-- ⑥近30天书籍合计消耗（阅币+礼券）≤10000    dwd_consume_user_consume

