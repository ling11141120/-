----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_short_video_account_device_info
-- workflow_version : 10
-- create_user      : zhugl
-- task_name        : tbl_dim_short_video_account_device_info
-- task_version     : 10
-- update_time      : 2025-05-28 16:08:01
-- sql_path         : \starrocks\tbl_dim_short_video_account_device_info\tbl_dim_short_video_account_device_info
----------------------------------------------------------------
-- SQL语句
insert overwrite dim.dim_short_video_account_device_info
with accountinfo as (
    select
        accountinfo.Id,
        accountinfo.Account,
        accountinfo.Nick,
        accountinfo.Sex,
        accountinfo.CreateTime,
        accountinfo.LastLoginTime,
        accountinfo.Chl2,
        accountinfo.Chl,
        accountinfo.Mt,
        accountinfo.Mt2,
        accountinfo.UniqueCdReaderId,
        accountinfo.CurrentLanguage2,
        accountinfo.CurrentLanguage,
        accountinfo.CoreVer,
        accountinfo.CoreVer2,
        accountinfo.AdId,
        accountinfo.Status,
        accountinfo.RegCountry,
        accountinfo.row_update_time,
        accountinfo.Version,
        accountinfo.IsDelete,
        accountinfo.Avatar,
        accountinfo.InstallDate,
        accountinfo.SourceChl,
        accountinfo.IDFA,
        accountinfo.Email,
        accountinfo.IsOfficial,
        accountinfo.UniqueId,
        accountinfo.ThirdPartyId,
        accountinfo.country,
        accountinfo.appver
    from ods.ods_tidb_short_video_accountinfo accountinfo
),
device as (
    select
        device.Appver,
        device.Locale,
        device.Userid,
        device.Langid,
        device.`Timestamp`,
        device.Ver,
        device.Device2,
        device.Syslanguage,
        device.Mt,
        device.Osver,
        device.Appid,
        device.X,
        device.utcoffset,
        device.Guid,
        device.Supportutctime,
        device.Device,
        device.Androidid,
        device.DeviceToken,
        device.SignNotify,
        device.AppNotify,
        device.regionId,
        device.UniqueCdReaderId,
        device.RealTimeActivityNotify,
        ROW_NUMBER () over(partition by Userid order by `Timestamp` desc ) as n
    from ods.ods_tidb_short_video_device_info device
),
deviceother as (
    select
        a.AccountId,
        a.DeviceId,
        b.Appver,
        b.Device,
        b.Device2,
        b.OSver,
        b.mt
    from  ods.ods_tidb_short_video_device_account as a
    left join ods.ods_tidb_short_video_device_info as b
    on a.DeviceId = b.UniqueCdReaderId
)
select
    6833,
    accountinfo.Id,
    accountinfo.Account,
    accountinfo.Nick,
    accountinfo.Sex,
    accountinfo.CreateTime,
    accountinfo.LastLoginTime,
    accountinfo.Chl2,
    accountinfo.Chl,
    accountinfo.Mt,
    accountinfo.Mt2,
    accountinfo.UniqueCdReaderId,
    accountinfo.CurrentLanguage2,
    accountinfo.CurrentLanguage,
    accountinfo.CoreVer,
    accountinfo.CoreVer2,
    accountinfo.AdId,
    accountinfo.Status,
    accountinfo.RegCountry,
    accountinfo.row_update_time,
    accountinfo.Version,
    accountinfo.IsDelete,
    accountinfo.Avatar,
    accountinfo.InstallDate,
    accountinfo.SourceChl,
    accountinfo.IDFA,
    accountinfo.Email,
    accountinfo.IsOfficial,
    accountinfo.UniqueId,
    accountinfo.ThirdPartyId,
    accountinfo.country,
--
    coalesce(accountinfo.appver, device.Appver,deviceother.Appver) app_ver,
    device.Locale,
    device.Userid,
    device.Langid,
    device.`Timestamp`,
    device.Ver,
    IFNULL(device.Device2,deviceother.Device2)Device2,
    device.Syslanguage,
    IFNULL(device.Mt,deviceother.Mt) Mt,
    IFNULL(device.Osver,deviceother.Osver) Osver,
    device.Appid,
    device.X,
    device.utcoffset,
    device.Guid,
    device.Supportutctime,
    device.Device,
    device.Androidid,
    device.DeviceToken,
    device.SignNotify,
    device.AppNotify,
    device.regionId,
    device.RealTimeActivityNotify,
    now() as etl_time
from  accountinfo
left join device
  on accountinfo.UniqueCdReaderId = device.UniqueCdReaderId
  and   device.n =1
left join deviceother
  on accountinfo.id = deviceother.AccountId;
