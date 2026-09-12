# Managing Secrets
- When dealing with Ansible secrets, your primary tool is Ansible Vault. It allows you to encrypt sensitive data—such as passwords, API keys, and private keys—directly inside your playbooks, variable files, or files themselves, rather than leaving them in plaintext.

- Let say, we need to add the username and password via ansible, so we can use `user` module to acheive the same.
    ```
    ansible.builtin.user:
        name: "{{ username }}"
        password: "{{ password }}"
        state: present
    ```
- This is technically correct but Linux systems cannot accept plaintext passwords via automated configuration managers like Ansible; they require the password string to already be obfuscated using a specific hashing algorithm (like SHA-512) along with a random string called a "salt".
- So, playbook will run but task will be completed partially with warning and user will be created and password will be stored in plain text in /etc/shadow file. So, we can't login with this user.
    ```
    $ cat /etc/passwd | grep -i sam
    sam:x:1009:1011::/home/sam:/bin/bash

    $ sudo cat /etc/shadow | grep -i sam
    sam:redhat:20708:0:99999:7:::
    ```

    ![alt text](../images/sec1.png)

- So use this password_hash('sha512') which is a built-in Ansible filter that uses your control machine's underlying Python libraries to automatically generate a secure, salted SHA-512 hash string of your password.
    - For this filter to work correctly on your control machine, you must have the passlib Python library installed.
    ```
    check the Python version used by Ansible, if it is default version of your system wide, then use dnf install else, install the passlib using pip.

    $ ansible --version | grep "python version"
    python version = 3.12.14 (main, Aug 13 2026, 00:00:00) [GCC 11.5.0 20240719 (Red Hat 11.5.0-14)] (/usr/bin/python3.12)

    $ alternatives --config python3

    There are 3 programs which provide 'python3'.

    Selection    Command
    -----------------------------------------------
    +   1           /usr/bin/python3.9
        2           /usr/bin/python3.12
    *   3           /usr/bin/python3.13

    (here my system's global environment is configured via alternatives to use Python 3.13 as the default runtime and system's baseline python environment (Python 3.9) but my Ansible using 3.12 so I will force the installation inside the Python 3.12 library ecosystem using pip)

    $ /usr/bin/python3.12 -m pip install --user passlib
    Collecting passlib
    Obtaining dependency information for passlib from https://files.pythonhosted.org/packages/3b/a4/ab6b7589382ca3df236e03faa71deac88cae040af60c071a78d254a62172/passlib-1.7.4-py2.py3-none-any.whl.metadata
    Downloading passlib-1.7.4-py2.py3-none-any.whl.metadata (1.7 kB)
    Downloading passlib-1.7.4-py2.py3-none-any.whl (525 kB)
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 525.6/525.6 kB 1.2 MB/s eta 0:00:00
    Installing collected packages: passlib
    Successfully installed passlib-1.7.4

    If it says "/usr/bin/python3.12: No module named pip", then first install "python3.12-pip"
    $ sudo dnf install python3.12-pip -y

    If using dnf then run this:
    $ sudo dnf install python3-passlib
    ```
- Lets remove this user and this time, create with this filter.
    ```
    ansible.builtin.user:
      name: "{{ username }}"
      password: "{{ password | password_hash('sha512') }}"
      state: present
    ```

    - and this time, tasks completed succssfully, password is hashed and user is able to login.

    ![alt text](../images/sec2.png)

- Demo
    - check this [17-password_filter.yaml](../LAB/17-password_filter.yaml)

#### In above example, password filter helps you to encrypt the password while creating the user but still it is not a good idea to keep the password at playbook level in clear text. So to avoid this kind of situation where we need to secure the passwords, api-keys, ssh-keys or other confidentails parameter,  we put or declare these variables in a dedicated variable files and to secure this we use `ANSIBLE VAULT`.

## Ansible Vault:
- It will encrypt the yaml files which has variables defined using AES256 based encryption.
- We can use `ansible-vault` command to:
    - create              Create new vault encrypted file
    - decrypt             Decrypt vault encrypted file
    - edit                Edit vault encrypted file
    - view                View vault encrypted file
    - encrypt             Encrypt YAML file
    - encrypt_string      Encrypt a string
    - rekey               Re-key a vault encrypted file

- Demo:
    - Lets define the username and password in a separeate yaml file and encrypt that file using ansible-vault.
    - check this file []() where varaibles are defined now.
    - Run this playbook []() as below:
    
