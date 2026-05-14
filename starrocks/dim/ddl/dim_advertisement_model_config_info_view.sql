CREATE VIEW `dim_advertisement_model_config_info_view` (`model`) AS SELECT `ods`.`ods_shennong_sr_shennong_tb_rule_model`.`model`
FROM `ods`.`ods_shennong_sr_shennong_tb_rule_model`
GROUP BY 1;
utf8
utf8_general_ci