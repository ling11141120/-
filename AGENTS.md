# KUNLUN-DOLPHINSCHEDULER Project Instructions

## Project-Local Skills

When the current workspace is `kunlun-dolphinscheduler`, treat `AI/skills` as a project-local skill library.

For any user request in this repository:

1. If the user names a skill directly, or the request appears to match a skill's `description`, inspect `AI/skills/*/SKILL.md`.
2. Match skills by the YAML frontmatter fields `name` and `description`.
3. When a project-local skill matches, announce that you are using that project-local skill, then read its `SKILL.md` and follow its workflow.
4. Resolve relative paths mentioned by a skill from that skill's own directory first.
5. Load only the referenced files needed for the current task; do not bulk-load every file under `AI/skills`.
6. If multiple project-local skills match, use the smallest set needed and state the order.
7. If a named project-local skill is missing or malformed, say so briefly and continue with the best available fallback.

These project-local skills supplement the globally registered Codex skills. They may not appear in the session's built-in skill list, but they should still be used by reading their local `SKILL.md` files.
