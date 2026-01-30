----------------------------------------------------------------
-- 程序功能： 用户域-海剧用户状态指标表-按月全量
-- 程序名： P_dws_user_sv_status_idx_his_mf
-- 目标表： dws.dws_user_sv_status_idx_his_mf
-- 负责人： qhr
-- 开发日期： 2025-12-29
----------------------------------------------------------------

-- 每月2号将1号数据写入备份
insert into dws.dws_user_sv_status_idx_his_mf
select '${bf_1_dt}'    as dt            -- 分区日期
     , user_id                          -- 用户id
     , fst_login_tm                     -- 首次登录时间
     , lst_login_tm                     -- 上一次登录时间
     , new_login_tm                     -- 最新登录时间
     , remain_day                       -- 登录留存天数
     , fst_consume_tm                   -- 首次消费时间
     , lst_consume_tm                   -- 最近一次消费时间
     , consume_tv_td                    -- 消费剧集bitmap(剧id+集序号)
     , fst_consume_money_tm             -- 首次消费代币时间
     , lst_consume_money_tm             -- 最近一次消费代币时间
     , consume_money_tv_td              -- 代币消费剧集bitmap(剧id+集序号)
     , fst_consume_cert_tm              -- 首次消费赠币时间
     , lst_consume_cert_tm              -- 最近一次消费赠币时间
     , consume_cert_tv_td               -- 赠币消费剧集bitmap(剧id+集序号)
     , fst_watch_tm                     -- 首次观看时间
     , lst_watch_tm                     -- 末次观看时间
     , new_epis_series_td               -- 观看到了最新剧集的剧集
     , first_subscribe_amt              -- 首次订阅金额
     , first_subscribe_tp               -- 首次订阅类型
     , first_subscribe_tm               -- 首次订阅时间
     , last_subscribe_amt               -- 最后订阅金额
     , last_subscribe_tp                -- 最后订阅类型
     , last_subscribe_tm                -- 最后订阅时间
     , first_recharge_amt               -- 首次充值金额
     , first_recharge_tm                -- 首次充值时间
     , recharge_max                     -- 最大充值金额
     , month_recharge_max               -- 近一个月最大充值金额
     , last_recharge_amt                -- 最后充值金额
     , last_recharge_tm                 -- 最近充值时间
     , charge_mode                      -- 充值众数（不考虑退款因素）
     , fst_like_tm                      -- 首次点赞时间
     , lst_like_tm                      -- 末次点赞时间
     , fst_install_book_id              -- 首次引流书籍
     , lst_install_book_id              -- 最新引流书籍
     , lst_source                       -- 最新媒体值
     , lst_install_date                 -- 最新激活时间
     , now()           as etl_time      -- etl时间
     , fst_recharge_watch_series_num    -- 首冲观看剧数
     , fst_recharge_watch_epis_num      -- 首充观看集数
     , lst_third_recharge_tm            -- 最近三方充值时间
     , reg_fst_recharge_duration        -- 注册到首充的分钟数
     , fst_sign_card_price              -- 首次签到卡金额
     , fst_vip_price                    -- 首次VIP金额
     , fst_svip_price                   -- 首次SVIP金额
     , max_bonus_ratio                  -- 最高礼券加赠比例
     , lst_bonus_ratio                  -- 最近一次礼券加赠比例
     , fst_preload_reward_ecpm          -- 首次预加载激励视频eCPM
     , lst_preload_reward_ecpm          -- 最近预加载激励视频eCPM
     , fst_preload_intersitial_ecpm     -- 首次预加载插屏eCPM
     , lst_preload_intersitial_ecpm     -- 最近预加载插屏eCPM
  from dws.dws_user_sv_status_idx_di
;