create view `ads_objectcaldistance_view`
            (`Id` comment "主键", `ProductId` comment "产品id", `SiteId` comment "语言id",
             `SwBookId` comment "目标书籍id", `ObjectBookId` comment "项目图书id", `ObjectChapterId` comment "章节id",
             `Distance1` comment "质检分子", `Distance2` comment "一校分子", `Distance3` comment "二校分子",
             `MachineLength` comment "机翻字符数", `EChapterLength` comment "质检字符数",
             `PEChapterLength` comment "一校字符数", `WkChapterLength` comment "二校字符数",
             `CreateTime` comment "创建时间", `CompleteTime` comment "质检完成时间",
             `ForeignTime` comment "一校完成时间", `PublishTime` comment "二校完成时间")
as
select `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`Id`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`ProductId`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`SiteId`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`SwBookId`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`ObjectBookId`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`ObjectChapterId`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`Distance1`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`Distance2`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`Distance3`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`MachineLength`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`EChapterLength`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`PEChapterLength`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`WkChapterLength`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`CreateTime`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`CompleteTime`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`ForeignTime`
     , `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`.`PublishTime`
  from `ods`.`ods_tidb_shuangwen_tidb_xx_objectcaldistance`;