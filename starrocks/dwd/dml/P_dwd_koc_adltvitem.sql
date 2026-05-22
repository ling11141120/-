----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_koc_adltvitem
-- workflow_version : 2
-- create_user      : hufengju
-- task_name        : dwd_koc_adltvitem
-- task_version     : 2
-- update_time      : 2025-02-22 17:09:32
-- sql_path         : \starrocks\tbl_dwd_koc_adltvitem\dwd_koc_adltvitem
----------------------------------------------------------------
-- SQL语句
insert into dwd.`dwd_koc_adltvitem`
	select
	Id as id,
	DateKey as date_key,
	ProductId as product_id,
	AdId as ad_id,
	MonthKey as month_key,
	DevNum as dev_num,
	NewDevNum as new_dev_num,
	ActiveDevNum as active_dev_num,
	Amount as amount,
	BaseAmount as base_amount,
	Income as income,
	RealDevNum as real_dev_num,
	RealIncome as real_income,
	Core as core,
	Mt as mt,
	SourceChl as source_chl,
	Chl as chl,
	CurrentLanguage as current_language,
	KocCode as koc_code,
	ProjectType as project_type,
	DataKey as data_key,
	DataId as data_id,
	InstitutionId as institution_id,
	InstitutionStatus as institution_status,
	InstitutionCreatorUid as institution_creator_uid,
	StarId as star_id,
	StarStatus as star_status,
	AppType as app_type,
	CooperationType as cooperation_type,
	SplitRatio as split_ratio,
	TransactionFeeType as transaction_fee_type,
	TransactionFee as transaction_fee,
	CostFactorType as cost_factor_type,
	CostFactor as cost_factor,
	CooperationBeginTime as cooperation_begin_time,
	CooperationEndTime as cooperation_end_time,
	CreateTime as create_time,
	UpdateTime as update_time,
	LeaderId as leader_id,
	DistribIncome as distrib_income,
	RealDistribIncome as real_distrib_income,
	DistributeType as distribute_type,
	DistributeRatio as distribute_ratio,
	LeaderStatus as leader_status,
	BusinessType as business_type,
	Exchange as exchange,
	NewRealDevNum as new_real_dev_num,
	ActiveRealDevNum as active_real_dev_num,
	NewAmount as new_amount,
	ActiveAmount as active_amount,
	NewBaseAmount as new_base_amount,
	ActiveBaseAmount as active_base_amount,
	NewIncome as new_income,
	ActiveIncome as active_income,
	NewRealIncome as new_real_income,
	ActiveRealIncome as active_real_income,
	NewDistribIncome as new_distrib_income,
	ActiveDistribIncome as active_distrib_income,
	NewRealDistribIncome as new_real_distrib_income,
	ActiveRealDistribIncome as active_real_distrib_income,
	now() as etl_tm
from ods.`ods_tidb_kocdb_koc_adltvitem`
where DateKey>='${bf_3_dt}';
