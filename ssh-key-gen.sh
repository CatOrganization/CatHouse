# https://help.ubuntu.com/community/SSH/OpenSSH/Keys

mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa

ssh-copy-id <username>@<host>