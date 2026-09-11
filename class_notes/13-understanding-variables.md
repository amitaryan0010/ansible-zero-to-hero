# Ansible Variables
- variables are used to store dynamic values (like usernames, package names, IP addresses, or file paths) so you can reuse your playbooks across different environments without hardcoding information.

- Rules
    - Must start with a letter or an underscore. It cannot start with a number.
    - Numbers are allowed in between or at the end
    - only `_` underscore are allowed in between
    - Forbidden: Dashes/hyphens (-), spaces, dots (.), or special characters ($, @, !)
    ```
    # ❌ INVALID NAMES:
    web-port: 80       # Contains a hyphen
    2nd_server: rhel   # Starts with a number
    web port: 80       # Contains a space

    #  VALID NAMES:
    web_port: 80
    server_2nd: rhel
    _backup_path: /opt/backup
    ```

- Ansible uses Jinja2 templating for variables. They must be wrapped in double curly braces: {{ variable_name }}.

- **When to quote variables**
    - If you start a value with {{ variable_name }}, you must quote the whole expression to create valid YAML syntax. If you do not quote the whole expression, the YAML parser cannot interpret the syntax. The parser cannot determine if it is a variable or the start of a YAML dictionary. 

- Refer [Official Documentation](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_variables.html) for more details.

### Where to Define Variables (Scope)
- Ansible variables can be defined in multiple places depending on how wide you want their scope to be. They are grouped into three main categories:
    1. Playbook Level (Play or Task scope): You can define variables directly inside your playbook using the vars keyword:
    ```
    ---
    - name: Variable Example Playbook
      hosts: all
      vars:
        web_package: httpd
        web_port: 80

      tasks:
        - name: Print the port
          ansible.builtin.debug:
            msg: "The web port is {{ web_port }}"
    ```

    2. Inventory / File Level (Best Practice): To keep playbooks clean, variables are usually separated into dedicated directories next to your inventory file:
        - group_vars/: Contains variables applied to a whole group of servers.
            - Example file: group_vars/webservers.yaml → web_port: 80
        - host_vars/: Contains variables unique to a specific single server.
            - Example file: host_vars/centos9.yaml → ansible_user: root

    3. Command Line (Extra Vars): You can override any variable at runtime using the --extra-vars (or -e) flag on the command line:
    ```
    $ ansible-playbook site.yml -e "web_port=8080 web_package=nginx"
    $ ansible-navigator run site.yml --eev web_port=8080
    ```
### Variable Precedence (Who Wins?)
- If you define a variable with the same name in multiple places, Ansible resolves the conflict using a strict hierarchy (from lowest to highest priority):
    - Inventory files (Lowest)
    - group_vars/
    - host_vars/
    - Playbook vars block
    - register variables from tasks
    - Extra vars (-e on CLI) (Highest - Always wins)

- There are more than 20 ways for ansible to decide which value will win the race. Check out [here](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence) for full list.

### Advanced Variable Features
- Registered Variables (register)
    - You can capture the output of a task into a temporary variable and use it in a later task:
    ```
    - name: Check if a file exists
      ansible.builtin.stat:
        path: /etc/httpd/conf/httpd.conf
      register: httpd_conf_file

    - name: Print file status
      ansible.builtin.debug:
        msg: "File exists status is {{ httpd_conf_file.stat.exists }}"
    ```

- Ansible Facts
    - Whenever a playbook starts, it runs a hidden task called Gathering Facts. This retrieves real-time infrastructure data from the target machine (like network setups, OS type, and RAM details) and stores them in automatic variables:
        - {{ ansible_hostname }} → Returns host system name (e.g., rhel-9).
        - {{ ansible_os_family }} → Returns OS family (e.g., RedHat or Debian).

# DEMO
1. Variable at Play Level:
    - run [07_vars_list_demo.yaml](../LAB/07_vars_list_demo.yaml), in this file, we have list of variables defined at play level and will be parse to taks within in same level.
    