#!/bin/bash
# Task 1 - git commit -m vs git commit -a -m

rm -rf demo1 && mkdir demo1 && cd demo1
git init -b main -q
git config user.name "Aadit Dhariwal"
git config user.email "aadit@example.com"

echo "line 1" > file.txt
git add file.txt
git commit -q -m "first commit"
echo "--- starting point ---"
git log --oneline

echo ""
echo "--- now change the tracked file AND make a new untracked file ---"
echo "line 2" >> file.txt
echo "i am new" > newfile.txt
git status --short

echo ""
echo "--- try: git commit -m (nothing was git added) ---"
git commit -m "trying plain -m"

echo ""
echo "--- now: git commit -a -m ---"
git commit -a -m "commit using -a"

echo ""
echo "--- what happened? ---"
git log --oneline
echo ""
echo "status after:"
git status --short
echo "(newfile.txt is STILL untracked - -a did not pick it up)"

echo ""
echo "--- to commit the new file you have to git add it first ---"
git add newfile.txt
git commit -q -m "add newfile.txt"
git log --oneline
git status --short
echo "(clean now)"
