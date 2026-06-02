# Project Rules for AI Agents

1. Disregard the folder misc - it is an old historical leftover/backup.
2. Do not commit/push to the repo without my explicit permission.
3. This is my live NixOS config, please be very careful with it.
4. NEVER create a git commit (even locally) without the user explicitly saying "Please commit this" (or equivalent) in the current conversation. This is a *live* NixOS configuration running on the user's actual machine. Unauthorized commits risk putting untested, incomplete, or broken changes into the git history that could later be applied to the running system. Always treat commits as high-risk operations here.
5. When adding or modifying comments in configuration files, keep them self-contained and explain the reasoning directly in the comment itself. Never reference external documents, plans, sessions, scans, step numbers, or dates (e.g. "2026 perf scan", "see the plan", "A2", "H1"). Future readers (including the author a year later) will not have that context.
