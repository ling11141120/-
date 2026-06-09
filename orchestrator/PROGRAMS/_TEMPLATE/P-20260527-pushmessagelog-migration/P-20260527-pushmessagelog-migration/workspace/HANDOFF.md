## HANDOFF

### 当前状态
- 已完成: 代码改造 Review、ODS 验证、DWD 上线并首跑、DWD 解析正确性验证
- 验证发现: Body/CustomData 解析正确，字段映射正确。但 CustomData 5/26 前为空（上游未上线），AccountId 10-15% 为空（上游数据问题，DWD 无法兜底）
- 阻塞: 上游 unifypush_log 未全量上线

### 分支
`feature/qhr/pushmessagelog迁移` @ 57e84f0（2 个 commit 待本地 push）

### 关键决策
- DWD product_id 从 apps 表还原
- StarRocks 不支持 nullable→non-nullable，ODS AppId NOT NULL 已回退
- 下游表暂不切换，DWD 先独立运行积累数据
- AccountId 为空影响下游：ads_bi_tag_push_result_info 统计偏低 10-15%，dws 下发事件直接丢弃这些记录

### 下一步
1. 本地 `git push`
2. 确认是否接受 10-15% AccountId 缺失，或联系服务端排查
3. 等待上游全量上线
4. 说"继续 P-20260527"继续
