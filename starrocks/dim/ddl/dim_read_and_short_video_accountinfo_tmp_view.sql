create view dim_read_and_short_video_accountinfo_tmp_view(
     productid
    ,id
    ,corever
    ,mt
    ,regcountry
    ,currentlanguage2
    ,createtime
    ,chl2
    ,chl
) as
select product_id
      ,id
      ,corever
      ,mt
      ,reg_country
      ,current_language2
      ,create_time
      ,chl2
      ,chl
  from dim.dim_user_account_info_view
 union all
select product_id
      ,user_id
      ,corever
      ,mt
      ,reg_country
      ,current_language2
      ,create_time
      ,chl2
      ,chl
  from dim.dim_short_video_user_accountinfo
 union all
select 6883                                       as product_id
      ,id as user_id
      ,corever2
      ,mt2
      ,reg_country
      ,current_language2
      ,create_time
      ,chl2
      ,null                                       as chl
  from dim.dim_video_cn_accountinfo_view;