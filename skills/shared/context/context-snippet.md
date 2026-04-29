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

### Initialization Protocol

When the map is missing or too thin, initialize it in this order:

1. Project positioning:
   - what kind of system this is
   - main business purpose
2. Module map:
   - top-level modules that matter
   - one-line responsibility for each
3. Dependency direction:
   - which layer calls which layer
4. Entry points and runtime:
   - web, API, job, command, MQ, cron, worker, or other entry styles
5. Recommended reading order:
   - where a future model should start for common tasks
6. Core business domains:
   - only the major workflows
7. Knowledge boundaries:
   - what is still uncertain

### Quality Check

The project map is good if a future model can answer:

- Where should I start reading for this task type?
- Which module owns the main behavior?
- Which base class, middleware, helper, or framework glue silently owns shared behavior?
- Which external systems or infrastructure can affect this task?
- What is still uncertain and should not be overclaimed?
