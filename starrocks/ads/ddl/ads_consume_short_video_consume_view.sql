create or replace view ads.ads_consume_short_video_consume_view (
     dt            comment "日期"
    ,id            comment "主键"
    ,create_time   comment "创建时间"
    ,account_id    comment "账号id"
    ,coin          comment "当前代币数"
    ,bonus         comment "当前赠币数"
    ,update_time   comment "更新时间"
    ,pre_bonus     comment "充值前赠币"
    ,pre_coin      comment "充值前代币"
    ,epis_id       comment "剧集id"
    ,series_id     comment "剧id"
    ,epis_name     comment "剧集名称"
    ,epis_num      comment "集数"
    ,platform      comment "平台"
    ,gain_bonus    comment "获得的bonus"
    ,gain_coin     comment "获得的coin"
    ,bill_type     comment "充值类型"
    ,consume_type  comment "消费类型,0是代币,1是赠币"
    ,consume_type2 comment "消费类型(解锁方式),0是普通方式代币,1是普通方式赠币,2超前点播代币，3超前点播赠币"
    ,consume_value comment "消费数量"
    ,region_id     comment "归属区域 id，1：香港，2：北美;"
    ,corever2      comment "当前core"
)
comment "海外短剧消耗表"
as
select a.dt
     , a.Id
     , a.create_time
     , a.account_id
     , a.Coin
     , a.Bonus
     , a.update_time
     , a.pre_bonus
     , a.pre_coin
     , a.epis_id
     , b.series_id
     , a.epis_name
     , a.epis_num
     , a.Platform
     , a.gain_bonus
     , a.gain_coin
     , a.bill_type
     , a.consume_type
     , a.consume_type2
     , a.consume_value
     , a.region_id
     , c.corever2
  from (select a.dt
             , a.Id
             , a.CreateTime       as create_time
             , a.AccountId        as account_id
             , a.Coin
             , a.Bonus
             , a.UpdateTime       as update_time
             , a.PreBonus         as pre_bonus
             , a.PreCoin          as pre_coin
             , a.EpisId           as epis_id
             , a.EpisName         as epis_name
             , a.EpisNum          as epis_num
             , a.Platform
             , a.GainBonus        as gain_bonus
             , a.GainCoin         as gain_coin
             , a.BillType         as bill_type
             , 0                  as consume_type
             , a.ConsumeType      as consume_type2
             , a.PreCoin - a.Coin as consume_value
             , a.regionId         as region_id
          from ods.ods_tidb_short_video_bill as a
         where a.ConsumeType is not null
           and a.ConsumeType != ''
           and a.PreCoin - a.Coin > 0
         union all
        select a.dt                 as dt
             , a.Id                 as Id
             , a.CreateTime         as create_time
             , a.AccountId          as account_id
             , a.Coin               as Coin
             , a.Bonus              as Bonus
             , a.UpdateTime         as update_time
             , a.PreBonus           as pre_bonus
             , a.PreCoin            as pre_coin
             , a.EpisId             as epis_id
             , a.EpisName           as epis_name
             , a.EpisNum            as epis_num
             , a.Platform           as Platform
             , a.GainBonus          as gain_bonus
             , a.GainCoin           as gain_coin
             , a.BillType           as bill_type
             , 1                    as consume_type
             , a.ConsumeType        as consume_type2
             , a.PreBonus - a.Bonus as consume_value
             , a.regionId           as region_id
          from ods.ods_tidb_short_video_bill as a
         where a.ConsumeType is not null
           and a.ConsumeType != ''
           and a.PreBonus - a.Bonus > 0
        )                                        as a
  left join dim.dim_short_video_epis_view        as b
    on a.epis_id = b.epis_id
  left join dim.dim_short_video_user_accountinfo as c
    on a.account_id = c.user_id;