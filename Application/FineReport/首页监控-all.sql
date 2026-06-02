------------------------------------------------
-- title：【沙盘all】表格明细充值总额波动异常
-- level：P1
-- 浮动值差异 <= 15%
-- 频率：0 15/30 * * * ?
------------------------------------------------

select coalesce(abs(cast((a2.charge_money - a1.charge_money) / nullif(a1.charge_money, 0) * 100 as double)),0) as ratio
from (select coalesce(sum(charge_money), 0) as charge_money from ads.ads_report_first_page_data35 where create_date = date_sub(current_date(), interval 2 day)) as a1
        ,(select coalesce(sum(charge_money), 0) as charge_money from ads.ads_report_first_page_data35 where create_date = date_sub(current_date(), interval 1 day)) as a2
;