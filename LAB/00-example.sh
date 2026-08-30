# Bash Shell Idempotency Example
#!/bin/bash

#### Echo behavior as idempotent
# echo "Hello!! Welcome to Path4cloud" > idem.txt
# mkdir ansible

#### Echo behavior as non-idempotent
# echo "Hello!! Welcome to Path4cloud" >> non-idem.txt
# mkdir -p ansible

myuser=tom
myuid=2001
myshell=/bin/bash

if [  $(id -u $myuser 2>/dev/null) ]; then
    echo "User $myuser already exists"
else
    useradd -u $myuid -s $myshell $myuser
    echo "User $myuser created successfully"
fi