CREATE VIEW `ads_competitor_country_view` (`country_code` COMMENT "国家码", `country_name` COMMENT "国家名")
COMMENT "app国家码国家名视图" AS (SELECT `dim`.`dim_country_dic`.`code`, `dim`.`dim_country_dic`.`Country`
FROM `dim`.`dim_country_dic`);