----------------------------------------------------------------
-- 程序功能：签约书籍ROI
-- 程序名： P_ads_bi_translation_roi
-- 目标表： ads.ads_bi_translation_roi
-- 负责人： xjc
-- 开发日期：
-- 版本号：v0.1.0
----------------------------------------------------------------

insert into ads.ads_bi_translation_roi
-- 获取图书维度信息
with a as (
    select book_id
          ,cd_val
          ,if ( book_code ='-99',null ,book_code )          as book_code
          --  if(book_id like '%090' or book_id like '%449',book_id,0)  as signed_book_id,                        -- 签约书籍
          ,p_cd_val                                         as language_id                                        -- 语言id
          ,cd_val_desc                                      as language_name                                      -- 语言名称
          ,book_name                                                                                              -- 书籍名称
      from dim.dim_shuangwen_book_read_consume_info         as a                                                  -- 不是主表
      left join dim.dim_pub_code_mapping_dict               as b
        on a.site_id2 = b.cd_val
     where b.cd_val is not null
       and a.book_name is not null
)
-- 求总收入,繁体 site_id2 = 333,其他语种 site_id2 != 333
,c as (
     select dt
           ,book_id
           ,sum(case when types = 1 and site_id =  333 then amount
                 end)
            / 100*7                                                         as trad_money_total_amount            -- 繁体书籍语种收入
           ,sum(case when types = 1 and site_id != 333 then amount
                 end)
            / 100*7                                                         as fore_money_total_amount            -- 外语书籍收入
       from dws.dws_consume_user_consume_ed                                 as a
       join dim.dim_pub_code_mapping_dict                                   as b
         on a.site_id = b.cd_val
        and b.app_plat='pub'
        and b.cd_col_desc='书籍语言编号'
      where dt >= date_sub('${bf_1_dt}'
                          , interval dayofmonth('${bf_1_dt}') + 10 day)
        and dt <= '${bf_1_dt}'
      group by 1,2
)
-- v4需求迭代： 作者稿酬/翻译成本   p系列（国内编辑）
,d as (
    select date(a.daily_time)                                               as dt
          ,a.book_id*1000+b.siteid                                          as book_id
          ,sum(case when a.reward_type=1002 then a.remuneration_money
                    else null
                end)                                                        as p_1002                  -- 新书续签奖励
          ,sum(case when a.reward_type=1003 then a.remuneration_money
                    else null
                end)                                                        as p_1003                  -- 完本奖
          ,sum(case when a.reward_type=1004 then a.remuneration_money
                    else null
                end)                                                        as p_1004                  -- 全勤奖励
          ,sum(case when a.reward_type=1005 then a.remuneration_money
                    else null
                end)                                                        as p_1005                  -- 衍生收益
          ,sum(case when a.reward_type=1007 then a.remuneration_money
                    else null
                end)                                                        as p_1007                  -- 翻译收入
          ,sum(case when a.reward_type=1008 then a.remuneration_money
                    else null
                end)                                                        as p_1008                  -- 千字稿酬
          ,sum(case when a.reward_type=1010 then  a.remuneration_money
                    else null
                end)                                                        as p_1010                  -- 三方收益
          ,sum(case when a.reward_type=1011 then  a.remuneration_money
                    else null
                end)                                                        as p_1011                  -- 签约奖励
          ,sum(case when a.reward_type=1012 then  a.remuneration_money
                    else null
                end)                                                        as p_1012                  -- 激励奖金包
          ,sum(case when a.reward_type=1013 then  a.remuneration_money
                    else null
                end)                                                        as p_1013                  -- 短篇收入
      from dwd.dwd_trade_exclusiverewardnew_view                            as a
      join dim.dim_zhangzhong_xzz_book_view                                 as b
        on a.book_id = (b.book_id-b.siteid)/1000
     where a.remuneration_status in (2 ,5)                                                             -- 2：系统自动通过 5：主编审核通过
       and a.is_banwithdrawl =0                                                                        -- 是否允许支付=是
       and date(a.daily_time) >= date_sub('${bf_1_dt}'
                                         , interval dayofmonth('${bf_1_dt}') + 10 day)                 -- 这块有很多时间,daily_time是实际稿酬发布时间;
       and date(a.daily_time) < '${dt}'
       and b.departmenttype=0                                                                          --  0内容编辑部 1凤鸣轩
     group by 1,2
)
-- 凤鸣轩成本统计
,e as (
-- v4需求迭代：凤鸣轩(a系列) 各类型稿酬支出 就是指成本
    select date(a.daily_time)                                                  as dt
          ,a.book_id*1000+b.siteid                                             as book_id
          ,0                                                                   as a_0000
          ,sum(case when a.reward_type=1002 then a.remuneration_money
                    else null
                end)                                                           as a_1002                -- 新书续签奖励
          ,sum(case when a.reward_type=1003 then a.remuneration_money
                    else null
                end)                                                           as a_1003                -- 完本奖
          ,sum(case when a.reward_type=1004 then a.remuneration_money
                    else null
                end)                                                           as a_1004                -- 全勤奖励
          ,sum(case when a.reward_type=1005 then a.remuneration_money
                    else null
                end)                                                           as a_1005                -- 衍生收益
          ,sum(case when a.reward_type=1007 then a.remuneration_money
                     else null
                end)                                                           as a_1007                -- 翻译收入
          ,sum(case when a.reward_type=1008 then a.remuneration_money
                    else null
                end)                                                           as a_1008                -- 千字稿酬
          ,sum(case when a.reward_type=1010 then  a.remuneration_money
                    else null
                end)                                                           as a_1010                -- 三方收益
          ,sum(case when a.reward_type=1011 then  a.remuneration_money
                    else null
                end)                                                           as a_1011                -- 签约奖励
          ,sum(case when a.reward_type=1012 then  a.remuneration_money
                    else null
                end)                                                           as a_1012                -- 激励奖金包
          ,sum(case when a.reward_type=1013 then  a.remuneration_money
                    else null
                end)                                                           as a_1013                -- 短篇收入
      from dwd.dwd_trade_exclusiverewardnew_view                               as a
      join dim.dim_zhangzhong_xzz_book_view                                    as b
        on a.book_id =(b.book_id-b.siteid)/1000
     where a.remuneration_status in (2 ,5)                                                              -- 2：系统自动通过 5：主编审核通过
       and a.is_banwithdrawl =0                                                                         -- 是否允许支付=是
       and date(a.daily_time) >= date_sub('${bf_1_dt}'
                                         , interval dayofmonth('${bf_1_dt}') + 10 day)                  -- 这块有很多时间,daily_time是实际稿酬发布时间;  
       and date(a.daily_time) < '${dt}'
       and a.daily_time>='2024-03-01'                                                                   -- 迁移到国内编辑的书从24年3月开始
       and b.departmenttype=1                                                                           -- 0内容编辑部 1 凤鸣轩
     group by 1,2
     union all
-- 凤鸣轩平台的既有的书 新增一个字段 例如 a_0000 表示之前的稿酬收入,粒度是每本书的稿酬  090
    select date(date_add
               (date_add
               (str_to_date
               (concat(a.static_date, '01')
               ,'%y%m%d')
               ,interval  1 month)
           ,interval -1 day))                                  as dt
           ,concat(a.book_id,'090')                            as book_id                                  -- a.static_date,   -- book_id and 月末时间 月末稿酬
           ,sum(a.amount)                                      as a_0000                                  -- 稿酬-每月
           ,0                                                  as a_1002
           ,0                                                  as a_1003
           ,0                                                  as a_1004
           ,0                                                  as a_1005
           ,0                                                  as a_1007
           ,0                                                  as a_1008
           ,0                                                  as a_1010
           ,0                                                  as a_1011
           ,0                                                  as a_1012
           ,0                                                  as a_1013
      from dwd.dwd_trade_shuangwenremuneration_view            as a
      join dwd.dwd_trade_shuangwenauthorincome_view            as b
        on a.author_id = b.author_id
       and a.static_date=b.static_date
       and b.status in (1,2)
       and b.pay_ment > 0
     where a.static_date = date_format(date_sub('${bf_1_dt}'
                                      , interval dayofmonth('${bf_1_dt}') day)
                                      , '%y%m')                                                         -- static_date>月末 就是他的时间是月末时间,按月末时间进行展示;  
     group by 1,2
)
-- 凤鸣轩预估成本
,fmx_estimate_cost as (
    select dt
          ,ifnull(font_length/1000*font_price,0)               as estimate_cost_day
          ,b.book_id*1000+90                                   as book_id
-- 花费
      from (select book_id
                  ,font_price
              from dwd.dwd_trade_fmx_book_view
             where font_price is not null
               and del_status =0
           ) a    -- fmx_book
     right join (select book_id
                       ,date(publish_time)                     as dt
                       ,sum(font_length)                       as font_length
                   from dwd.dwd_trade_fmx_chapter_view
                  where publish_time >date(date_sub('${bf_1_dt}'
                                          , interval dayofmonth('${bf_1_dt}') day ))                    -- 本月开始到今天
                    and publish_time <= '${bf_1_dt}'
                    and status =2
-- 排除掉迁移到新掌中的书
                    and book_id not in (select distinct bookid
                                          from ods.ods_mysql_zhangzhong_xzz_Chapter_090
                                       )
                  group by 1,2    -- 从本月到昨天
                  union all
-- 凤鸣轩的部分书迁移到新掌中的书
                 select bookid                                 as book_id
                       ,date(publishtime)                      as dt
                       ,sum(fontlength)                        as font_length  
                   from ods.ods_mysql_zhangzhong_xzz_Chapter_090
                  where publishtime >date(date_sub('${bf_1_dt}'
                                         , interval dayofmonth('${bf_1_dt}') day ))                     -- 本月开始到今天
                    and publishtime <= '${bf_1_dt}'
                    and status =2
                  group by 1,2
                ) b -- fmx_cha
        on a.book_id = b.book_id
)
-- 计算每日的发布字数
,f as (
    select date_sub(a.dt,interval 1 day)                       as dt
         -- 外语发布字数,暂定
          ,a.book_id
          ,a.cn_font_length - b.cn_font_length                 as cn_publish_length                     -- 每日中文发布字数
          ,a.proofread_length - b.proofread_length             as proofread_length                      -- 每日精修字数
          ,a.publish_length - b.publish_length                 as publish_length                        -- 每日外语发布字数
         -- 2025-10-27按照文档修改价格https://docs.changdu.vip/pages/viewpage.action?pageid=122464819
          ,case when a.site_id = 322 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 61.50                                                     -- 英语:翻译发布字数
                when a.site_id = 375 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 42.50                                                     -- 西班牙语
                when a.site_id = 410 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 50.50                                                     -- 法语
                when a.site_id = 409 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 47.50                                                     -- 葡萄牙语
                when a.site_id = 418 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 49.50                                                     -- 俄语
                when a.site_id = 414 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 52.50                                                     -- 印尼语
                when a.site_id = 433 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 52.50                                                     -- 泰国语
                when a.site_id = 436 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 26.50                                                     -- 韩语
                when a.site_id = 419 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 26.50                                                     -- 日语
                when a.site_id = 412 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 57.50                                                     -- 德语
                when a.site_id = 435 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 47.50                                                     -- 越南语
                when a.site_id = 497 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 49.25                                                     -- 土耳其语
                when a.site_id = 445 then ((a.proofread_length 
                                            - b.proofread_length)
                                            /1000) 
                                            * 50.50                                                     -- 菲律宾语
                else 0
            end                                                as translation_cost
      from ads.ads_report_book_capacity_rate_stat              as a
      left join ads.ads_report_book_capacity_rate_stat         as b
        on a.book_id = b.book_id
       and b.dt = a.dt - interval 1 day
     where a.dt >=date(date_sub('${bf_1_dt}'
                      , interval dayofmonth('${bf_1_dt}') + 9 day ))
       and a.dt<= '${dt}'
     union all
    select update_time
          ,book_id
          ,publish_length_cnt
          ,0                                                   as proofread_length
          ,0                                                   as publish_length
          ,0                                                   as translation_cost
      from dim.dim_fanti_length_updatetime_view
     where update_time >=date(date_sub('${bf_1_dt}'
                             , interval dayofmonth('${bf_1_dt}') + 9 day ))  
)
-- 2024-07-10 v4新增的-针对繁体书籍的 在国内编辑系统平台  稿酬表下的 三方收益总收入
,third_income as (
    select date(a.create_time)                                 as dt
          ,a.book_id*1000+b.siteid                             as book_id
          ,sum(if(a.reward_type=1010,a.book_salle,0))          as 1010_income_amt                       -- 三方收益总收入
          ,sum(if(a.reward_type=1013,a.book_salle,0))          as 1013_income_amt                       -- 短篇收入总收入
      from dwd.dwd_trade_exclusiverewardnew_view               as a
      join dim.dim_zhangzhong_xzz_book_view                    as b
        on a.book_id =(b.book_id-b.siteid)/1000
     where a.reward_type in (1010,1013)                                                                 -- reward_type=1010 三方收益
       and a.create_time >=date_sub('${bf_1_dt}'
                                   , interval dayofmonth('${bf_1_dt}') + 10 day)
       and date(a.create_time) <= '${bf_1_dt}'
     group by 1 ,2
)
-- 将所有表的数据合并获取最全的 book_id
,g as (
    select dt
          ,book_id
      from (select dt
                  ,book_id
              from c
             union
            select dt
                  ,book_id
              from d
             union
            select dt
                  ,book_id
              from e
             union
            select dt
                  ,book_id
              from f
             union
            select dt
                  ,book_id
              from third_income
           ) a
)
-- 获取所有书籍的book_code
,h as (
    select a.book_id
          ,source_book
          ,if(b.book_code=-99,null,b.book_code)                     as book_code
          ,b.book_name
-- 取book_code的
      from (   -- 场景1：签约书的“二次翻译书”（嵌套翻译：签约书→一级翻译书→二级翻译书）
               -- 特征：book_id由“一级翻译书的swbook_id + 二级语言”生成，与场景2不重叠
          select a.swbook_id*1000+a.to_language                     as book_id
                ,source_book
            from dim.dim_book_shuangwen_en_objectbook_info_view     as a
            join (select swbook_id
                        ,book_id                                    as source_book
                        ,to_language
                    from dim.dim_book_shuangwen_en_objectbook_info_view
                   where mod(book_id ,1000) in (449,90)
                     and object_book_type =0
                 )                                                  as b
              on a.book_id = b.swbook_id
           union
          -- 场景2：签约书的“一级翻译书”（直接翻译：签约书→翻译书）
          -- 特征：book_id由“签约书的swbook_id + 一级语言”生成，与场景1/3不重叠
          select swbook_id*1000+to_language     -- 翻译数据id
                ,book_id source_book            -- 原书id
            from dim.dim_book_shuangwen_en_objectbook_info_view
           where mod(book_id ,1000) in (449,90)
             and object_book_type =0
           union
          -- 场景3：签约书“未翻译”（仅自身存在）
          -- 特征：book_id就是签约书自身id（末三位449/90），与翻译书id格式不同
          select book_id,book_id source_book
            from dim.dim_book_shuangwen_en_objectbook_info_view
           where mod(book_id ,1000) in (449,90)
             and object_book_type =0
           )                                                        as a
      join dim.dim_shuangwen_book_read_consume_info                 as b
        on a.source_book  = b.book_id
     group by 1,2,3,4
)
select g.dt                                                         as dt                          -- 日期
      ,coalesce(g.book_id,a.book_id )                               as book_id                     -- 书籍id
      ,coalesce(h.book_code,a.book_code )                           as book_code                   -- 书籍代号
      ,a.cd_val                                                     as site_id                     -- 语种id
      ,a.language_name                                              as site_name                   -- 语种名称
      ,coalesce(h.book_name,a.book_name )                           as book_name                   -- 书名. (问题字段,注意是中文书名)  问题字段
      ,coalesce(h.source_book ,a.book_id )                          as source_book                 -- 源书籍id
      ,f.cn_publish_length                                          as cn_publish_length           -- 中文发布字数
      ,f.publish_length                                             as publish_length              -- 每日外语发布字数
      ,c.trad_money_total_amount                                    as trad_money_total_amount     -- 繁体总收入
      ,c.fore_money_total_amount                                    as fore_money_total_amount     -- 外语总收入
      ,book_info.is_full                                            as is_full                     -- p系列书籍连载状态，0：连载 1：完本
      ,f.translation_cost                                           as translation_cost            -- 翻译成本
      ,fmx_estimate_cost.estimate_cost_day                          as estimate_cost_day           -- 每日的预估成本
      ,i.cost_amt                                                   as cost_amt                    -- 成本金额
      ,if(e.book_id is not null ,'凤鸣轩稿酬已同步',null)             as fmx_flag 
-- 国内编辑部的------------
      ,ifnull(d.p_1002,0)                                           as p_1002                      -- p-新书续签奖励成本
      ,ifnull(d.p_1003,0)                                           as p_1003                      -- p-完本奖成本
      ,ifnull(d.p_1004,0)                                           as p_1004                      -- p-全勤奖励成本
      ,ifnull(d.p_1005,0)                                           as p_1005                      -- p-衍生收益成本
      ,ifnull(d.p_1007,0)                                           as p_1007                      -- p-翻译收入成本
      ,ifnull(d.p_1008,0)                                           as p_1008                      -- p-千字稿酬成本
      ,ifnull(d.p_1010,0)                                           as p_1010                      -- p-三方收益成本
      ,ifnull(d.p_1011,0)                                           as p_1011                      -- p-签约奖励成本
      ,ifnull(d.p_1012,0)                                           as p_1012                      -- p-激励奖金包成本
      ,ifnull(d.p_1013,0)                                           as p_1013                      -- p-短篇收入成本
-- 凤鸣轩的----------
      ,ifnull(e.a_0000,0)                                           as a_0000                      -- a-稿酬,在凤鸣轩平台的成本
      ,ifnull(e.a_1002,0)                                           as a_1002                      -- a-新书续签奖励,在国内编辑部的成本
      ,ifnull(e.a_1003,0)                                           as a_1003                      -- a-完本奖,在国内编辑部的成本
      ,ifnull(e.a_1004,0)                                           as a_1004                      -- a-全勤奖励,在国内编辑部的成本
      ,ifnull(e.a_1005,0)                                           as a_1005                      -- a-衍生收益,在国内编辑部的成本
      ,ifnull(e.a_1007,0)                                           as a_1007                      -- a-翻译收入,在国内编辑部的成本
      ,ifnull(e.a_1008,0)                                           as a_1008                      -- a-千字稿酬,在国内编辑部的成本
      ,ifnull(e.a_1010,0)                                           as a_1010                      -- a-三方收益,在国内编辑部的成本
      ,ifnull(e.a_1011,0)                                           as a_1011                      -- a-签约奖励,在国内编辑部的成本
      ,ifnull(e.a_1012,0)                                           as a_1012                      -- a-激励奖金包,在国内编辑部的成本
      ,ifnull(e.a_1013,0)                                           as a_1013                      -- a-短篇收入,在国内编辑部的成本
      ,ifnull(third_income.1010_income_amt,0)                       as 1010_income_amt             -- 三方收益
      ,ifnull(third_income.1013_income_amt,0)                       as 1013_income_amt             -- 短篇收入
      ,now()
  from g
  left join a 
    on g.book_id = a.book_id                                                                       -- 维表,书籍属性维度
  left join c 
    on g.book_id = c.book_id 
   and g.dt = c.dt                                                                                 -- 从已有表中计算繁体和西语总收入
  left join d 
    on g.book_id = d.book_id 
   and g.dt = d.dt                                                                                 -- p系列稿酬 掌中
  left join e 
    on g.book_id = e.book_id 
   and g.dt = e.dt                                                                                 -- a系列稿酬 凤鸣轩
  left join f 
    on g.book_id = f.book_id 
   and g.dt = f.dt                                                                                 -- p系列稿酬 掌中
  left join h 
    on g.book_id = h.book_id
  left join fmx_estimate_cost
    on g.book_id = fmx_estimate_cost.book_id
   and g.dt = fmx_estimate_cost.dt -- 凤鸣轩稿酬
-- 获取书的投放成本-----------------
  left join (select book_id
                   ,dt
                   ,sum(cost_amt)                                   as cost_amt
               from dws.dws_advertisement_book_cost_amt_cst_ed
              group by 1,2
            )                                                       as i
    on g.book_id = i.book_id
   and g.dt=i.dt
  left join dim.dim_shuangwen_book_read_consume_info book_info
    on g.book_id = book_info.book_id
  left join third_income
    on g.book_id = third_income.book_id
   and g.dt=third_income.dt
 where h.book_name is not null
    or mod(a.book_id,1000) in (449,90)
;