CREATE VIEW `day_consume_view` (`ad_name` COMMENT "广告名", `ad_id` COMMENT "广告id", `day_consume_amt` COMMENT "天消费（投放）") AS (SELECT `dwd`.`dwd_advertisement_video_cn_dailyinsightbyhour_view`.`ad_name`, `dwd`.`dwd_advertisement_video_cn_dailyinsightbyhour_view`.`ad_id`, sum(`dwd`.`dwd_advertisement_video_cn_dailyinsightbyhour_view`.`spend`) AS `day_consume_amt`
FROM `dwd`.`dwd_advertisement_video_cn_dailyinsightbyhour_view`
WHERE (`dwd`.`dwd_advertisement_video_cn_dailyinsightbyhour_view`.`spend` > 0) AND (`dwd`.`dwd_advertisement_video_cn_dailyinsightbyhour_view`.`dt` = (current_date()))
GROUP BY `dwd`.`dwd_advertisement_video_cn_dailyinsightbyhour_view`.`ad_name`, `dwd`.`dwd_advertisement_video_cn_dailyinsightbyhour_view`.`ad_id`);
