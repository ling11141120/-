----------------------------------------------------------------
-- 程序功能： 公共码表
-- 程序名： P_dim_pub_code_mapping_dict
-- 目标表： dim.dim_pub_code_mapping_dict
-- 负责人： qhr
-- 开发日期： 2023-08-24
-- 备注： 更新（修改 / 新增）请联系qhr！！
----------------------------------------------------------------

insert into dim.dim_pub_code_mapping_dict
(app_plat,cd_col,cd_val,cd_col_desc,cd_val_desc,p_cd_col,p_cd_col_desc,p_cd_val,p_cd_desc)
values
 ('pub','biz_type_cd','1','业务类型编码','海阅',null,null,null,null)
,('pub','biz_type_cd','3','业务类型编码','国剧',null,null,null,null)
,('pub','biz_type_cd','2','业务类型编码','海剧',null,null,null,null)
,('beidou','biz_type_cd','1','业务类型编码','海阅',null,null,null,null)
,('beidou','biz_type_cd','2','业务类型编码','国剧',null,null,null,null)
,('beidou','biz_type_cd','3','业务类型编码','海剧',null,null,null,null)
,('beidou','product_id','3501','product_id','印尼语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3399','product_id','日语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3388','product_id','西语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3311','product_id','法语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3371','product_id','俄语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3322','product_id','葡语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3333','product_id','繁体阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3511','product_id','泰语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3366','product_id','英语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','8211','product_id',null,'biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','6773','product_id',null,'biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','6883','product_id','国剧','biz_type_cd','业务类型编码','2','国剧')
,('beidou','product_id','6833','product_id','海剧','biz_type_cd','业务类型编码','3','海剧')
,('beidou','product_id','3561','product_id','德语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3571','product_id','意大利语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3581','product_id','阿拉伯语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3591','product_id','印地语阅读','biz_type_cd','业务类型编码','1','海阅')
,('beidou','product_id','3521','product_id','越南语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3333','product_id','繁体阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3501','product_id','印尼语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3399','product_id','日语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3511','product_id','泰语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3311','product_id','法语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3322','product_id','葡语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3366','product_id','英语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3371','product_id','俄语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3388','product_id','西语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','8211','product_id',null,'biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','6773','product_id',null,'biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','6833','product_id','海剧','biz_type_cd','业务类型编码','2','海剧')
,('pub','product_id','6883','product_id','国剧','biz_type_cd','业务类型编码','3','国剧')
,('pub','product_id','3561','product_id','德语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3571','product_id','意大利语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3581','product_id','阿拉伯语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3591','product_id','印地语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','3521','product_id','越南语阅读','biz_type_cd','业务类型编码','1','海阅')
,('pub','product_id','7757','product_id','新安卓读书',null,null,null,null)    -- and2
,('pub','product_id','8858','product_id','新畅读读书',null,null,null,null)    -- cd2
,('pub','product_id','7777','product_id','安卓读书',null,null,null,null)      -- and
,('pub','product_id','8888','product_id','畅读书城',null,null,null,null)      -- cd
,('pub','lang_abbr','tl','语言缩写','菲律宾语',null,null,null,null)
,('pub','lang_abbr','ft','语言缩写','繁体',null,null,null,null)
,('pub','lang_abbr','en','语言缩写','英语',null,null,null,null)
,('pub','lang_abbr','sp','语言缩写','西语',null,null,null,null)
,('pub','lang_abbr','pt','语言缩写','葡语',null,null,null,null)
,('pub','lang_abbr','fr','语言缩写','法语',null,null,null,null)
,('pub','lang_abbr','ru','语言缩写','俄语',null,null,null,null)
,('pub','lang_abbr','jp','语言缩写','日语',null,null,null,null)
,('pub','lang_abbr','id','语言缩写','印尼语',null,null,null,null)
,('pub','lang_abbr','th','语言缩写','泰语',null,null,null,null)
,('pub','lang_abbr','kr','语言缩写','韩语',null,null,null,null)
,('pub','lang_abbr','de','语言缩写','德语',null,null,null,null)
,('pub','lang_abbr','it','语言缩写','意大利语',null,null,null,null)
,('pub','lang_abbr','ar','语言缩写','阿拉伯语',null,null,null,null)
,('pub','lang_abbr','hi','语言缩写','印地语',null,null,null,null)
,('pub','lang_abbr','bn','语言缩写','孟加拉语',null,null,null,null)
,('pub','lang_abbr','my','语言缩写','马来西亚语',null,null,null,null)
,('pub','lang_abbr','tr','语言缩写','土耳其语',null,null,null,null)
,('pub','lang_abbr','vi','语言缩写','越南语',null,null,null,null)
('pub','mt','1','移动终端','安卓',null,null,null,null)
('pub','mt','4','移动终端','IOS',null,null,null,null)
;