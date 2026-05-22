----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_market_puzzleactuserrecord
-- workflow_version : 1
-- create_user      : zhugl
-- task_name        : tbl_dwd_market_puzzleactuserrecord
-- task_version     : 1
-- update_time      : 2023-09-21 17:12:49
-- sql_path         : \starrocks\tbl_dwd_market_puzzleactuserrecord\tbl_dwd_market_puzzleactuserrecord
----------------------------------------------------------------
-- SQL语句
delete from dwd.dwd_market_puzzleactuserrecord where dt between '${bf_2_dt}' and '${bf_1_dt}';

-- SQL语句
insert into dwd.dwd_market_puzzleactuserrecord
select
a.dt,a.productid,a.Id,ActId,Pid,ImgId,`Type`,Token,ImgPreResult,ImgResult,ComleteStatus,RewardStatus,a.AddTime,UpdateTime,Power,
c.id,ActName,Rule,Positon,Status,PowerMax,ThirdMulTwoPower,ThirdMulThirdPower,ThirdMulFourPower,ThirdMulTwoTime,ThirdMulThirdTime,ThirdMulFourTime,RePowerTime,RePoweNum,RePowerJifen,RePoweNumByJifen,ReTimeByAdCount,ReTimeByAdTime,`Language`,c.AddTime,FourMulFourPower,FourMulFourTime,UnlockNum,PkJifen,PkTakePercent,AddTrophy,LessTrophy,PkCycle,
b.app_id_account,
b.mt,
b.is_has_charge,
b.corever,
b.current_language,
b.current_language2,
b.reg_country,
b.regdate,
b.prod_id,
b.device_guid,
b.app_ver,
b.ver,
b.ads_type,
b.ads_quality,
b.is_negative_user,
now()
from (select * from ods.ods_tidb_readernovel_tidb_xx_puzzleactuserrecord  where dt between '${bf_2_dt}' and '${bf_1_dt}') a
left join ods.ods_tidb_readernovel_tidb_xx_puzzleact c on a.ActId = c.id and a.productid= c.productid
left join
(
select
b.app_id app_id_account,
b.mt,
b.is_has_charge,
b.corever,
b.current_language,
b.current_language2,
b.reg_country,
b.create_tm_account as regdate,
b.prod_id,
b.device_guid,
b.app_ver,
b.ver,
b.ads_type,
b.ads_quality,
b.is_negative_user,
b.product_id,
b.user_id
from dim.dim_user_all_info b
)b on a.productid = b.product_id and a.pid = b.user_id ;
