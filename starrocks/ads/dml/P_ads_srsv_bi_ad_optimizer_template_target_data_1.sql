----------------------------------------------------------------
-- 程序功能： 模板维度基建上限前置表-底表一-临时
-- 程序名： P_ads_srsv_bi_ad_optimizer_template_target_data_1
-- 目标表： ads.ads_srsv_bi_ad_optimizer_template_target_data_1
-- 负责人： qhr
-- 开发日期： 2025-08-19
----------------------------------------------------------------

insert into ads.ads_srsv_bi_ad_optimizer_template_target_data_1
--  关联预设参数
with z6 as (
    select t1.*
          ,t2.lang
          ,power(t2.lang_rate ,0.9)                                                             as lang_rate
          ,t2.group_spend
          ,t2.sunday_rate
          ,t2.friday_rate
          ,t2.base_rate
          ,t3.new_std
          ,t3.old_std
          ,t3.log_num
          ,t3.log_num_median
          ,t3.exp_a
          ,t3.new_r0_rate
          ,t3.non_compliance_exp
          ,t3.spend_exp
          ,case when t1.weekdays = 7 then t2.sunday_rate
                when t1.weekdays = 5 then t2.friday_rate
                else 1
            end                                                                                 as weekdays_p
          ,power(if(regnum_all_7d = 0,ifnull(new_amt_rate,0),regnum_new_7d/regnum_all_7d),2)    as newamt_rate
          ,coalesce(d0_amt_pow/std_amt_pow,0)                                                   as R0_new
          ,coalesce(d0_amt_pow_old/std_amt_pow_old,0)                                           as R0_old
          ,ifnull(t1.d0_amt/t3.new_std/t1.std_amt,0)                                            as R0_bf1
          ,ifnull(t1.old_d0_amt/t3.old_std/t1.old_std_amt,0)                                    as old_R0_bf1
    from ads.ads_srsv_bi_ad_optimizer_template_target_data_pre_1    as t1
    left join dim.dim_srsv_ad_prduct_lang_rate                      as t2    -- 预设参数组1
      on t1.product=t2.product
     and t1.languageid=t2.lang_id
    left join dim.dim_srsv_ad_prduct_source_rate                    as t3    -- 预设参数组2
      on t1.product=t3.product
     and t1.source2=t3.source_plaform
)

-- 平均新组花费
, z7 as (
    select *
          ,ifnull( sum(spend)     over(partition by concat(project_code,source2,day_type,languageid) order by dt asc rows between 14 preceding and current row)
                  /sum(adset_num) over(partition by concat(project_code,source2,day_type,languageid) order by dt asc rows between 14 preceding and current row)
                 ,50
                 )                               as spend_avg
    from (select project_code
                ,source2
                ,dt
                ,if(weekdays<6,'work','week')    as day_type
                ,languageid
                ,sum(spend)                      as spend
                ,sum(adset_num)                  as adset_num
            from z6
           where adset_num is not null
           group by 1,2,3,4,5
         )                                       as x
)

-- 计算逻辑1，测算倍数，老组预算，平均花费
, z6_1 as (
    select *
          ,power(case when growth_base<1  and R0_bf1 < 1  then greatest(growth_base,R0_bf1)
                      when growth_base>=1 and R0_bf1 >= 1 then least(growth_base, R0_bf1)
                      else least(1,(growth_base+R0_bf1)/2)
                  end
                 ,if((case when growth_base<1  and R0_bf1<1  then greatest(growth_base,R0_bf1)
                           when growth_base>=1 and R0_bf1>=1 then least(growth_base, R0_bf1)
                           else least(1,(growth_base+R0_bf1)/2)
                       end
                     ) > 1
                    ,growth_exp
                    ,non_compliance_exp
                    )
                )            as growth_rate
      from (select *
                  ,case when R0_old>1 or R0_old<0.1 then (R0_new/new_std)
                        else (R0_new/new_std*new_r0_rate + R0_old/old_std*(1-new_r0_rate))
                    end         as growth_base
                  ,greatest(ifnull(  log(log_num,10)
                                   + log(log_num,adset_num)
                                   + exp_a
                                   + lang_rate
                                   + newamt_rate
                                   ,1
                                  )
                            ,0.7
                           )    as growth_exp
                  ,greatest(ifnull(power( (spend/adset_num)
                                         /(spend_10d/adset_num_10d)
                                         ,spend_exp
                                        )
                                   ,1
                                  )
                            ,1
                           )    as  spend_rate
              from z6
           )                    as x
) 
-- 计划1
, z8 as (
    select *
        ,case when plan_1<1 then round(plan_1)
              else ceiling(plan_1)
          end    as adsetnum_1
    from (select *
                --   ,adset_num*case when growth_rate>=1 and spendavg_rate>=1 then greatest(1,least(growth_mea,growth_oldspend,4))
                    --   when growth_rate>=1 and spendavg_rate<1 then greatest(1,least(growth_mea,growth_oldspend,spendavg_rate*1.5,4))
                    --   else least(growth_mea,spendavg_rate*1.5) end
                    --   as plan_1
                --   ,adset_num*case when growth_rate>=1 and spendavg_rate>=1 then least(growth_mea,4)
                    --   when growth_rate>=1 and spendavg_rate<1 then greatest(1,least(growth_mea,spendavg_rate*1.5,4))
                    --   else least(growth_mea,spendavg_rate*1.5) end
                    --   as plan_2
                  , weekdays_p
                   *adset_num
                   *case when growth_rate>=1 and spendavg_rate>=1 and growth_oldspend>=1 then greatest(1,least(growth_mea,growth_oldspend,4))
                         when growth_rate>=1 and spendavg_rate>=1 and growth_oldspend<1 then least(pow(growth_mea,growth_oldspend),4)
                         when growth_rate>=1 and spendavg_rate<1 and growth_oldspend>=1 then greatest(1,least(growth_mea,spendavg_rate*1.5,4))
                         when growth_rate>=1 and spendavg_rate<1 and growth_oldspend<1 then greatest(1,least(pow(growth_mea,growth_oldspend),spendavg_rate*1.5,4))
                         else least(growth_mea,spendavg_rate*1.5)
                     end    as plan_1
            from (select  *
                         -- 测算倍数
                         ,spend_rate*growth_rate as growth_mea
                         -- 老组预算控制基建上限
                         ,ifnull(old_spend,0)/spend_avg*if(growth_rate>1.5,1.5,growth_rate)/if(source2='meta',1,0.5)/adset_num as growth_oldspend
                         -- 平均花费/大盘
                         ,spend/adset_num/spend_avg as spendavg_rate
                    from (select a.*
                                ,b.spend_avg
                            from z6_1       as a
                            -- 获取新组平均花费
                            left join z7    as b
                              on a.project_code=b.project_code
                             and a.source2=b.source2
                             and a.dt=b.dt
                             and a.languageid=b.languageid
                         )                 as x
                 )                         as xx
         )                                 as xxx
)

-- 计算逻辑2，淘汰和老组保底，基建上限受达标率和老组花费    
, z6_2 as (
    select *
          ,case when (adsetnum_2=0 or has_plan<>1)  and old_spend>500  and old_R0_bf1>=1 then greatest(1,adsetnum_2)   -- 老组达标率高，保底1
                when has_plan<>1 and adsetnum_2<=1 then 0
                else greatest(1,adsetnum_2)
            end  as  adsetnum_plan
    from (select *
                ,ifnull(case when code_stage=1  then least(if(weekdays in (5,6),4,2),adsetnum_1)
                             when (code_stage = 2 and product = '海阅') then least(if(weekdays in (5,6),6,4),adsetnum_1)
                             else adsetnum_1
                         end
                        ,0
                       )    as  adsetnum_2
                ,case when off_begindate is not null and ifnull(growth_base,0)<0.8 then 0
                      when adset_num is null then 0
                      else 1
                  end       as has_plan
            from z8
         )                  as x
)

-- 未基建成功保留前日基建
select date(hours_add('2025-08-19',-13))    as dt
      ,book_id
      ,template_id
      ,source2
      ,project_code
      ,core
      --  非主键字
      ,product
      ,days
      ,weekdays
      ,book_code
      ,languageid
      ,current_language2
      ,template_name
      ,adset_num
      ,spend
      ,d0_amt
      ,std_amt
      ,reg_num
      ,reg_num_all
      ,reg_num_new
      ,new_amt_rate
      ,old_spend
      ,old_d0_amt
      ,old_std_amt
      ,days_book
      ,regnum_new_7d
      ,regnum_all_7d
      ,spend_10d
      ,adset_num_10d
      ,days_10d
      ,d0_amt_10d
      ,std_amt_10d
      ,d0_amt_all
      ,std_amt_all
      ,d0_amt_pow
      ,std_amt_pow
      ,d0_amt_pow_old
      ,std_amt_pow_old
      ,d0_amt_af
      ,std_amt_af
      ,code_stage
      ,code_lv
      ,test_status
      ,begin_date
      ,end_date
      ,off_begindate
      ,off_enddate
      ,lang
      ,lang_rate
      ,group_spend
      ,sunday_rate
      ,friday_rate
      ,base_rate
      ,new_std
      ,old_std
      ,log_num
      ,log_num_median
      ,exp_a
      ,new_r0_rate
      ,non_compliance_exp
      ,spend_exp
      ,weekdays_p
      ,newamt_rate
      ,R0_new
      ,R0_old
      ,R0_bf1
      ,old_R0_bf1
      ,growth_base
      ,growth_exp
      ,spend_rate
      ,growth_rate
      ,adsetnum_1
      ,adsetnum_2
      ,has_plan
      ,case when dt=date(hours_add('2025-08-19',-13)) then adsetnum_plan
           -- when code_stage<if(project_code='海剧',2,3) and days_diff('2025-08-19',end_date)>1 then 0   --测试期，测试结束时间无计划  
            else ceiling(adsetnum_plan*0.6)
        end     as adsetnum_plan
      ,opt_eid              -- 优化师工号
      ,opt_name             -- 优化师姓名
      ,auto_ce_type_cd      -- 自动创编类型编码
      ,auto_ce_type_name    -- 自动创编类型名称
      ,is_fst_infra         -- 是否首日基建
      ,init_infra_num       -- 初始基建条数
      ,is_new_group_ce      -- 是否有创编新组
      ,spend1               -- 新组+老组指标
      ,d0_amt1              -- 新组+老组指标
      ,std_amt1             -- 新组+老组指标
      ,d0_amt_pow1          -- 新组+老组指标
      ,std_amt_pow1         -- 新组+老组指标
      ,'2025-08-19'    as etl_time
  from (select *
              ,row_number() over(partition by book_id,template_id,source2,project_code order by dt desc)    as rn
          from z6_2
         where days_diff(hours_add('2025-08-19',-13),dt)<=7
           and dt<=hours_add('2025-08-19',-13)
       )    as x
 where rn=1
   and (    test_status=1
         or (    test_status>1 
             and days_diff(hours_add('2025-08-19',-13),dt)<=1
            )
       )
   and !(    adsetnum_plan=0
         and days_diff(hours_add('2025-08-19',-13),dt)>=1
        )
;