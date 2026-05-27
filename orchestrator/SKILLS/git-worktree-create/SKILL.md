---
name: git-worktree-create
description: 基于 dev 分支创建 git worktree。当用户说"创建 worktree"、"通过 dev 创建 worktree"、"新建 worktree"、"git worktree"等语句时触发。自动询问开发人名称和分支名称，然后在本地 dev 分支最新代码基础上创建新的 feature 分支 worktree。
---

# Git Worktree 创建

基于 `dev` 分支创建 git worktree，用于快速搭建独立的功能开发环境。

## 工作流程

1. 询问用户两个信息：**开发人名称**和**分支名称**。
2. 在仓库根目录执行 git 命令完成 worktree 创建。
3. 输出创建结果和 worktree 路径。

## 第一步：收集信息

使用 AskUserQuestion 工具向用户询问：

- **开发人名称**（header: "开发者"）— 用于拼接分支路径 `feature/{开发人}/{分支名}` 和 worktree 目录名
- **分支名称**（header: "分支名"）— 新分支的名称（不包含 `feature/` 前缀，不需要输入开发者名称部分）

分支名的典型格式示例：`ads_user_retention_di`、`dwd_read_event_df`、`fix_order_dedup` 等。

## 第二步：前置准备 — 挂载目录

执行前必须确保以下两个目录已挂载（使用 `request_cowork_directory` 申请）：

- **主仓库**：`D:\Develop\kunlun-dolphinscheduler` → 沙箱路径为 `/sessions/sharp-friendly-ride/mnt/kunlun-dolphinscheduler/`
- **父目录**：`D:\Develop` → 沙箱路径为 `/sessions/sharp-friendly-ride/mnt/Develop/`

**父目录挂载是关键**：worktree 目标必须在已挂载的 Windows 目录下创建，否则会落在沙箱内部文件系统，Windows 资源管理器无法访问。`D:\Develop` 是 worktree 的父目录，必须先挂载。

## 第三步：执行创建

### 完整脚本流程

```bash
# 变量（运行时替换）
REPO_PATH="/sessions/sharp-friendly-ride/mnt/kunlun-dolphinscheduler"
DEVELOPER="开发人名称"
BRANCH="分支名称"
FEATURE_BRANCH="feature/${DEVELOPER}/${BRANCH}"
# 关键：worktree 路径必须在已挂载的 D:\Develop 下，对应沙箱 /sessions/sharp-friendly-ride/mnt/Develop/
WORKTREE_PATH="/sessions/sharp-friendly-ride/mnt/Develop/kunlun-dolphinscheduler-${BRANCH}"

# 步骤 1：进入仓库并切换到 dev 分支
cd "${REPO_PATH}"
git checkout dev

# 步骤 2：尝试拉取远程 dev 分支最新代码
# 注意：沙箱网络可能受限，如果 pull 失败（如 HTTP 403），提示用户手动在 Windows 终端执行 git pull
git pull origin dev || echo "⚠️ git pull 失败，请手动在 Windows 终端执行: cd D:\\Develop\\kunlun-dolphinscheduler && git pull origin dev"

# 步骤 3：基于 dev 创建 worktree，同时创建新分支
git worktree add -b "${FEATURE_BRANCH}" "${WORKTREE_PATH}" dev
```

### 命令说明

- `git checkout dev` — 切换到本地 dev 分支
- `git pull origin dev` — 尝试从远程拉取 dev 最新代码；沙箱网络受限时改为提示用户手动 pull
- `git worktree add -b "${FEATURE_BRANCH}" "${WORKTREE_PATH}" dev` — 基于 dev 创建新 worktree，同时新建 `feature/{开发人}/{分支名}` 分支，工作目录放在 `D:\Develop\kunlun-dolphinscheduler-{分支名}`

## 错误处理

| 场景 | 处理方式 |
|------|----------|
| 主仓库未挂载 | 使用 `request_cowork_directory` 申请 `D:\Develop\kunlun-dolphinscheduler` |
| `D:\Develop` 未挂载 | 使用 `request_cowork_directory` 申请 `D:\Develop` |
| 本地有未提交的修改导致 checkout 失败 | 提示用户先 `git stash` 或提交修改后再试 |
| `git pull` 因网络受限失败 | 提示用户在 Windows 终端手动执行 `git pull origin dev`，完成后告知继续 |
| worktree 目标路径已存在 | 先 `git worktree remove` 清理，再删除同名分支后重建 |
| 分支名 `feature/{开发人}/{分支名}` 已存在 | 先 `git branch -D` 删除，再重新创建 |
| `.git/index.lock` 残留导致 git 命令失败 | 使用 `allow_cowork_file_delete` 后删除锁文件 |

## 第三步：输出结果

创建成功后，向用户报告：

- 新分支全名：`feature/{开发人}/{分支名}`
- worktree 本地路径：`D:\Develop\kunlun-dolphinscheduler-{分支名}`
- 基于分支：`dev`（附带最新 commit 的简短 hash）
