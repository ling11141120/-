----------------------------------------------------------------
-- 程序功能： TAG海阅上架与消耗分析
-- 程序名： P_ads_tag_sr_pub_spnd_anal
-- 目标表： ads.ads_tag_sr_pub_spnd_anal
-- 负责人： qhr
-- 开发日期： 2025-09-10
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_tag_sr_pub_spnd_anal
select now()                                        as dt                        -- 日期
      ,a1.book_id                                   as book_id                   -- 书籍id
      ,a1.language_id                               as lang_cd                   -- 语言编码
      ,a3.cd_val_desc                               as lang_name                 -- 语言名称
      ,a2.rcoin_giftvchr_amt_30d                    as rcoin_giftvchr_amt_30d    -- 近30日阅币礼券消耗数额
      ,date_add(now(), interval 7 day)              as rec_time                  -- 推荐时间
      ,now()                                        as etl_time                  -- etl时间
  from dim.dim_novel_book_info_view                 as a1
  left join (select b1.book_id
                   ,sum(b1.amount)                  as rcoin_giftvchr_amt_30d
               from dwd.dwd_consume_user_consume    as b1
              where b1.dt >= date_sub('${bf_1_dt}', interval 30 day)
                and b1.dt <= '${bf_1_dt}'
                and b1.types in (1, 2)    -- 阅币 & 礼券
              group by 1
            )                                       as a2
    on a1.book_id = a2.book_id
  left join dim.dim_pub_code_mapping_dict           as a3
    on a1.language_id = a3.cd_val
   and a3.app_plat = 'pub'
   and a3.cd_col = 'lang_cd'
 where a1.build_time >= date_sub('${bf_1_dt}', interval 600 day)
   and a1.build_time <= date_sub('${bf_1_dt}', interval 120 day)
   and a2.rcoin_giftvchr_amt_30d <= 10000
;