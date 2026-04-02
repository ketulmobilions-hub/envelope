Finish the current QA testing session and merge fixes into dev.

Steps:
1. Verify we are on a `fix/tc-*` branch (if not, tell the user and stop).
2. Check `git status` — if there are uncommitted changes, warn the user and stop.
3. Check `git log dev..HEAD --oneline` to show what commits will be merged.
4. Run: `git checkout dev && git pull && git merge --no-ff -` to merge the fix branch into dev.
5. Delete the fix branch: `git branch -d <branch-name>`.
6. Print a summary of what was merged.
