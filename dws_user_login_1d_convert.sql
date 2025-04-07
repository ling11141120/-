/*
-- 作者: 胡凤举
-- 描述: 用户行为宽表
-- 调度周期: 每日3点 北京时间
-- 依赖表: ods.user_log, dim.user_info
*/
insert overwrite dwd.dws_user_login_1d partition(p'${pname}')
select a.dt,a.productid,b.corever,b.CurrentLanguage,b.CurrentLanguage2,b.appver,b.mt,b.ver,b.regcountry,
       a.userid,b.createtime as regtime,datediff(date(a.createtime),date(b.createtime)),count(1) as loginTimes
from
dwd.dwd_user_log_appstartlog a
left join
dim.dim_user_accountinfo_df b
 on a.productid=b.productid and a.userid=b.userid
 where a.dt >='${today}' and a.dt<= date(date_add('${today}',interval 100 day ))  /* 修改日期到10天 */
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
;

