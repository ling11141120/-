create view `ads_bi_short_video_adv_income_report_userdata_view`
            (`dt` comment "日期", `product_id` comment "产品id", `mt` comment "平台", `core` comment "包体",
             `dau` comment "日活用户数", `dnu` comment "新增用户数",
             `deu` comment "每天展示过广告的独立用户数（来源预估收益的表）",
             `deu_user` comment "每天展示过广告的独立用户", `ad_unlock_user_cnt` comment "广告解锁用户数",
             `motiv_deu` comment "激励视频活跃（广告类型为激励视频时的广告展现用户数", `income` comment "充值收入")
as
select `a`.`dt`
     , `a`.`product_id`
     , `a`.`mt`
     , `a`.`corever`
     , `a`.`dau`
     , `a`.`dnu`
     , `b`.`deu`
     , `b`.`deu_user`
     , `d`.`ad_unlock_user_cnt`
     , `b`.`motiv_deu`
     , `c`.`income`
  from (select `dws`.`a`.`dt`
             , `dws`.`a`.`product_id`
             , `dws`.`a`.`mt`
             , if((`dws`.`a`.`corever` is null) or (`dws`.`a`.`corever` = 0), 1, `dws`.`a`.`corever`)                 as `corever`
             , count(distinct `dws`.`a`.`user_id`)                                                                    as `dau`
             , count(distinct case when (`dws`.`a`.`dt` = (date(`dws`.`a`.`reg_time`))) then `dws`.`a`.`user_id`
                              end)                                                                                    as `dnu`
          from `dws`.`dws_user_short_video_wide_active_ed` as `a`
         where `dws`.`a`.`product_id` = 6833
         group by 1, 2, 3, 4
        )            `a`
  left outer join (select `a`.`dt`
                        , `a`.`product_id`
                        , `a`.`mt`
                        , `a`.`core`
                        , count(distinct `a`.`user_id`)                                         as `deu`
                        , ``.bitmap_agg(`a`.`user_id`)                                          as `deu_user`
                        , count(distinct if(`dim`.`b`.`ad_show_type` = 3, `a`.`user_id`, null)) as `motiv_deu`
                     from (select `dws`.`dws_advertisement_user_position_amt_ed`.`dt`
                                , `dws`.`dws_advertisement_user_position_amt_ed`.`product_id`
                                , `dws`.`dws_advertisement_user_position_amt_ed`.`mt`
                                , `dws`.`dws_advertisement_user_position_amt_ed`.`core`
                                , `dws`.`dws_advertisement_user_position_amt_ed`.`user_id`
                                , `dws`.`dws_advertisement_user_position_amt_ed`.`positions`
                             from `dws`.`dws_advertisement_user_position_amt_ed`
                            where `dws`.`dws_advertisement_user_position_amt_ed`.`product_id` = 6833
                           )                                             `a`
                     left outer join `dim`.`dim_sv_ads_position_view` as `b`
                     on `a`.`positions` = `dim`.`b`.`ad_position`
                    group by `a`.`dt`, `a`.`product_id`, `a`.`mt`, `a`.`core`
                   ) `b`
  on (((`a`.`dt` = `b`.`dt`) and (`a`.`product_id` = `b`.`product_id`)) and (`a`.`mt` = `b`.`mt`)) and
     (`a`.`corever` = `b`.`core`)
  left outer join (select `dws`.`dws_trade_short_video_user_payorder_ed`.`dt`
                        , `dws`.`dws_trade_short_video_user_payorder_ed`.`product_id`
                        , `dws`.`dws_trade_short_video_user_payorder_ed`.`mt`
                        , `dws`.`dws_trade_short_video_user_payorder_ed`.`corever`
                        , round(sum(`dws`.`dws_trade_short_video_user_payorder_ed`.`sum_base_amount` / 100),
                                2) as `income`
                     from `dws`.`dws_trade_short_video_user_payorder_ed`
                    where `dws`.`dws_trade_short_video_user_payorder_ed`.`product_id` = 6833
                    group by 1, 2, 3, 4
                   ) `c`
  on (((`a`.`dt` = `c`.`dt`) and (`a`.`product_id` = `c`.`product_id`)) and (`a`.`mt` = `c`.`mt`)) and
     (`a`.`corever` = `c`.`corever`)
  left outer join (select date(`dwd`.`a`.`create_time`)          as `dt`
                        , `dim`.`b`.`mt`
                        , `dim`.`b`.`corever`                    as `core`
                        , count(distinct `dwd`.`a`.`account_id`) as `ad_unlock_user_cnt`
                     from `dwd`.`dwd_short_video_series_unlock_view`          as `a`
                     left outer join `dim`.`dim_short_video_user_accountinfo` as `b`
                     on `dwd`.`a`.`account_id` = `dim`.`b`.`user_id`
                    group by 1, 2, 3
                   ) `d`
  on ((`a`.`dt` = `d`.`dt`) and (`a`.`mt` = `d`.`mt`)) and (`a`.`corever` = `d`.`core`);