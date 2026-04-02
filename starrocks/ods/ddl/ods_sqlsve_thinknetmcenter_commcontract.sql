----------------------------------------------------------------
-- 目标表： ods.ods_sqlsve_thinknetmcenter_commcontract
-- 来源实例： 10.10.10.161-查询
-- 来源表： thinknet.mcenter.commcontract
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-03-03
----------------------------------------------------------------

drop table if exists ods.ods_sqlsve_thinknetmcenter_commcontract;
create table ods.ods_sqlsve_thinknetmcenter_commcontract (
    id                int              not null                     comment "主键"
   ,contractnumb      varchar(300)     not null                     comment "合同编号"
   ,contractname      varchar(600)     not null                     comment "合同名称"
   ,partyb            varchar(600)                                  comment "乙方"
   ,partybcontacts    varchar(300)                                  comment "乙方联系人"
   ,representative    varchar(300)                                  comment "乙方授权代表"
   ,partyadate        datetime                                      comment "签署日期 终止：（甲方）  单个时间都用这个"
   ,partybdate        datetime                                      comment "终止：终止日期  收款协议变更：乙方（签署时间）"
   ,authorid          int              not null                     comment "作者id"
   ,verify            tinyint          not null                     comment "合同类型名称   可选=作品授权协议（买断） 21、作品授权协议（分成） 20、作品授权协议（保底分成）16 22终止合同  11修改书名 50书籍又名 8收款账号变更 201三方主体变更协议"
   ,editname          varchar(60)                                   comment "编辑名称"
   ,platform          tinyint          not null                     comment "平台"
   ,tempfile          varchar(3000)                                 comment "tempfile"
   ,formalfile        varchar(3000)                                 comment "formalfile"
   ,formalfileview    varchar(3000)                                 comment "formalfileview"
   ,pennames          varchar(300)                                  comment "笔名"
   ,greement          varchar(600)                                  comment "Verify!=16为书籍id    Verify==16为 税前价格（元/千字）"
   ,greement2         varchar(600)                                  comment "Verify==16为大纲交付期限（天数） 22为新书名"
   ,greementdate      datetime                                      comment "终止：乙方签署日期"
   ,greementdate2     datetime                                      comment "greementdate2"
   ,novelname         varchar(300)                                  comment "小说名称"
   ,ext               varchar(300)                                  comment "Verify==16 作品每月字数（万）, 20/21作品总字数（万）   8开户名称"
   ,ext1              varchar(300)                                  comment "Verify==16为作品总字数（万）  Verify==21为买断价格（元/千字） 20作品每月字数（万）    8开户银行"
   ,ext2              varchar(300)                                  comment "Verify==16的书籍id verify=21每月提交字数（万） /20为大纲交付期限（天数） 8银行账号"
   ,ext3              varchar(300)                                  comment "21大纲交付期限（天数）"
   ,status            tinyint          not null                     comment "0待责编审核 1等待作者签章 2作者签署完成 3责编审核拒绝 4OA审批中 5OA审批通过  6OA审批拒绝  7旧主体正在签章  8旧主体签章完成   11公司正在签署 12签章完成  100合同归档 101作废"
   ,optiontime        datetime                                      comment "操作时间"
   ,channel           int                                           comment "渠道"
   ,renovelname       varchar(765)                                  comment "renovelname"
   ,ext4              varchar(150)                                  comment "ext4"
   ,ext5              varchar(150)                                  comment "oa审批单号"
   ,ext6              varchar(150)                                  comment "责编id"
   ,ext7              varchar(150)                                  comment "作者id"
   ,ext8              varchar(150)                                  comment "oa审批实例号"
   ,operator          varchar(1200)                                 comment "操作人"
   ,sendtime          datetime                                      comment "合同发送时间"
   ,signtime          datetime                                      comment "签订完毕时间"
   ,promisestatus     int              not null                     comment "承诺函状态 0待归档 1已归档"
   ,promisefile       varchar(3000)                                 comment "承诺函地址"
   ,ext9              varchar(1500)                                 comment "ext9"
   ,ext10             varchar(1500)                                 comment "ext10"
   ,ext11             varchar(1500)                                 comment "ext11"
   ,ext12             varchar(1500)                                 comment "ext12"
   ,ext13             varchar(1500)                                 comment "ext13"
   ,ext14             varchar(1500)                                 comment "ext14"
   ,ext15             varchar(1500)                                 comment "ext15"
   ,cpmode            int                                           comment "合作模式 0保底 1分成"
   ,scoretype         int                                           comment "D= 0,  S = 1,   A = 2,  B = 3,  C = 4"
   ,storytype         int              not null                     comment "类型0长篇小说 1短篇小说"
   ,isexecuted        int              not null                     comment "是否执行过，新掌中使用"
   ,bookid            varchar(150)                                  comment "书籍id"
   ,greementdate3     datetime                                      comment "greementdate3"
   ,greementdate4     datetime                                      comment "greementdate4"
   ,greementdate5     datetime                                      comment "greementdate5"
   ,authortype        int              not null                     comment "authortype"
   ,ext16             varchar(1500)                                 comment "ext16"
   ,ext17             varchar(1500)                                 comment "ext17"
   ,ext18             varchar(1500)                                 comment "ext18"
   ,ext19             varchar(1500)                                 comment "ext19"
   ,ext20             varchar(1500)                                 comment "ext20"
   ,sr_createtime     datetime         default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime     datetime         default current_timestamp    comment "starrocks数据更新时间"
)
primary key(id)
comment "签约编辑信息"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;