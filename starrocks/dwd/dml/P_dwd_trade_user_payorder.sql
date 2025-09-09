----------------------------------------------------------------
-- 程序功能： 交易域用户充值事实表
-- 程序名： P_dwd_trade_user_payorder
-- 目标表： dwd.dwd_trade_user_payorder
-- 开发人： qhr
-- 开发日期： 2023-10-26
----------------------------------------------------------------

insert into dwd.dwd_trade_user_payorder
select dt
      ,productid
      ,id                                                                                       as autoid
      ,if(userid is null or userid = '', -99, userid)                                           as userid
      ,if(type is null or type = '', -99, type)                                                 as paychannelidid
      ,if(used is null or used = '', -99, used)                                                 as used
      ,if(orderid is null or orderid = '', -99, orderid)                                        as orderid
      ,if(flag is null or flag = '', -99, flag)                                                 as flag
      ,if(createtime is null or createtime = '', '1970-01-01 00:00:00', createtime)             as createtime
      ,if(gettime is null or gettime = '', '1970-01-01 00:00:00', gettime)                      as gettime
      ,if(actualamount > 0, actualamount, itemcount)                                            as itemcount
      ,if(systemtype is null or systemtype = '', -99, systemtype)                               as systemtype
      ,if(receivedate is null or receivedate = '', '1970-01-01 00:00:00', receivedate)          as receivedate
      ,if(mt is null or mt = '', -99, mt)                                                       as mt
      ,if(couponid is null or couponid = '', -99, couponid)                                     as couponid
      ,if(packageid is null or packageid = '', -99, packageid)                                  as packageid
      ,if(shopitem is null or shopitem = '', -99, shopitem)                                     as shopitem
      ,if(extinfo is null or extinfo = '', -99, extinfo)                                        as extinfo
      ,if(vipexpiretime is null or vipexpiretime = '', -99, vipexpiretime)                      as vipexpiretime
      ,if(realmoney is null or realmoney = '', -99, realmoney)                                  as realmoney
      ,if(givemoney is null or givemoney = '', -99, givemoney)                                  as awardmoney
      ,if(payconfigid is null or payconfigid = '', -99, payconfigid)                            as payconfigid
      ,if(corever is null or corever = '', -99, corever)                                        as corever
      ,if(uniqueguid is null or uniqueguid = '', -99, uniqueguid)                               as deviceguid
      ,if(testflag is null or testflag = '', -99, testflag)                                     as testflag
      ,if(baseamount is null or baseamount = '', -99, baseamount)                               as baseamount
      ,if(version is null or version = '', -99, version)                                        as version
      ,if(subpaytype is null or subpaytype = '', -99, subpaytype)                               as subpaytype
      ,if(giftmoney is null or giftmoney = '', -99, giftmoney)                                  as giftmoney
      ,if(orderinittime is null or orderinittime = '', '1970-01-01 00:00:00', orderinittime)    as orderinittime
      ,if(cooorderextinfo is null or cooorderextinfo = '', -99, cooorderextinfo)                as cooorderextinfo
      ,productdata                                                                              as product_data
      ,sensorsdata
      ,now()                                                                                    as etl_time
  from ods.ods_book_user_payorder
 where dt >= '${bf_1_dt}'
   and dt < date(date_add('${bf_1_dt}', interval 1 day))
   and testflag = 0
;