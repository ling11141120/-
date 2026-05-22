----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_content_book_parentbook_relation
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dwm_content_book_parentbook_relation
-- task_version     : 3
-- update_time      : 2024-04-30 11:37:00
-- sql_path         : \starrocks\tbl_dwm_content_book_parentbook_relation\dwm_content_book_parentbook_relation
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwm.dwm_content_book_parentbook_relation
SELECT
        a.BookId*1000+dpt.book_langid AS book_id_language_id,
        a.ParentBookId*1000+dpt.book_langid AS parent_book_id,
        a.RootParentBookId*1000+dpt.book_langid AS root_parent_book_id,
        a.ProductId AS product_id,
        a.BookId AS book_id,
        dpt.book_langid AS book_language_id,
        a.LanguageId AS language_id,
        NOW() AS etl_time
FROM  `ods`.`ods_content_book_parent_book_relation` a
LEFT JOIN dim.DIM_ProductType dpt
ON  a.LanguageId = dpt.langid;
