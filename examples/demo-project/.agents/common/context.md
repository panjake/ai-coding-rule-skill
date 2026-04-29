## Project Map Maintenance

Use `.agents/common/context.md` as a navigation-first project map.

Write for model execution, not for human storytelling.

### Hard Rules

- Keep only stable shared facts.
- Prefer navigation over explanation.
- Prefer reading order over exhaustive directory dumps.
- Prefer code-backed facts over assumptions.
- Keep personal progress, temporary findings, and task-local notes out of this file.
- If code and memory conflict, trust code and update the map.
- If something is uncertain, mark it under knowledge boundaries instead of guessing.

### Required Sections

Keep these sections only:

- Project positioning
- Module map
- Dependency direction
- Entry points and runtime
- Recommended reading order
- Core business domains
- Knowledge boundaries

### Optional Sections

Add only when they materially help future sessions:

- Configuration hotspots
- External integrations
- Testing reality
- One high-risk core domain map

### Length Control

- Each section should usually stay within 3-8 bullets.
- Do not describe every directory.
- Do not describe every business feature.
- Expand only the one or two highest-risk domains.
- If a section becomes long, compress it into:
  - what it is
  - where to read
  - what to avoid misunderstanding

# Demo Context

This file exists only as a minimal target for testing context injection.
