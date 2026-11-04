# Global instructions

- Never create git commits (or push) yourself, in any repo including ~/.dotfiles. Make the changes, leave them uncommitted, and tell me they're ready. Only commit when I explicitly ask in that turn.
- When I ask a question (e.g. "Can we add X?"), answer it and stop. Don't write files, edit config, or change system state until I explicitly ask you to build it. Read-only investigation to answer accurately is fine.
- When changing config that is tracked in ~/.dotfiles (chezmoi), always mirror the change in the chezmoi source repo too, so the repo and the live file stay in sync. If the file I'm changing isn't tracked there yet, ask me whether to add it to the repo.
