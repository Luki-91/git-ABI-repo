---
geometry: margin=25mm
colorlinks: True
colorurl: red
---

## git clone link_to_repo

command for cloning an online repository. Need to add the address from github after the command. Sets the local repository to the newest snapshot of the one copied from the internet and sets the working directory as well. Need to still use cd to enter the working directory.

## git add file1

allows to add file1 (or more, file1 file2 file3 works) to the staging area. Then the file can be comitted in the next step. 

## git status

allows to check the status of the current repository - how many changed files are being tracked, how many are in staging area, what is their names, etc.

## git commit -m "Commit message"

Commits the changes into the local repository. The message is required to commit the changes. The message will also be seen in the github for example, so it is best to make it descirptive so you can remember which changes were done in this commit.

## git push

pushes the commited changes to the online repository that it was derived (cloned) from. Will ask for username (github username) and password (use token, not github password).

## git mv oldfilename newfilename

mv is the command that allows to move a file, and allows to assign a new name, thereby basically renaming. However, just using the mv command will create a new file, therefore git won't back it up anymore. So if you use git mv, the file will still be connected to the old one, as the change is added as a rename and automatically put into the staging area

## git checkout -b branchname

creates a new branch that will be also activated

## git rm filename
removes a file in repository

## git log
returns all the commits saved of the currently active repository along with the unique identifier of the commit and the commit message, the date etc.

