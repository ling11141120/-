insert into  dws.dws_user_market_channel_info_detail_td  
select 
       '${dt}' as dt ,
       Product_Id,user_id,
       if(mt is null,0,mt) as mt ,
       if(corever is null,0,corever) as corever, 
       if(lang2 is null,0,lang2 ) as lang2, 
       max(case when rank_1=1 then first_bookid end) as first_bookid,
       max(case when rank_2=1 then last_bookid end) as last_bookid,
       max(case when rank_2=1 then last_source end) as last_source,
       max(case when rank_2=1 then isremarket end) as isremarket,    
       max(case when rank_2=1 then install_date end) as install_date,
       now() as updatetime  
from (
select  Product_Id,user_id,mt,corever,lang2 ,first_bookid,last_bookid,last_source,isremarket, install_date,
        row_number() over(partition by  Product_Id,user_id,mt,corever,lang2  order by install_date ) as rank_1,
        row_number() over(partition by  Product_Id,user_id,mt,corever,lang2  order by install_date desc) as rank_2

from (  -- -------------------------------------------------------------------
select Product_Id,user_id,mt,corever,lang2 ,first_bookid,last_bookid,last_source,isremarket, install_date
from dws.dws_user_market_channel_info_detail_td  -- ---------------------
where dt ='${bf_1_dt}' 
and product_id !=6883
and concat(Product_Id,user_id,mt,corever,lang2) in 
(
SELECT concat(product_id,user_id,mt,core,current_language2) -- -------------------------
from dwd.dwd_user_install_info_ed_view
where  dt>='${dt}'and install_date<date_add(now(),interval -10 minute)   and user_id<>-1 and isdelete=0   and product_id !=6883
)
union all -- ---------------------------------------------------------
SELECT   product_id ,  user_id,mt,core as corever,current_language2 as lang2,book_id,book_id,source,Is_Remarketing as isremarket,  install_date
from dwd.dwd_user_install_info_ed_view
where  dt>='${dt}'and install_date<date_add(now(),interval -10 minute)   and user_id<>-1 and isdelete=0  and product_id !=6883
) x 
-- where Product_Id =3333 and user_id  =115268775  and mt=1 and corever=1 and lang2   =2 
) y where rank_1=1 or rank_2=1 
group by 1,2,3,4,5,6  
union all 
-- ------------------  --------------------------------
select  '${dt}' as dt ,Product_Id,user_id,mt,corever,lang2 ,first_bookid,last_bookid,last_source,isremarket, install_date,updatetime
from dws.dws_user_market_channel_info_detail_td 
where dt ='${bf_1_dt}'  
and product_id !=6883
and concat(Product_Id,user_id,mt,corever,lang2) not in 
(
SELECT concat(product_id,user_id,mt,core,current_language2)
from dwd.dwd_user_install_info_ed_view
where  dt>='${dt}'and install_date<date_add(now(),interval -10 minute) and user_id<>-1 and isdelete=0   and product_id !=6883
)  ;
