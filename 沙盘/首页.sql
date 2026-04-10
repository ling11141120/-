------------------------------------------------
-- 海阅
------------------------------------------------

-- 海阅-表格-首页数据
select create_date
     , DAU
     , new_num          as `新增用户数`
     , charge_num       as `充值人数`  -- 充值用户数
     , charge_money     as `充值金额`  -- 充值总额
     , first_charge_num as `首充用户数`  -- 首充用户数
  from ads.ads_report_first_page_data2
 order by 1 desc
;

-- 海阅-表格-充值数据
select dt
     , sum(charge_num)       as `充值人数`
     , sum(charge_money)     as `充值金额`
     , sum(fisrt_charge_num) as `首充用户数`
  from ads.ads_user_charge_1d
 where dt >= date_sub(curdate(), interval 30 day)
   and product_id in (3311, 3322, 3333, 3366, 3371, 3388, 3399, 3501, 3511)
 group by 1
;