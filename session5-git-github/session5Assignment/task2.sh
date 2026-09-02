#!/bin/bash
# Task 2 - cherry-pick

rm -rf demo2 && mkdir demo2 && cd demo2
git init -b main -q
git config user.name "Aadit Dhariwal"
git config user.email "aadit@example.com"
git config core.autocrlf false

# 3 commits on main
echo "commit 1 stuff" > a.txt && git add . && git commit -q -m "main: add a.txt"
echo "commit 2 stuff" > b.txt && git add . && git commit -q -m "main: add b.txt"
echo "commit 3 stuff" > c.txt && git add . && git commit -q -m "main: add c.txt"

echo "--- git log on main ---"
git log --oneline

echo ""
echo "--- make a new branch and switch to it ---"
git checkout -b feature
git branch

# 3 commits on feature
echo "feature work 1" > f1.txt && git add . && git commit -q -m "feature: add f1.txt"
echo "THE ONE I WANT" > important.txt && git add . && git commit -q -m "feature: add important.txt"
echo "feature work 3" > f3.txt && git add . && git commit -q -m "feature: add f3.txt"

echo ""
echo "--- git log on feature ---"
git log --oneline

echo ""
echo "--- find the commit I want to cherry-pick ---"
PICK=$(git log --oneline --grep="important" --format=%h)
echo "the commit is: $PICK"
git show --stat --oneline $PICK | head -4

echo ""
echo "--- go back to main ---"
git checkout main
echo "files on main right now:"
ls

echo ""
echo "--- cherry-pick just that one commit ---"
git cherry-pick $PICK

echo ""
echo "--- verify ---"
echo "git log on main now:"
git log --oneline
echo ""
echo "files on main now:"
ls
echo ""
echo "content of the cherry-picked file:"
cat important.txt
echo ""
echo "note f1.txt and f3.txt did NOT come across - only the one commit did"
