insert into dwd.dwd_sv_consume_user_consume_bill_pdi
with test_user as (
    select
        user_id
    from dwd.dwd_trade_short_video_payorder
    where test_flag = 1
    group by user_id
),
a as(
    select dt,Id,CreateTime AS create_time,AccountId AS account_id,Coin,Bonus,UpdateTime AS update_time, PreBonus AS pre_bonus,
           PreCoin AS pre_coin,EpisId AS epis_id,EpisName AS epis_name,EpisNum AS epis_num,Platform,GainBonus AS gain_bonus,
           GainCoin AS gain_coin,BillType AS bill_type,0 AS consume_type,ConsumeType AS consume_type2,
           PreCoin - Coin AS consume_value,regionId AS region_id
    from ods.ods_tidb_short_video_bill
    where dt>=date_sub('${dt}',interval 1 day ) and
          ConsumeType is not null and ConsumeType <>'' and ((PreCoin - Coin) > 0)
      and ConsumeType not in (8,9)
    union all
    select dt,Id,CreateTime AS create_time,AccountId AS account_id,Coin,Bonus,UpdateTime AS update_time,PreBonus AS pre_bonus,
           PreCoin AS pre_coin,EpisId AS epis_id,EpisName AS epis_name,EpisNum AS epis_num,Platform,GainBonus AS gain_bonus,
           GainCoin AS gain_coin,BillType AS bill_type,1 AS consume_type,ConsumeType AS consume_type2,
           PreBonus - Bonus AS consume_value,regionId AS region_id
    from ods.ods_tidb_short_video_bill
    where dt>=date_sub('${dt}',interval 1 day ) and
          ConsumeType is not null and ConsumeType <>'' and ((PreBonus - Bonus) > 0)
      and ConsumeType not in (8,9)
)
select t1.dt,
       t1.Id,
       t1.consume_type,
       t1.sereis_unlock_id,
       t1.create_time,
       t1.account_id,
       t1.Coin,
       t1.Bonus,
       t1.update_time,
       t1.pre_bonus,
       t1.pre_coin,
       c.series_id,
       t1.epis_id,
       t1.epis_ids,
       t1.epis_name,
       t1.epis_num,
       t1.Platform,
       t1.gain_bonus,
       t1.gain_coin,
       t1.bill_type,
       t1.consume_type2,
       t1.consume_value,
       t1.region_id,
       now() as etl_time
from(
    select a.dt,a.Id,a.consume_type,ifnull(b.id,-99) as sereis_unlock_id,a.create_time,a.account_id,a.Coin,a.Bonus,a.update_time,
           a.pre_bonus,a.pre_coin,ifnull(a.epis_id,b.EpisId) as epis_id,split(ifnull(a.epis_id,b.epis_ids),',') as epis_ids,
           a.epis_name,ifnull(a.epis_num,b.EpisNum) as epis_num,a.Platform,a.gain_bonus,a.gain_coin,a.bill_type,a.consume_type2,
           round(a.consume_value/count(1) over (partition by a.dt,a.Id,a.consume_type),6) as consume_value,
           a.region_id
    from a
    left join (
        select b1.id,b1.AccountId,b1.SeriesId,b1.EpisId,b1.EpisNum,b2.epis_ids,b1.BillId
        from ods.ods_tidb_short_video_series_unlock b1
        left join (-- 批量解锁章节
            select BillId,array_join(array_agg(EpisId),',') as epis_ids
            from ods.ods_tidb_short_video_series_unlock
            where CreateTime>=date_sub('${dt}',interval 2 day)
            group by BillId
            )b2 on b1.BillId=b2.BillId
        where CreateTime>=date_sub('${dt}',interval 2 day )
        )b on a.Id=b.BillId
    left join test_user t on a.account_id=t.user_id
    where t.user_id is null
)t1
left join dim.dim_short_video_epis_view c on t1.epis_id=c.epis_id;