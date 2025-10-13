----------------------------------------------------------------
-- 程序功能： 内容域翻译书籍销售情况明细表
-- 程序名： P_dws_content_translate_remuneration_ed
-- 目标表： dws.dws_content_translate_remuneration_ed
-- 负责人： qhr
-- 开发日期：2025-10-13
-- 版本号： v0.0.1
----------------------------------------------------------------

insert into dws.dws_content_translate_remuneration_ed
with product_lang_code_mapping as (
    select a1.cd_val                             as book_lang_cd
          ,a2.cd_val                             as product_id
      from dim.dim_pub_code_mapping_dict         as a1
      left join dim.dim_pub_code_mapping_dict    as a2
        on a1.cd_val_desc = case when a2.cd_val_desc = '繁体畅读' then '繁体'
                                 when a2.cd_val_desc = '英文阅读' then '英语'
                                 else replace(a2.cd_val_desc, '阅读','')
                             end
       and a2.app_plat = 'pub'
       and a2.cd_col = 'product_id'
     where a1.app_plat = 'pub'
       and a1.cd_col = 'book_lang_cd'
)
select a1.dt
      ,a1.product_id
      ,a1.book_id
      ,a1.cost_types
      ,sum(a1.cost_amt)    as cost_amt
      ,now()               as etl_time
  from (select b1.dt
              ,coalesce(b2.product_id, -99)                                      as product_id
              ,b1.book_id
              ,1                                                                 as cost_types
              ,if(b1.currency_type = 1, b1.total_price, b1.total_price * 6.5)    as cost_amt
          from dwd.dwd_content_translate_remuneration    as b1
          left join product_lang_code_mapping            as b2
            on b1.to_language = b2.book_lang_cd
         where b1.dt >= date_sub('${bf_1_dt}', interval 60 day)
           and b1.dt <= '${bf_1_dt}'
           and b1.book_id > 0 
           and b1.remuneration_type = 1
           and b1.st != 3
       )                                                 as a1
 group by 1, 2, 3, 4
 union all
select a3.dt
      ,coalesce(a4.product_id, -99)                      as product_id
      ,a2.book_id
      ,2                                                 as cost_types
      ,sum(a3.authorsaleactual * a2.rate) / 100 * 6.5    as cost_amt
      ,now()                                             as etl_time
  from dim.dim_shuangwen_book_channel_income_config      as a2
  join (select b3.product_id    as product_id
              ,b3.dt            as dt
              ,b3.book_id       as book_id
              ,sum(case when b3.static_date <= '2021-10-19' then (b3.money_sale + b3.award_reward + b3.reward) / 6.6 / 2
                        when b3.static_date > '2021-10-19' then (b3.money_sale / 6.6 + b3.award_reward + b3.reward) / 2
                    end
                  )          as authorsaleactual
          from dwd.dwd_content_book_daily_sale_view      as b3
         where b3.dt = '${bf_1_dt}'
         group by 1, 2, 3
       )                                                 as a3
    on a2.book_id = a3.book_id
  left join product_lang_code_mapping                    as a4
    on a2.site_id = a4.book_lang_cd
 group by 1, 2, 3, 4
;