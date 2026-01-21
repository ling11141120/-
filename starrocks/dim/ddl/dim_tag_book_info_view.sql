create view `dim_tag_book_info_view`
            (`id` comment "天分区", `product_id` comment "产品id", `book_id` comment "书籍id",
             `tag_id` comment "tag_id", `creator` comment "创建人", `creation_time` comment "创建时间",
             `is_delete` comment "是否删除", `row_version` comment "版本")
            comment "书籍标签tag表"
as
select `ods`.`ods_tidb_readernovel_xx_tag_book_info`.`Id`
     , `ods`.`ods_tidb_readernovel_xx_tag_book_info`.`productId`    as `product_id`
     , `ods`.`ods_tidb_readernovel_xx_tag_book_info`.`BookId`       as `book_id`
     , `ods`.`ods_tidb_readernovel_xx_tag_book_info`.`TagId`        as `tag_id`
     , `ods`.`ods_tidb_readernovel_xx_tag_book_info`.`Creator`
     , `ods`.`ods_tidb_readernovel_xx_tag_book_info`.`CreationTime` as `creation_time`
     , `ods`.`ods_tidb_readernovel_xx_tag_book_info`.`IsDelete`     as `is_delete`
     , `ods`.`ods_tidb_readernovel_xx_tag_book_info`.`RowVersion`   as `row_version`
  from `ods`.`ods_tidb_readernovel_xx_tag_book_info`;