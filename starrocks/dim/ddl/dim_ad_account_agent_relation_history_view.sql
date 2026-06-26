create or replace view dim.dim_ad_account_agent_relation_history_view (
     id             comment "主键id"
    ,account_source comment "账号来源"
    ,account        comment "广告账号id"
    ,agent_id       comment "代理商id"
    ,begin_date     comment "生效开始日期，包含当天"
    ,begin_date_key comment "生效开始日期yyyy-mm-dd"
    ,end_date       comment "生效结束日期，包含当天"
    ,end_date_key   comment "生效结束日期yyyy-mm-dd"
    ,create_time    comment "创建时间"
    ,update_time    comment "更新时间"
    ,sr_createtime  comment "sr入库时间"
    ,sr_updatetime  comment "sr更新时间"
)
comment "广告账号代理商归属历史维度视图"
as
select a1.id            as id             -- 主键id
      ,a1.accountsource as account_source -- 账号来源
      ,a1.account       as account        -- 广告账号id
      ,a1.agentid       as agent_id       -- 代理商id
      ,a1.begindate     as begin_date     -- 生效开始日期，包含当天
      ,a1.begindatekey  as begin_date_key -- 生效开始日期yyyy-mm-dd
      ,a1.enddate       as end_date       -- 生效结束日期，包含当天
      ,a1.enddatekey    as end_date_key   -- 生效结束日期yyyy-mm-dd
      ,a1.createtime    as create_time    -- 创建时间
      ,a1.updatetime    as update_time    -- 更新时间
      ,a1.sr_createtime as sr_createtime  -- sr入库时间
      ,a1.sr_updatetime as sr_updatetime  -- sr更新时间
  from ods.ods_tidb_sharpengine_ads_global_adaccountagentrelationhistory as a1
;
