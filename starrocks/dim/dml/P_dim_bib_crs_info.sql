----------------------------------------------------------------
-- 程序功能： 圣经课程信息
-- 程序名： P_dim_bib_crs_info
-- 目标表： dim.P_dim_bib_crs_info
-- 负责人： xjc
-- 开发日期： 2025-10-23
----------------------------------------------------------------

insert into dim.dim_bib_crs_info
select a1.id                                    as crs_id               -- 课程id
      ,a1.coursename                            as crs_name             -- 课程名称
      ,a1.coursecover                           as crs_cover            -- 课程封面
      ,a1.state                                 as pub_statu_cd         -- 上架状态编码
      ,case when a1.state = 1 then '上架'
            when a1.state = 0 then '下架'
            else null
        end                                     as pub_statu_name       -- 上架状态名称
      ,a1.courseepisodes                        as crs_ep_num           -- 课程集数
      ,split(a1.tags, ',')                      as crs_tag_lst          -- 课程标签序列
      ,a1.score                                 as crs_rtg              -- 课程评分
      ,a1.comment                               as rmk                  -- 课程描述
      ,a1.scene                                 as scn                  -- 课程场景
      ,a1.scenetag                              as scn_tag              -- 课程场景标签
      ,a1.author                                as auth                 -- 课程作者
      ,a1.bgimgtype                             as bg_clr_type_cd       -- 课程背景颜色类型编码
      ,case when a1.bgimgtype = 0 then '浅色'
            when a1.bgimgtype = 1 then '深色'
            else null
        end                                     as bg_clr_type_name     -- 课程背景颜色类型名称
      ,now()                                    as etl_time             -- etl时间
  from ods.ods_tidb_hallow_courses a1
;