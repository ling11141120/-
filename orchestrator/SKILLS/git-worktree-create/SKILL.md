---
name: git-worktree-create
description: 基于 master 分支创建 git worktree。当用户说"创建 worktree"、"通过 master 创建 worktree"、"新建 worktree"、"git worktree"等语句时触发。自动询问开发人名称和分支名称，然后在本地 master 分支最新代码基础上创建新的 feature 分支 worktree。
---

# Git Worktree 创建

基于 `master` 分支创建 git worktree，用于快速搭建独立的功能开发环境。

## 核心原则

**VM 沙箱操作必须秒级完成。** `git worktree add` 隐含全量文件 checkout，通过 VM 挂载层写入极慢（大仓库轻松超过 45 秒超时），因此必须使用 `--no-checkout` 跳过文件检出，文件检出由用户在 Windows 终端完成。

## 工作流程

1. 询问用户两个信息：**开发人名称**和**分支名称**。
2. 确保主仓库和父目录均已挂载。
3. 在仓库根目录执行 git 命令完成 worktree **元数据创建**（不含文件检出）。
4. 修复 `.git` 文件中的沙箱路径为相对路径，确保 Windows 端可用。
5. 清理 worktree 元数据目录中的 `index.lock`，确保用户端 `git reset` 不被阻塞。
6. 输出创建结果，并**明确告知用户需要在 Windows 终端执行的最后一步命令**。

## 第一步：收集信息

使用 AskUserQuestion 工具向用户询问：

- **开发人名称**（header: "开发者"）— 用于拼接分支路径 `feature/{开发人}/{分支名}`
- **分支名称**（header: "分支名"）— 新分支的名称（不包含 `feature/` 前缀）

## 第二步：前置准备 — 挂载目录

执行前必须确保以下两个目录已挂载（使用 `request_cowork_directory` 申请）：

- **主仓库**：`D:\Develop\kunlun-dolphinscheduler` → 沙箱路径为对应挂载路径
- **父目录**：`D:\Develop` → worktree 目标必须在已挂载的 Windows 目录下创建，否则会落在沙箱内部文件系统，Windows 资源管理器无法访问

## 第三步：执行创建

### 变量定义

```bash
REPO_PATH="主仓库沙箱挂载路径"          # 例: /sessions/.../mnt/kunlun-dolphinscheduler
PARENT_PATH="D:\Develop 沙箱挂载路径"   # 例: /sessions/.../mnt/Develop
DEVELOPER="开发人名称"
BRANCH="分支名称"
FEATURE_BRANCH="feature/${DEVELOPER}/${BRANCH}"
WORKTREE_DIR="kunlun-dolphinscheduler-${BRANCH}"
WORKTREE_PATH="${PARENT_PATH}/${WORKTREE_DIR}"
```

### 步骤 3.1：切换到 master 并尝试拉取

```bash
cd "${REPO_PATH}"
git checkout master

# 尝试拉取远程最新（沙箱网络可能受限，失败不阻塞流程）
git pull origin master 2>&1 || echo "⚠ git pull 失败"
```

如果 git pull 失败，告知用户后续在 Windows 终端手动执行 `cd D:\Develop\kunlun-dolphinscheduler && git pull origin master`。

### 步骤 3.2：清理可能存在的旧 worktree / 分支

```bash
# 如果 worktree 目录已存在，先清理
if [ -d "${WORKTREE_PATH}" ]; then
    # 解锁（可能因上次中断而 locked）
    git --git-dir="${REPO_PATH}/.git" worktree unlock "${WORKTREE_DIR}" 2>/dev/null || true
    # 请求删除权限后移除
    git worktree remove -f "${WORKTREE_PATH}" 2>/dev/null || true
    # 如果目录仍然存在，force remove
    rm -rf "${WORKTREE_PATH}" 2>/dev/null || true
fi

# 清理 worktree 元数据目录中可能残留的锁文件
METADATA_DIR="${REPO_PATH}/.git/worktrees/${WORKTREE_DIR}"
rm -f "${METADATA_DIR}/index.lock" 2>/dev/null || true
rm -f "${METADATA_DIR}/locked" 2>/dev/null || true

# 如果分支已存在（worktree 目录删了但分支还在），删除分支
git branch -D "${FEATURE_BRANCH}" 2>/dev/null || true
```

### 步骤 3.3：创建 worktree（关键：--no-checkout）

**这是核心改进。** 使用 `--no-checkout` 跳过文件检出，避免 VM 超时：

```bash
cd "${REPO_PATH}"
git worktree add --no-checkout -b "${FEATURE_BRANCH}" "${WORKTREE_PATH}" master
```

此命令仅创建：
- worktree 目录（空的，无检出文件）
- `.git` 文件指向主仓库元数据
- 新分支 `feature/${DEVELOPER}/${BRANCH}` 指向 master 的 HEAD commit

**秒级完成，不会超时。**

### 步骤 3.4：修复 .git 文件中的沙箱路径

git 在沙箱中执行时，会将 `.git` 文件内容写为沙箱路径（如 `gitdir: /sessions/vibrant-admiring-newton/mnt/kunlun-dolphinscheduler/.git/worktrees/...`）。此路径在 Windows 端无效，必须改为相对路径：

```bash
# 构造相对路径
# worktree 位于 D:\Develop\kunlun-dolphinscheduler-{BRANCH}
# 主仓库位于 D:\Develop\kunlun-dolphinscheduler
# 相对路径: ../kunlun-dolphinscheduler/.git/worktrees/{WORKTREE_DIR}
RELATIVE_GITDIR="gitdir: ../kunlun-dolphinscheduler/.git/worktrees/${WORKTREE_DIR}"
printf '%s\n' "${RELATIVE_GITDIR}" > "${WORKTREE_PATH}/.git"
```

### 步骤 3.5：清理元数据目录中的锁文件

`--no-checkout` 创建的 worktree 元数据目录中可能残留 `index.lock`（来自之前中断的 checkout 操作）。此文件会阻塞用户端后续的 `git reset --hard HEAD`，必须清理：

```bash
rm -f "${REPO_PATH}/.git/worktrees/${WORKTREE_DIR}/index.lock" 2>/dev/null || true
rm -f "${REPO_PATH}/.git/worktrees/${WORKTREE_DIR}/locked" 2>/dev/null || true
```

## 错误处理

| 场景 | 处理方式 |
|------|----------|
| 主仓库未挂载 | `request_cowork_directory` 申请 `D:\Develop\kunlun-dolphinscheduler` |
| `D:\Develop` 未挂载 | `request_cowork_directory` 申请 `D:\Develop` |
| `git checkout master` 因 packed-refs 损坏失败 | 用 `printf` 重写 `.git/packed-refs`（剔除 NUL 字节），或用 `git pack-refs --all` 重建 |
| 本地有未提交修改导致 checkout 失败 | 提示用户先 `git stash` 或提交 |
| `git pull` 因网络受限失败 | 提示用户在 Windows 终端手动执行，完成后告知继续 |
| worktree 目标路径已存在 | 解锁 → 清理锁文件 → `git worktree remove -f` → 必要时 `rm -rf`（需先 `allow_cowork_file_delete`） |
| 分支已存在 | `git branch -D` 删除后重建 |
| worktree 处于 locked 状态 | `git worktree unlock` 清理 `locked` 文件后重试 |
| `git worktree remove` 报 Operation not permitted | 调用 `allow_cowork_file_delete` 申请权限后重试 |
| 用户端 `git reset --hard` 报 `index.lock` 已存在 | 检查步骤 3.5 是否执行，确保 `index.lock` 已清理 |

## 第四步：输出结果并告知用户最后一步

创建成功后，向用户报告：

1. 新分支全名：`feature/{开发人}/{分支名}`
2. worktree 本地路径：`D:\Develop\kunlun-dolphinscheduler-{分支名}`
3. 基于分支：`master`（附带最新 commit 的简短 hash）

**必须明确告知用户最后一步：** 由于 VM 沙箱限制，文件未实际检出。用户需在 Windows 终端执行一条命令完成文件检出：

```
cd D:\Develop\kunlun-dolphinscheduler-{分支名} && git reset --hard HEAD
```

执行后 worktree 即可正常使用，DataGrip 等工具也能正确识别版本控制。

## 附录：为什么这样设计

1. **`--no-checkout`** — VM 沙箱通过 `/sessions/.../mnt/` 挂载访问 Windows 文件系统，写入大量文件（全量 checkout）速度极慢，远超 45 秒超时。`--no-checkout` 仅写元数据，秒级完成。
2. **`.git` 相对路径** — git 在沙箱中运行时写入的路径是沙箱路径，Windows 端无效。必须重写为相对路径（`../kunlun-dolphinscheduler/.git/worktrees/...`），确保两端都能正常使用。
3. **清理 `index.lock`** — 之前中断的 checkout 操作会在 worktree 元数据目录留下 `index.lock`，阻塞后续 git 操作。必须在用户执行 `git reset` 前清理。
4. **`git reset --hard HEAD` 由用户在 Windows 执行** — Windows 本地磁盘 I/O 远快于 VM 挂载层，实际文件检出应该在用户端完成。
