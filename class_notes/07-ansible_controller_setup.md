✅ Please follow the below steps to configure the ansible master/controller node

1) Create a dedicated user for ansible, I am using ansibleuser and this user must have a sudo privileges.
2) SSH connection to be there between controller node and targeted nodes
3) Python must be there on all nodes.
4) If using hostname then name resolution via DNS or /etc/hosts file.
5) Create inventory file on controller node and ansible.cfg file for default configurations and parameters.

✅ My LAB Setup

- Controller Node: 
    - running on RHEL9 and registered to REDHAT CDN with Developer Subscription.
    - ansible-core [2.14.18] installed
    - ansible-navigator [] installed
    - Container Image repositories configured and logged in
    - Updated the /etc/hosts file of all servers with IP and hostname for all servers to connect with hostname if required, else IP is suffice to work

- Managed Node:
    - Ubuntu [24.04]
        - ssh service is running ($ systemctl status ssh) (and if any firewall then should be allowed)
        - python is installed ($ sudo dpkg --get-selections python3)
    - CentOS [centos9]
        - ssh service is running ($ systemctl status sshd) (and if any firewall then should be allowed)
        - python is installed ($ sudo rpm -qa python3)


- User to connect with managed hosts:
    - ansibleuser (keybased authentication and added to sudo privileges)

## DEMO
1) Login with root and then create a new user on ansible control node:
    ```
    # useradd ansibleuser
    # passwd ansibleuser
    # su - ansibleuser (switching to a new user)
    # ssh-keygen (creating a SSH KEY)
    # cp id_rsa.pub authorized_keys (copy the public key for ansibleuser to make the password less connection at localhost)
    ```
2) Clone the repo under ansibleuser home directory:
    ```
    "as asibleuser"
    $ git clone https://github.com/amitaryan0010/ansible-zero-to-hero.git

    "as root user"
    Copy the "ansibleuser" file from cloned repo to /etc/sudoers.d/ (with root)
    # cd /home/ansibleuser/ansible-zero-to-hero/setup_files/ 
    # cp ansibleuser /etc/sudoers.d/

    Note: If you have another user then replace the "ansibleuser" with your username
    # sed -i "s|ansibleuser|<new_user>|g" ansibleuser
    ```

3) Copy and rename the anisble.cfg file to ansibleuser home directory as ansible.cfg (hidden file)
    ```
    "as asibleuser"
    $ cd ansible-zero-to-hero/setup_files
    $ cp ansible.cfg /home/ansibleuser/.ansible.cfg
    (change the remote_user, if you have created an another user in step2)

4) Create the inventory file under ansibleuser home directory and update with your target hostname or IP:
    ```
    $ touch inventory
    Update the target node
    $ cat inventory
    localhost
    
    [target_node]
    centos9
    docker
    ```


5) Now, run the playbook ansibleuser.yaml from ansibleuser home directory. This playbook prompt for username, provide the user as "ansibleuser" (OR, if you have created another user then provide the same username)
    ```
    Note: If you have another user which is already present in target node and have sudo privilege then at line num 20, replace the "path4cloud" user to an user which is already present in targer hosts.

    Set the config file as environment variable for default config.
    $ export ANSIBLE_CONFIG=/home/ansibleuser/.ansible.cfg

    To make this persistant, add an entry in .bashrc profile of this user.
    echo "export ANSIBLE_CONFIG=/home/ansibleuser/.ansible.cfg" >> .bashrc

    Verfiy the default config file:
    $ ansible --version

    Now, run the playbook from setup_files directory, it will ask the password for ansible user twice here, -k to ssh, -K to become sudo:
    $ cd ansible-zero-to-hero/setup_files/ 
    $ ansible-playbook ansibleuser.yaml -k -K 
    ```
    ![alt text](../images/setup1.png)

    ![alt text](../images/setup2.png)
6) Check the new user is working with privilege access or try to ping as adhoc command:
    ```
    $ ansible all -m ping
    
    (here docker is my managed host and already mentioned in inventory file, you can change it to your name. -b is used to become the sudo if you have false set for become in config file))
    $ ansible docker -b -a "mkdir /root/testdir" 

    $ ansible all -m command -a whoami 
    (Here, it will show as root, but to follow best practices - change "become = true" to "become = false" in .ansible.cfg file under user home directory and set it true explicity in playbook whereever its required.)
    ```
    ![alt text](../images/setup3.png)

## Another method to set the user for ssh
- A Quick Setup using ansible only, if you have a user present on target node with sudo privilege
- On master node:
    ```
    $ ansible -i inventory all -u <remote_user> -k -b -K -m user -a "name=<user_name> state=present create_home=yes"
    (here -u remote_user is which is already present on target node, and user_name with useradd command is the user which you want to create on target node)

    $ ansible -i inventory <linux_host> -u <user_name> -k -b -K -m shell -a "echo <password> | passwd --stdin <user_name>"
    (here, we are setting the password for an user, created in step1 on linux host, we used, shell module, since this standard redirecting won't work with 'command' module)

    (we ran only for Linux Hosts since for Ubuntu, it is a different command to set the password)

    $ ansible -i inventory <ubuntu_host> -u <user_name> -k -b -K -m shell -a "echo <user_name>:<password> | chpasswd"

    (here, we are adding the new user to sudo privilege using copy module)
    $ ansible -i inventory all -u <user_name> -k -b -K -m copy -a 'content="<user_name> ALL=(ALL) NOPASSWD: ALL" dest=/etc/sudoers.d/<user_name>'

    Once done, we can try to ping with new user:
    $ ansible -i inventory all -u <user_name> -k -m ping
    ```    
    I have created sam user for all hosts and tried to ping with sam:
    ![alt text](../images/setup4.png)