Start a QA testing session for test case TC-$ARGUMENTS.

Steps:
1. Read `QA_TEST_PLAN.md` and find the section for TC-$ARGUMENTS to get the test case title and all sub-cases.
2. Determine the branch name using format: `fix/tc-<number>-<short-description>` where `<short-description>` is a lowercase kebab-case version of the TC title (e.g., TC-3 "Accounts" becomes `fix/tc-3-accounts`).
3. Run `git checkout dev && git pull` to get the latest dev branch.
4. Create and checkout the new branch: `git checkout -b fix/tc-<number>-<short-description>`.
5. Print the full list of test cases for this TC so the user knows what to test.
6. Tell the user: "Ready to test TC-$ARGUMENTS. Report any bugs you find and I'll fix them on this branch. When done, run `/qa-finish` to merge into dev."
