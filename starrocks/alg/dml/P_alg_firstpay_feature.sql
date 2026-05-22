----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_reco_firstpay
-- workflow_version : 21
-- create_user      : admin
-- task_name        : alg_firstpay_feature
-- task_version     : 8
-- update_time      : 2023-11-22 16:02:02
-- sql_path         : \starrocks\tbl_alg_reco_firstpay\alg_firstpay_feature
----------------------------------------------------------------
-- 前置SQL语句
truncate table alg.alg_firstpay_feature;

-- SQL语句
insert into alg.alg_firstpay_feature
select
'sex' feature_name,
sex as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      sex,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by sex order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by sex,pay_amt
) res
group by sex
union all
select
'emailsuffix' feature_name,
emailsuffix as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      emailsuffix,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by emailsuffix order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by emailsuffix,pay_amt
) res
group by emailsuffix
union all
select
'regcountry' feature_name,
regcountry as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      regcountry,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by regcountry order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by regcountry,pay_amt
) res
group by regcountry
union all
select
'mt' feature_name,
mt as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      mt,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by mt order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by mt,pay_amt
) res
group by mt
union all
select
'productid' feature_name,
productid as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      productid,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by productid order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by productid,pay_amt
) res
group by productid
union all
select
'corever' feature_name,
corever as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      corever,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by corever order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by corever,pay_amt
) res
group by corever
union all
select
'chl' feature_name,
chl as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      chl,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by chl order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by chl,pay_amt
) res
group by chl
union all
select
'chl2' feature_name,
chl2 as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      chl2,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by chl2 order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by chl2,pay_amt
) res
group by chl2
union all
select
'bookid' feature_name,
bookid as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      bookid,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by bookid order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by bookid,pay_amt
) res
group by bookid
union all
select
'adstype' feature_name,
adstype as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      adstype,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by adstype order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by adstype,pay_amt
) res
group by adstype
union all
select
'adsquality' feature_name,
adsquality as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      adsquality,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by adsquality order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by adsquality,pay_amt
) res
group by adsquality
union all
select
'device' feature_name,
device as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      device,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by device order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by device,pay_amt
) res
group by device
union all
select
'sysreleasever' feature_name,
sysreleasever as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      sysreleasever,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by sysreleasever order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by sysreleasever,pay_amt
) res
group by sysreleasever
union all
select
'ram' feature_name,
ram as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      ram,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by ram order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by ram,pay_amt
) res
group by ram
union all
select
'brand' feature_name,
brand as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      brand,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by brand order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by brand,pay_amt
) res
group by brand
union all
select
'currentlanguage' feature_name,
currentlanguage as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      currentlanguage,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by currentlanguage order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by currentlanguage,pay_amt
) res
group by currentlanguage
union all
select
'currentlanguage2' feature_name,
currentlanguage2 as feature_value,
sum(pay_amt*pay_num) pay_total,
max(pay_amt) pay_max,
min(pay_amt) pay_min,
sum(pay_amt*pay_num)/sum(pay_num) pay_avg,
max(select_max) select_max,
CURRENT_TIMESTAMP() etl_tm
from
(
    select
      currentlanguage2,
      pay_amt,
      sum(pay_num) pay_num,
      FIRST_VALUE(pay_amt) over(partition by currentlanguage2 order by sum(pay_num) desc) select_max
    from alg.alg_firstpay_feature_tmp
    group by currentlanguage2,pay_amt
) res
group by currentlanguage2;
