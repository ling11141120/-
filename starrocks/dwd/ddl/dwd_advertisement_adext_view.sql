create or replace view dwd.dwd_advertisement_adext_view as
select
     id                     as id                -- 主键id
    ,product_id             as product_id        -- 产品id
    ,ad_id                  as ad_id             -- 广告id
    ,book_id                as book_id           -- 书籍id
    ,ads_type               as ads_type          -- 广告类型
    ,ads_quality            as ads_quality       -- 广告质量
    ,web_site               as web_site          -- 官网
    ,position               as position          -- 广告位置
    ,create_time            as create_time       -- 创建时间
    ,update_time            as update_time       -- 更新时间
    ,ad_name                as ad_name           -- 广告名称
    ,ad_setname             as ad_setname        -- 广告组名称
    ,ad_campname            as ad_campname       -- 广告系列名称
    ,book_channel           as book_channel      -- 书籍类型
    ,book_nature            as book_nature       -- 书籍来源
    ,book_name              as book_name         -- 书籍名称
    ,ad_set_id              as ad_set_id        -- 广告组id
    ,ad_camp_id             as ad_camp_id       -- 广告系列
    ,fb_account             as fb_account        -- fb账号
    ,url                    as url               -- 广告url
    ,page_version           as page_version      -- 广告页面版本
    ,at                     as at                -- 广告归因窗口
    ,mt                     as mt                -- 终端
    ,core                   as core              -- 包体
    ,chl2                   as chl2              -- 渠道值
    ,current_language2      as current_language2-- 语言
    ,source_chl             as source_chl        -- 媒体渠道值
    ,ads_optimizer          as ads_optimizer     -- 优化师
    ,account_tz             as account_tz        -- 账号时区 -13=gmt-5默认时区|-20=gmt-12英西时区|-18=gmt-10葡语时区|-7=gmt+1亚洲时区
    ,ad_optimizer_code      as ad_optimizer_code-- 优化师缩写
    ,tv_id                  as tv_id             -- 国内短剧id
    ,tv_name                as tv_name           -- 国内短剧名称
    ,invite_code            as invite_code       -- 代理编码
    ,invite_name            as invite_name       -- 代理名称
    ,middleman_id           as middleman_id      -- 机构编码
    ,middleman_name         as middleman_name    -- 机构名称
    ,tf_id                  as tf_id             -- 投放id
    ,tf_url                 as tf_url            -- 投放链接
    ,pay_tmpl               as pay_tmpl          -- 充值模板
    ,tv_code                as tv_code           -- 国剧代号
    ,video_id               as video_id          -- 3a和普通广告的视频素材id
    ,ad_optimizer_uid       as ad_optimizer_uid  -- 优化师工号
    ,ad_optimizer_group     as ad_optimizer_group-- 优化师组别
    ,ad_optimizer_master    as ad_optimizer_master-- 优化师师傅工号
    ,xcx_type               as xcx_type          -- 国剧账号小程序类型 1=抖小|2=微小
    ,ad_group_name          as ad_group_name     -- 广告组别
    ,page_id                as page_id           -- 页面id
    ,pic_id                 as pic_id            -- 默认图片id
    ,non_pic_id             as non_pic_id        -- 非标图片id
    ,doc_id                 as doc_id            -- 文案id
    ,btn_id                 as btn_id            -- 按钮id
    ,xcx_app_id             as xcx_app_id        -- 国剧微信小程序appid
    ,xcx_bxms               as xcx_bxms          -- 国剧变现模式iaa|iap
    ,search_word            as search_word       -- 用户搜索词
    ,page_temp_type         as page_temp_type    -- 落地页模板类型
    ,agent_id               as agent_id          -- 代理商id
    ,cd_code                as cd_code           -- 短剧分销唯一编码
    ,inst_id                as inst_id           -- 机构id
    ,dc_acct                as dc_acct            -- 分销投放账号
  from ods.ods_tidb_sharpengine_ads_global_adext
;
