# Tools Skill -- Gotchas

- `latexmk` handles multi-pass compilation automatically -- don't run xelatex/biber manually unless debugging.
- `validate-bib` checks for common issues but doesn't verify that citation keys match the .bib file.
- Journal selection (`/tools journal`) reads journal-profiles.md -- if the target field isn't profiled, results will be generic.
- Commit skill runs `score.py --gate commit`. Once critics have scored, an aggregate below 80 blocks the commit; before that it passes with a notice.
- The lint subcommand is advisory (exit 0 always). It catches grep-able violations; the coder-critic handles judgment calls.
- `upgrade` in this fork is a git merge of the release tag on a branch, never upstream's delete-and-replace of `.claude/` -- that would wipe the Quarto rules and every fork addition. See `.claude/sync-manifest.md`.
- `upgrade` must merge `scripts/` too, or skills call missing gate scripts. Scripts marked "clo-author: infrastructure-fork" carry local Quarto patches; re-apply those patches on top of upstream's new version rather than taking either side whole.
- Never stage `.env`, credentials, or `.claude/state/` files in commits.
