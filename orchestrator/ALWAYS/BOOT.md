# Boot Sequence

## 首次启动

如果 `RESOURCE-MAP.yml` 内容为空（全部注释）：

1. 询问用户项目基本情况：仓库地址、技术栈、基础设施、部署方式
2. 根据用户描述生成 `RESOURCE-MAP.yml`
3. 继续正常启动流程

## 正常启动

用户指定 Program 后，按以下顺序加载：

### 加载顺序

1. `orchestrator/ALWAYS/CORE.md` — 核心工作协议
2. `orchestrator/ALWAYS/DEV-FLOW.md` — 开发流程规范
3. `orchestrator/ALWAYS/RESOURCE-MAP.yml` — 资源索引
4. `orchestrator/PROGRAMS/{program_id}/PROGRAM.md` — 任务定义
5. `orchestrator/PROGRAMS/{program_id}/STATUS.yml` — 当前状态
6. `orchestrator/PROGRAMS/{program_id}/SCOPE.yml` — 写入范围

### 加载完成后输出

```
Program: {名称}
目标: {一句话描述}
当前阶段: {阶段名}
下一步: {具体行动}
```

### 辅助规范（按需加载）

- `orchestrator/ALWAYS/CHANGELOG-SPEC.md` — AI 赋能效率占比 CHANGELOG 规范（涉及 CHANGELOG 编辑/合并时加载）

### 特殊情况

- 如果 Program 目录不存在，询问用户是否创建（从 `_TEMPLATE` 复制）
- 如果存在 `workspace/CHECKPOINT.md`，优先读取恢复上下文
- 如果存在 `workspace/HANDOFF.md`，读取上次交接内容

## 新建 Program

从模板创建：

```bash
cp -r orchestrator/PROGRAMS/_TEMPLATE orchestrator/PROGRAMS/P-YYYY-NNN-<name>
```

然后进入 **Plan 模式**（详见 `DEV-FLOW.md` 方案设计章节），与用户对话确定开发细节后，再编辑 PROGRAM.md 和 SCOPE.yml。
