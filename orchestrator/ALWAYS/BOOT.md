# Boot Sequence

## 首次启动

如果 `RESOURCE-MAP.yml` 内容为空（全部注释）：
1. 询问用户项目基本情况：仓库地址、技术栈、基础设施、部署方式
2. 根据用户描述生成 `RESOURCE-MAP.yml`
3. 继续正常启动流程

如果 `SHARED/knowledge/` 下尚无分析规则文件：
1. 询问用户目前有哪些分析标准和规则（如数据资产定级标准、质量评估规则等）
2. 协助用户将规则结构化写入 `SHARED/knowledge/`
3. 此步骤不影响开发类 Program 的正常使用

## 正常启动

用户指定 Program 后，Agent 按以下步骤启动：

### 第一步：判断 Program 类型

读取 `PROGRAMS/{program_id}/PROGRAM.md` 中的 `type` 字段：
- `type: development` → 开发类流程
- `type: analysis` → 分析类流程
- 如果文件尚不存在（新建 Program），根据用户命令判断：
  - "新 Program: xxx" → 默认 development
  - "新分析: xxx" → analysis

### 第二步：按类型加载

**所有类型通用（必读）：**

1. `ALWAYS/CORE.md` — 核心工作协议（含 Plan 确认清单，自动按类型选取）  

**开发类额外加载：**  

2. `ALWAYS/DEV-FLOW.md` — 数仓开发流程规范
3. `ALWAYS/RESOURCE-MAP.yml` — 资源索引

**分析类额外加载：**

2. `ALWAYS/DEV-FLOW.md` — 参考其中的命名规范、分层结构、commit 规范
3. `ALWAYS/RESOURCE-MAP.yml` — 资源索引（仓库结构）
4. `SHARED/knowledge/` — 分析规则/标准（根据 Program 主题按需加载）

**通用加载（最后）：**

4/5. `PROGRAMS/{program_id}/PROGRAM.md` — 任务定义
5/6. `PROGRAMS/{program_id}/STATUS.yml` — 当前状态
6/7. `PROGRAMS/{program_id}/SCOPE.yml` — 写入范围

### 加载完成后输出  

```  
Program: {名称}  
类型: {development / analysis}  
目标: {一句话描述}  
当前阶段: {阶段名}  
下一步: {具体行动}  
```  

### 辅助规范（按需加载）  

- `ALWAYS/CHANGELOG-SPEC.md` — AI 赋能效率占比 CHANGELOG 规范（涉及 CHANGELOG 编辑/合并时加载）  
- `ALWAYS/SUB-AGENT.md` — Sub-Agent 委托规范（用户说"委托"时加载）  

### 特殊情况  

- 如果 Program 目录不存在，询问用户是否创建（从 `_TEMPLATE` 复制）
- 如果存在 `workspace/CHECKPOINT.md`，优先读取恢复上下文
- 如果存在 `workspace/HANDOFF.md`，读取上次交接内容
- 如果 PROGRAM.md 中 `type` 字段缺失，根据目录下已有产物推断（有 SQL 文件 → development；有 analysis/ 子目录 → analysis），无法推断时询问用户

## 新建 Program

从模板创建：

```bash
cp -r orchestrator/PROGRAMS/_TEMPLATE orchestrator/PROGRAMS/P-YYYY-NNN-<name>
```

然后进入 **Plan 模式**（详见 `DEV-FLOW.md` 方案设计章节或 `CORE.md` 分析类 Plan 清单），与用户对话确定细节后，再编辑 PROGRAM.md 和 SCOPE.yml。

新建时必须填写 `type` 字段：

```yml
# PROGRAM.md frontmatter
type: development   # development | analysis  
subtype: batch      # 开发类可选；分析类必填：batch / deep-dive / ad-hoc
```
