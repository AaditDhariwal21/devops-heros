Session 5 - git

Task 1 was comparing git commit -m with git commit -a -m, task 2 was creating commits
on main, branching, and cherry-picking one commit back into main. Screenshots and my
explanations are in git-tasks.md. Scripts are task1.sh and task2.sh. I ran them in a
throwaway git init repo instead of this one so I didn't fill the real history with
test commits.

What I learned:

-a only stages files git already tracks. My new file stayed untracked even after
commit -a -m, so -a is not the same as add everything. Plain -m just commits what's
already staged.

Cherry-pick copies one commit to another branch, it doesn't move it. The hash changed
(2c2615d became d11f82d) because it's a new commit with the same changes. The other
two commits on the branch stayed where they were.
