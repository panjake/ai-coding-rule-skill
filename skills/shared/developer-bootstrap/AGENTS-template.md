# Developer Profile Guide

## Identity

- Current developer profile: `__DEVELOPER_PROFILE__`
- Personal memory directory: `.agents/developers/__DEVELOPER_PROFILE__/`

## Read Order

1. `AGENTS.md`
2. `.agents/common/rules.md`
3. `.agents/common/context.md`
4. `.agents/developers/__DEVELOPER_PROFILE__/AGENTS.md`
5. `.agents/developers/__DEVELOPER_PROFILE__/progress.md`
6. `.agents/developers/__DEVELOPER_PROFILE__/bugs.md`
7. Recent relevant notes under `.agents/developers/__DEVELOPER_PROFILE__/sessions/`

## Write Boundary

- Only read and write `.agents/developers/__DEVELOPER_PROFILE__/`
- Before writing shared facts, confirm whether the change should go through the `.agents/common/` proposal flow
- If code and memory conflict, trust code and record the mismatch in `.agents/developers/__DEVELOPER_PROFILE__/bugs.md` or `sessions/`
