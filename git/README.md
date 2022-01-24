Date: 2022-01-23
The following points are learned when setting up the git+github

## [linux-arch]
The installation of git is normal with the usage of distro's repo.
This git can do basic version controlling without any extensions or something, but if we want to use this in association with the services like github, gitlab etc we need to authenticate the client with those services, previously with the github we provide username and password, but currently it is messed up with PAT(personal authenication token) or something, so there is an extension for this released by the Microsoft and It is called as GCM(git credential manager)
link: https://github.com/microsoft/Git-Credential-Manager-for-Windows
This needs to be installed as per the instruction provided in the description (please go through each one)

### Problem Faced: 
After installing the git and GCM as per the instruction faced with the fatal error 255 when trying to clone a private repo from my user account.
The error states: fatal: helper error (255): Default font family name can't be null or empty.
### Solution: 
When we try to clone some private repo or push to some secure repo the git will communicate with the GCM to get the action authenticated, this GCM was developed by the microsoft and it is looking like a C# based application, and so the error might be with the unavailablity of ms-fonts.
It was suggested in the link: https://github.com/AvaloniaUI/Avalonia/issues/4427 to install the AUR package named "ttf-ms-fonts" and it fixed the issue.

## [windows]
With the windows installation the GCM is packaged along with the Git Bash installer so there is no need to follow above mentioned steps for setting up the files 
