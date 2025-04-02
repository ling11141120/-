insert overwrite dwd.dws_user_login_1d partition(p'${pname}')
select a.dt,a.productid,b.corever,b.CurrentLanguage,b.CurrentLanguage2,b.appver,b.mt,b.ver,b.regcountry,
       a.userid,b.createtime as regtime,datediff(date(a.createtime),date(b.createtime)),count(1) as loginTimes
from
dwd.dwd_user_log_appstartlog a
left join
dim.dim_user_accountinfo_df b
 on a.productid=b.productid and a.userid=b.userid
 where a.dt >='${today}' and a.dt<= date(date_add('${today}',interval 10 day ))
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
;

