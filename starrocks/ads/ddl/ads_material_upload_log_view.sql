CREATE VIEW ads.ads_material_upload_log_view (
     id                             comment "主键ID"
    ,material_id                    comment "素材Id"
    ,material_name                  comment "素材名称"
    ,material_url                   comment "素材生成后视频地址"
    ,cos_key                        comment "COS KEY"
    ,cos_path                       comment "COS 地址"
    ,upload_status                  comment "上传状态"
    ,upload_remark                  comment "上传日志信息"
    ,meta_info                      comment "视频信息"
    ,folder                         comment "目录Id"
    ,upload_id                      comment "素材生成后的Id"
    ,upload_video_id                comment "素材生成后视频Id"
    ,sort                           comment "排序"
    ,create_time                    comment "写入时间"
    ,update_time                    comment "更新时间"
    ,language_name                  comment "语言"
    ,material_type                  comment "素材类型"
    ,editor                         comment "剪辑师缩写"
    ,tag1                           comment "一级标签"
    ,tag2                           comment "二级标签"
    ,tag3                           comment "三级标签"
    ,code                           comment "剧代号"
    ,ratio                          comment "尺寸"
    ,cos_start_time                 comment "COS上传时间"
    ,cos_compelete_time             comment "COS上传完成时间"
    ,bm_start_time                  comment "BM上传开始时间"
    ,bm_compelete_time              comment "BM上传结束时间"
    ,file_size                      comment "文件大小"
    ,is_priority                    comment "是否优先"
    ,material_full_name             comment "素材名称"
    ,make_date                      comment "素材发布日期"
    ,image_url                      comment "素材BM图片地址"
    ,image_hash                     comment "FB的图片Hash值"
    ,asset_guid                     comment "素材唯一标识"
    ,selling_point                  comment "卖点"
    ,region_folder                  comment "区域文件夹"
    ,asset_id                       comment "素材中心唯一Id"
    ,batch_id                       comment "批次Id"
    ,file_md5                       comment "MD5"
    ,thumbnail_url                  comment "生成缩略图的地址"
    ,tgt_type                       comment "目标类型 1=书|2=短剧|3=国剧"
    ,material_time                  comment "任务提交时间"
    ,current_language               comment "语言"
    ,leader_uid                     comment "组长工号"
    ,materia_uid                    comment "剪辑师工号"
    ,source_chl_type                comment "媒体类型 0=未知|1=Facebook|2=Tiktok"
    ,sync_material_upload_log_id    comment "同步的素材上传记录ID"
    ,fission_lang                   comment "素材视频已裂变语言多个逗号分隔"
    ,tgt_name                       comment "目标名称TaskType=1=书籍ID|TaskType=2=书籍代号"
    ,fission_parent_id              comment "裂变父级ID"
    ,fission_job_id                 comment "裂变作业Id"
    ,log_type                       comment "上传类型,0=默认|1=批量上传忽略MD5"
    ,level                          comment "素材等级"
    ,bm_id                          comment "Business Manager Id"
    ,res_source_type                comment "素材来源"
    ,res_source_id                  comment "来源ID"
    ,fb_sync_status                 comment "同步状态"
    ,sr_createtime                  comment "starrocks数据注入时间"
    ,sr_updatetime                  comment "starrocks数据更新时间"
)
AS SELECT
    tbl.Id,
    tbl.MaterialId,
    tbl.MaterialName,
    tbl.MaterialUrl,
    tbl.CosKey,
    tbl.CosPath,
    tbl.UploadStatus,
    tbl.UploadRemark,
    tbl.MetaInfo,
    tbl.Folder,
    tbl.UploadId,
    tbl.UploadVideoId,
    tbl.Sort,
    tbl.CreateTime,
    tbl.UpdateTime,
    tbl.LanguageName,
    tbl.MaterialType,
    tbl.Editor,
    tbl.Tag1,
    tbl.Tag2,
    tbl.Tag3,
    tbl.Code,
    tbl.Ratio,
    tbl.CosStartTime,
    tbl.CosCompeleteTime,
    tbl.BmStartTime,
    tbl.BmCompeleteTime,
    tbl.FileSize,
    tbl.IsPriority,
    tbl.MaterialFullName,
    tbl.MakeDate,
    tbl.ImageUrl,
    tbl.ImageHash,
    tbl.AssetGuid,
    tbl.SellingPoint,
    tbl.RegionFolder,
    tbl.AssetId,
    tbl.BatchId,
    tbl.FileMd5,
    tbl.ThumbnailUrl,
    tbl.TgtType,
    tbl.MaterialTime,
    tbl.CurrentLanguage,
    tbl.LeaderUid,
    tbl.MateriaUid,
    tbl.SourceChlType,
    tbl.SyncMaterialUploadLogId,
    tbl.FissionLang,
    tbl.TgtName,
    tbl.FissionParentId,
    tbl.FissionJobId,
    tbl.LogType,
    tbl.Level,
    tbl.BmId,
    tbl.ResSourceType,
    tbl.ResSourceId,
    tbl.FbSyncStatus,
    tbl.sr_createtime,
    tbl.sr_updatetim
FROM ods.ods_tidb_sharpengine_ads_asset_prod_MaterialUploadLog AS tbl
;
