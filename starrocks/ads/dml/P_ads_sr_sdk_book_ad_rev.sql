----------------------------------------------------------------
-- 程序功能： sdk-c4-书籍广告收入-iaa作者分成使用
-- 程序名： P_ads_sr_sdk_book_ad_rev
-- 目标表： ads.ads_sr_sdk_book_ad_rev
-- 负责人： xjc
-- 开发日期：2026-06-17
----------------------------------------------------------------

delete from ads.ads_sr_sdk_book_ad_rev where dt >= '${bf_1_dt}' and dt<= '${dt}';

insert into ads.ads_sr_sdk_book_ad_rev
select dt                      as dt
      ,product_id              as product_id
      ,corever                 as core
      ,book_id                 as book_id
      ,sum(ad_position_amt)    as ad_revenue
from dwd.dwd_advertisement_user_position_amt_p_di
where dt >= '${bf_1_dt}'
  and dt<= '${dt}'
  and corever = 4
  and product_id != 6833
group by 1, 2, 3, 4
;