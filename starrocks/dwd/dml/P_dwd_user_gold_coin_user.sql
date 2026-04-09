----------------------------------------------------------------
-- 程序功能：用户域-金币网赚用户事实表
-- 程序名：P_dwd_user_gold_coin_user
-- 目标表：dwd.dwd_user_gold_coin_user
----------------------------------------------------------------

insert into dwd.dwd_user_gold_coin_user
select dt
     , AccountId     as user_id
     , IsGolden      as is_gold_coin_user
     , CreateTime    as create_time
     , now() as etl_time
from ods.ods_tidb_short_video_account_extra
where dt = '${bf_1_dt}'
qualify row_number() over (partition by AccountId order by Id desc) = 1
;
