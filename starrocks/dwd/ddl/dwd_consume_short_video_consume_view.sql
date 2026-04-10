create or replace view dwd.dwd_consume_short_video_consume_view (
     dt                   comment "日期"
    ,id                   comment "主键"
    ,create_time          comment "创建时间"
    ,account_id           comment "账号id"
    ,coin                 comment "当前代币数"
    ,bonus                comment "当前赠币数"
    ,update_time          comment "更新时间"
    ,pre_bonus            comment "充值前赠币"
    ,pre_coin             comment "充值前代币"
    ,epis_id              comment "剧集id"
    ,epis_name            comment "剧集名称"
    ,epis_num             comment "集数"
    ,platform             comment "平台"
    ,gain_bonus           comment "获得的bonus"
    ,gain_coin            comment "获得的coin"
    ,bill_type            comment "充值类型"
    ,consume_type         comment "消费类型,0是代币,1是赠币"
    ,consume_type2        comment "消费类型(解锁方式),0是普通方式代币,1是普通方式赠币,2超前点播代币，3超前点播赠币"
    ,consume_value        comment "消费数量"
    ,region_id            comment "归属区域 id，1：香港，2：北美;"
    ,sr_createtime        comment "数仓入库时间"
    ,sr_updatetime        comment "数仓更新时间"
)
comment "海外短剧消耗表"
as
select a1.dt                                                                as dt                   -- 日期
      ,a1.Id                                                                as id                   -- 主键
      ,a1.CreateTime                                                        as create_time          -- 创建时间
      ,a1.AccountId                                                         as account_id           -- 账号id
      ,a1.Coin                                                              as coin                 -- 当前代币数
      ,a1.Bonus                                                             as bonus                -- 当前赠币数
      ,a1.UpdateTime                                                        as update_time          -- 更新时间
      ,a1.PreBonus                                                          as pre_bonus            -- 充值前赠币
      ,a1.PreCoin                                                           as pre_coin             -- 充值前代币
      ,a1.EpisId                                                            as epis_id              -- 剧集id
      ,a1.EpisName                                                          as epis_name            -- 剧集名称
      ,a1.EpisNum                                                           as epis_num             -- 集数
      ,a1.Platform                                                          as platform             -- 平台
      ,a1.GainBonus                                                         as gain_bonus           -- 获得的bonus
      ,a1.GainCoin                                                          as gain_coin            -- 获得的coin
      ,a1.BillType                                                          as bill_type            -- 充值类型
      ,0                                                                    as consume_type         -- 消费类型,0是代币,1是赠币
      ,a1.ConsumeType                                                       as consume_type2        -- 消费类型(解锁方式),0是普通方式代币,1是普通方式赠币,2超前点播代币，3超前点播赠币
      ,a1.PreCoin - a1.Coin                                                 as consume_value        -- 消费数量
      ,a1.regionId                                                          as region_id            -- 归属区域 id，1：香港，2：北美;
      ,a1.sr_createtime                                                     as sr_createtime        -- 数仓入库时间
      ,a1.sr_updatetime                                                     as sr_updatetime        -- 数仓更新时间
  from ods.ods_tidb_short_video_bill    as a1
 where a1.ConsumeType is not null
   and a1.ConsumeType != ''
   and a1.PreCoin - a1.Coin > 0
 union all
select a1.dt                                                                as dt                   -- 日期
      ,a1.Id                                                                as id                   -- 主键
      ,a1.CreateTime                                                        as create_time          -- 创建时间
      ,a1.AccountId                                                         as account_id           -- 账号id
      ,a1.Coin                                                              as coin                 -- 当前代币数
      ,a1.Bonus                                                             as bonus                -- 当前赠币数
      ,a1.UpdateTime                                                        as update_time          -- 更新时间
      ,a1.PreBonus                                                          as pre_bonus            -- 充值前赠币
      ,a1.PreCoin                                                           as pre_coin             -- 充值前代币
      ,a1.EpisId                                                            as epis_id              -- 剧集id
      ,a1.EpisName                                                          as epis_name            -- 剧集名称
      ,a1.EpisNum                                                           as epis_num             -- 集数
      ,a1.Platform                                                          as platform             -- 平台
      ,a1.GainBonus                                                         as gain_bonus           -- 获得的bonus
      ,a1.GainCoin                                                          as gain_coin            -- 获得的coin
      ,a1.BillType                                                          as bill_type            -- 充值类型
      ,1                                                                    as consume_type         -- 消费类型,0是代币,1是赠币
      ,a1.ConsumeType                                                       as consume_type2        -- 消费类型(解锁方式),0是普通方式代币,1是普通方式赠币,2超前点播代币，3超前点播赠币
      ,a1.PreBonus - a1.Bonus                                               as consume_value        -- 消费数量
      ,a1.regionId                                                          as region_id            -- 归属区域 id，1：香港，2：北美;
      ,a1.sr_createtime                                                     as sr_createtime        -- 数仓入库时间
      ,a1.sr_updatetime                                                     as sr_updatetime        -- 数仓更新时间
  from ods.ods_tidb_short_video_bill    as a1
 where a1.ConsumeType is not null
   and a1.ConsumeType != ''
   and a1.PreBonus - a1.Bonus > 0
;