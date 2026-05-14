CREATE VIEW `ads_date_quality_monitor_view` (`部署语言`, `数据类型`, `到达率`, `最后生成时间`, `最后到达时间`)
COMMENT "VIEW" AS SELECT `res`.`biz_class` AS `部署语言`, CASE WHEN (`res`.`date_tp` = 1) THEN '业务' ELSE '日志' END AS `数据类型`, concat(CAST((`res`.`recive_rate` * 100) AS DECIMAL64(10,0)), '%') AS `到达率`, date_format(`res`.`max_heartbeat_time`, '%d日%H:%i:%s') AS `最后生成时间`, date_format(`res`.`max_receive_time`, '%d日%H:%i:%s') AS `最后到达时间`
FROM (SELECT `dwd`.`dwd_data_quality_link_monitor`.`biz_class`, `dwd`.`dwd_data_quality_link_monitor`.`date_tp`, (count(1)) / (CASE WHEN (`dwd`.`dwd_data_quality_link_monitor`.`date_tp` = 1) THEN (((2 * 60) * 60) / 5) ELSE (((2 * 60) * 60) / 10) END) AS `recive_rate`, max(`dwd`.`dwd_data_quality_link_monitor`.`receive_time`) AS `max_receive_time`, max(`dwd`.`dwd_data_quality_link_monitor`.`heartbeat_time`) AS `max_heartbeat_time`
FROM `dwd`.`dwd_data_quality_link_monitor`
WHERE (`dwd`.`dwd_data_quality_link_monitor`.`kafka_tp` IN (1, 3)) AND (`dwd`.`dwd_data_quality_link_monitor`.`heartbeat_time` >= (from_unixtime((unix_timestamp(current_timestamp())) - ((2 * 60) * 60))))
GROUP BY 1, 2) `res`
WHERE `res`.`recive_rate` < 0.9 ORDER BY `res`.`recive_rate` DESC  LIMIT 200;