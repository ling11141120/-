-------------------------------------------------
-- 应用报表：阅读-策略效果报表/海阅预装分成报表
-------------------------------------------------

-- 设备信息
with device_info as(
select b.user_id
	,b.product_id
	,max_by(b.device,b.create_tm_account )  device
from (
	select *
	from (
		--有效设备
		select if(mt2=1,split_part(device,',',1),device) device
			,mt2
			,count(1) cnt
		from dim.dim_user_all_info
		where create_tm_account >'2023-01-01'  and mt2 in (1,4)
		group by 1,2
		limit 500000
	) x
	-- where cnt>50
) a
left join (
	select product_id
		,user_id
		,mt2
		,create_tm_account
		,if(mt2=1,split_part(device,',',1),device) device
	from dim.dim_user_all_info
	where mt2 in (1,4)
) b on a.mt2=b.mt2 and a.device=b.device
group by 1,2
),

t1 as(
SELECT
  t1.*,
  t3.user_id as D1_user_id,
  t2.country,
  case
  when t2.country in
  ('中国','文莱','柬埔寨','印度尼西亚','日本','朝鲜','韩国','老挝','马来西亚',
	'马绍尔群岛','密克罗尼西亚联邦','瑙鲁','新西兰','澳大利亚','帕劳',
	'巴布亚新几内亚','菲律宾','萨摩亚','新加坡','所罗门群岛','泰国',
	'东帝汶','汤加','图瓦卢','瓦努阿图','越南','蒙古') then '亚太地区'
  when t2.country in
  ('芬兰','瑞典','挪威','冰岛','丹麦','法罗群岛','英国',
	'法国','爱尔兰','荷兰','比利时','卢森堡','摩纳哥','德国',
	'奥地利','瑞士','波兰','捷克','匈牙利','斯洛伐克','列支敦士登',
	'爱沙尼亚 ','拉脱维亚 ',' 立陶宛','白俄罗斯','俄罗斯',
	'乌克兰','摩尔多瓦','西班牙','葡萄牙','安道尔','意大利',
	'希腊','马耳他','梵蒂冈','圣马力诺','斯洛文尼亚','克罗地亚',
	'阿尔巴尼亚','罗马尼亚','保加利亚','塞尔维亚','黑山','北马其顿',
	'波斯尼亚和黑塞哥维','直布罗陀') then '欧洲地区'
	when t2.country in
	('沙特阿拉伯','伊朗','伊拉克','科威特','阿联酋','阿曼',
	'卡塔尔','巴林','土耳其','以色列','巴勒斯坦',
	'叙利亚','黎巴嫩','约旦','也门','塞浦路斯','格鲁吉亚',
	'亚美尼亚','阿塞拜疆','埃及','利比亚','突尼斯',
	'阿尔及利亚','摩洛哥','马德拉群岛','亚速尔群岛和西撒哈拉',
	'埃塞俄比亚','安哥拉','坦桑尼亚','塞内加尔','刚果(金)','肯尼亚','南非','尼日利亚','乌干达','冈比亚') then '中东地区'
	when t2.country in
	('墨西哥','危地马拉','洪都拉斯','萨尔瓦多','尼加拉瓜',
	'哥斯达黎加','巴拿马','古巴','海地','多米尼加',
	'牙买加','特立尼达和多巴哥','巴巴多斯','格林纳达',
	'多米尼加联邦','圣卢西亚','圣文森特和格林纳丁斯','巴哈马',
	'圭亚那','法属圭亚那','苏里南','委内瑞拉','哥伦比亚',
	'巴西','厄瓜多尔','秘鲁','玻利维亚','智利','阿根廷',
	'乌拉圭','巴拉圭') then '拉美地区'
	else '未知地区' end country_area,
	device
from
ads.ads_sr_bi_yz_user_info  t1
left join
dim.dim_country_dic t2
on t1.reg_country = t2.code
left join device_info
on t1.user_id=device_info.user_id and t1.product_id=device_info.product_id
left join  (
select
  t1.user_id,
  t1.dt,
  count(DISTINCT if(date_add(t1.dt,2) = t2.dt,1,null)) AS DN
  from dws.dws_user_wide_active_period_ed t1
  left join dws.dws_user_wide_active_period_ed t2
  on t1.user_id = t2.user_id
  and t2.period_type = 'ctt'
  and t2.user_type='D1-D7'
  and t2.dt >= t1.dt
  and t2.dt >= '${开始时间}'
  where t1.dt >= '${开始时间}'
  and t1.user_type  = 'D0'
  and  t1.period_type = 'ctt'
group by 1,2
) t3
on t1.user_id = t3.user_id
and DN = 1
where
	t1.dt >= ('${开始时间}')
	and t1.dt <= ('${结束时间}')
)


select
t1.dt `日期`,
country_area `地区`,
country `国家`,
device `手机型号`,

count(distinct t1.user_id) `总激活用户数`,
count(distinct t1.D1_user_id) `留存用户数`,
count(distinct t2.user_id) `激活24内观看用户数`,
case
when country_area='拉美地区' then count(distinct t2.user_id )  *0.2
when country_area='欧洲地区' then count(distinct t2.user_id )  *1.5
when country_area in('中东地区','亚太地区') then count(distinct t2.user_id)  *1
end `收入`,
case
when country_area='拉美地区' then count(distinct if(D1_user_id is not null , t2.user_id,null) )  *0.2
when country_area='欧洲地区' then count(distinct if(D1_user_id is not null , t2.user_id,null) )  *1.5
when country_area in('中东地区','亚太地区') then count(distinct  if(D1_user_id is not null , t2.user_id,null))  *1
end `收入（留存）`
-- ifnull(count(distinct case when country_area='拉美地区' then user_id end ),0) `拉美地区激活用户数`,
-- ifnull(count(distinct case when country_area='欧洲地区' then user_id end ),0) `欧洲地区激活用户数`,
-- ifnull(count(distinct case when country_area='中东地区' then user_id end ),0) `中东地区激活用户数`,
-- ifnull(count(distinct case when country_area='亚太地区' then user_id end ),0) `亚太地区激活用户数`,
-- ifnull(count(distinct case when country_area='拉美地区' then user_id end ),0)*0.2 `拉美地区分成收入`,
-- ifnull(count(distinct case when country_area='欧洲地区' then user_id end ),0)*1.5 `欧洲地区分成收入`,
-- ifnull(count(distinct case when country_area='中东地区' then user_id end ),0) *1 `中东地区分成收入`,
-- ifnull(count(distinct case when country_area='亚太地区' then user_id end ),0)*1 `亚太地区分成收入`
from t1
left join (
select user_id,dt,count(DISTINCT chapter_id) read_n from  dwd.dwd_read_user_chapter_view t2
GROUP  by 1,2) t2
on t1.user_id = t2.user_id and t1.dt = t2.dt
and read_n > 0
and t2.dt >= '${开始时间}'
group by 1,2,3,4