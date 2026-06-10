insert
	into
	alg.sample_repay_data_v3_online
select
	concat('nv', x0.userid) user_id,
	'repayfeatv4' cache_key,
	concat(coalesce(x0.regdays, 30), ',', x0.first_pay_money, ',', x1.pay_total, ',', x1.pay_max, ',', x1.pay_min, ',', cast(x1.pay_avg as int), ',', x1.pay_num, ',', coalesce(pay_times, 1), ',', coalesce(read_books, 0), ',', coalesce(read_chpts, 0), ',', coalesce(max_chpts, 0), ',', coalesce(con_chapter_num, 0), ',', coalesce(csum_total_amount, 0)) features
from
	(
	select
		userid,
		max(regdays) regdays,
		max(cast(Firstchargemoney as int)) first_pay_money,
		max(chargeitemcount) label
	from
		dws.dws_trade_user_shopitem_charge_ed
	where
		dt<'${dt}'
		and chargeitemcount>0
		and userid>0
	group by
		userid )x0
join(
	select
		userid,
		sum(chargeitemcount) pay_total,
		max(chargeitemcount) pay_max,
		min(chargeitemcount) pay_min,
		avg(chargeitemcount) pay_avg,
		sum(chargecount) pay_num
	from
		dws.dws_trade_user_shopitem_charge_ed
	where
		dt<'${dt}'
		and chargeitemcount>0
	group by
		userid )x1 on
	x0.userid = x1.userid
left join(
	select
		userid,
		chargeitemcount pay_times,
		sum(chargecount) num,
		row_number() over (partition by userid
	order by
		sum(chargecount) desc) pay_sort
	from
		dws.dws_trade_user_shopitem_charge_ed
	where
		dt<'${dt}'
		and chargeitemcount>0
	group by
		userid,
		chargeitemcount
)xall on
	x0.userid = xall.userid
	and xall.pay_sort = 1
left join(
	select
		dt,
		user_id,
		count(distinct book_id) read_books,
		sum(cast(read_chpts as int)) read_chpts,
		max(cast(read_chpts as int)) max_chpts,
		sum(con_chapter_num) con_chapter_num,
		sum(cast(csum_total_amount as int)) csum_total_amount
	from
		dws.dws_user_book_read_consume_info_ed
	where
		dt = '${dt}'
	group by
		dt,
		user_id )xr on
	x1.userid = xr.user_id;
