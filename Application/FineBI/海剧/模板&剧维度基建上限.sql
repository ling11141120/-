-------------------------------------------------
-- 应用报表：海剧-短剧维度报表/海剧-模板&剧维度基建上限
-------------------------------------------------

select product                                                      as `项目`
     , source2                                                      as `媒体`
     , book_id
     , current_language2
     , book_code
     , template_id
     , template_name
     , concat('【', current_language2, '-', book_code, '】', book_id) as `书籍ID`
     , concat(template_name, '【', template_id, '】')                 as `模板`
     , opt_name                                                      as `优化师`
     , auto_ce_type_name                                             as `自动创编类型`
     , case when product = '海剧' and code_stage = 1 then 'a'
            when product = '海阅' and code_stage in (1, 2) then 'a'
            when product = '海剧' and code_stage = 2 then 'b'
            when product = '海阅' and code_stage = 3 then 'b'
        end                                                         as stage
     , sum(is_fst_infra)                                            as `是否首日基建`
     , sum(init_infra_num)                                          as `初始基建条数`
     , sum(is_new_group_ce)                                         as `是否有创编新组`
     , sum(adset_num)                                               as `当日基建`
     , sum(spend)                                                   as `当日新组花费`
     , sum(spend1)                                                  as `当日花费`
     , sum(adsetnum_plan)                                           as `次日基建上限-0`
     , sum(d0_amt_pow)                                              as d0_amt_pow
     , sum(std_amt_pow)                                             as std_amt_pow
     , sum(d0_amt)                                                  as d0_amt
     , sum(std_amt)                                                 as std_amt
     , sum(d0_amt_pow1)                                             as d0_amt_pow1
     , sum(std_amt_pow1)                                            as std_amt_pow1
     , sum(d0_amt1)                                                 as d0_amt1
     , sum(std_amt1)                                                as std_amt1
     , sum(d0_amt) / sum(std_amt)                                   as `当日新组达标率`
     , sum(d0_amt1) / sum(std_amt1)                                 as `当日达标率`
     , sum(d0_amt_pow) / sum(std_amt_pow)                           as `3日新组聚合达标率`
     , sum(d0_amt_pow1) / sum(std_amt_pow1)                         as `3日聚合达标率`
  from ads.ads_srsv_bi_ad_optimizer_template_target_data_1              a
  left join ods.ods_tidb_sharpengine_ads_global_AdsCreationTemplateItem b
    on a.template_id = b.TemplateId
 where dt = '${日期}'
       ${if(len(广告组别) == 0,"","and b.AdGroupName in ('" + 广告组别 + "')")}
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12