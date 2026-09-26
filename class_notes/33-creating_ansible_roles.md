## Creating Roles
- To create a new Ansible role with the standard directory structure, use the built-in ansible-galaxy CLI tool.

- We can verify the roles default path and if required we can modify it.
```
$ ansible-config dump | grep -i roles
DEFAULT_ROLES_PATH(default) = ['/home/ansibleuser/.ansible/roles', '/usr/share/ansible/roles', '/etc/ansible/roles']
```

- The `ansible-galaxy role init` command does not read your `DEFAULT_ROLES_PATH` to decide where to create a new role. By default, it always creates the role folder right inside your current working directory (wherever your terminal prompt is currently sitting).
- The `DEFAULT_ROLES_PATH` configuration from dumped is a search path used exclusively when running playbooks or installing external roles from the internet, not for initializing new blank roles locally.

```
$ pwd
/home/ansibleuser

$ ansible-galaxy role init path4cloud.demorole
- Role path4cloud.demorole was created successfully

$ ls -ld path4cloud.demorole
drwxr-xr-x. 10 ansibleuser ansibleuser 135 Sep 26 04:28 path4cloud.demorole

$ tree path4cloud.demorole/
path4cloud.demorole/
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml

8 directories, 8 files
```
- How to force ansible-galaxy to create it in your roles path:
    - If you want the role to be generated automatically inside one of your configured global search paths (like /home/ansibleuser/.ansible/roles), you must explicitly pass the path using the `--init-path` flag.
```
$ ansible-galaxy role init path4cloud.demorole --init-path=/home/ansibleuser/.ansible/roles
- Role path4cloud.demorole was created successfully

$ ansible-galaxy list
# /home/ansibleuser/.ansible/roles
- path4cloud.demorole, (unknown version)
```
### How to make Ansible find your custom role if `--init-path` is not used
You have two primary ways to make sure Ansible recognizes and runs your new role in playbooks:
- Method 1: Keep it next to your Playbook (Best Practice)
    - In production, you usually want your roles inside your specific project directory. Simply structure your project like this:
    ```
    my-project/
    ├── 68-rhel_role_timesync.yaml   # Your playbook
    └── roles/
        └── path4cloud.demorole/     # Move your created role folder here
    ```
    - When you run a playbook, Ansible automatically checks the local roles/ directory relative to the playbook file first.

- Method 2: Configure the global path in ansible.cfg
    - If you want to keep all your custom roles in a specific centralized directory (e.g., /home/ansibleuser/roles), tell Ansible where to look by updating your ansible.cfg file:
    ```ini
    [defaults]
    roles_path = /home/ansibleuser/roles:/usr/share/ansible/roles
    ```
    - Once you add your custom path to roles_path and run `ansible-galaxy list`, your `path4cloud.demorole` will show up cleanly at the bottom of the list.

## Standard guidelines for role content development
Developing clean, modular, and maintainable Ansible roles requires adherence to industry best practices. Structuring content cleanly ensures roles remain **idempotent, reusable**, and easy for team members to debug.
1. Enforce Strict Idempotency
    - A role must be able to run multiple times against the same host without changing configurations or restarting services unless an actual change occurred.
        - Avoid ansible.builtin.shell or command unless necessary: Standard modules (like ansible.builtin.package, file, or template) are natively idempotent. If you must use a shell command, always use creates or removes arguments to skip execution if the state already exists.
        - Control Service Restarts via Handlers: Never use a direct task to restart a service. Always use notify to point to a handler so the service restarts only if a configuration file changes [Ansible Playbook Sequence Example].

2. Leverage Variable Precedence Correctly
    - Ansible provides separate folders for variables (defaults/ vs vars/). Utilize them to make your roles flexible:
        - defaults/main.yml (Low Priority): Put every variable that a user might want to change here. Use clear, human-readable defaults (e.g., apache_port: 80).
        - vars/main.yml (High Priority): Hardcode internal constants that should never be altered by the user running the playbook (e.g., OS-specific package names or internal application paths).
        - Namespace your variables: Always prefix your variables with the role name to prevent namespace collisions (e.g., use demorole_install_path instead of just install_path).

3. Keep Tasks Small, Monolithic, and Readable
    - Avoid writing massive, long files inside tasks/main.yml.
        - Break up workflows: Use ansible.builtin.import_tasks or include_tasks to split large roles into logical sub-files (e.g., install.yml, configure.yml, secrets.yml) [Static importing (import_*) in Ansible, Real-Time Scenario: Reusing Large, Linear Configuration Blocks].
        - Always name your tasks: Provide descriptive, action-oriented strings for the name: attribute of every single task to make playbook tracking clear.

4. Separate Code from Data (Templates vs Files)
    - Use the files/ directory strictly for static, unchanging objects (e.g., a static corporate background image or a fixed repo file).
    - Use the templates/ directory with Jinja2 (.j2) extensions for files that change dynamically based on target host specs or variables (e.g., configuration files pulling distinct memory or IP settings) [Standard Directory Structure of a Role].

5. Standardise Error Handling with Blocks
    - Wrap risky blocks of tasks (like API interactions or database updates) inside a block structure to catch failures gracefully.
    ```yaml
    - name: Database Configuration Block
      block:
        - name: Import initial database schema
          ansible.builtin.mysql_db:
            name: prod_db
            state: import
      rescue:
        - name: Alert team on failure
          ansible.builtin.debug:
            msg: "Database migration failed! Rolling back changes..."
    ```

6. Document with meta/main.yml and README.md
    - If you share your role or look at it six months from now, documentation is vital.
        - Complete the fields in meta/main.yml to specify supported platforms (e.g., RHEL 9, Ubuntu 22) and upstream role dependencies.
        - Maintain a standard README.md file listing all required input variables, expected parameters, and a basic sample playbook layout [Standard Directory Structure of a Role].

## DEMO
```
$ pwd
/home/ansibleuser/.ansible/roles/path4cloud.demorole

$ tree -F .
.
├── defaults/
│   └── main.yml
├── files/
├── handlers/
│   └── main.yml
├── meta/
│   └── main.yml
├── README.md
├── tasks/
│   └── main.yml
├── templates/
│   └── index.j2
├── tests/
│   ├── inventory
│   └── test.yml
└── vars/
    ├── Debian.yml
    ├── main.yml
    └── RedHat.yml

8 directories, 11 files
```
- Refer this [directory](../LAB/path4cloud.demorole/) and copy the below files to your custom role:
    - [RedHat.yml](../LAB/path4cloud.demorole/vars/RedHat.yml) to `vars/RedHat.yml`
    - [Debian.yml](../LAB/path4cloud.demorole/vars/Debian.yml) to `vars/Debian.yml`
    - [handlers/main.yml](../LAB/path4cloud.demorole/handlers/main.yml) to `handlers/main.yml`
    - [templates/index.j2](../LAB/path4cloud.demorole/templates/index.j2) to `templates/index.j2`
    - [tasks/main.yml](../LAB/path4cloud.demorole/tasks/main.yml) to `tasks/main.yml`
- Run this playbook [69-my_custom_roles](../LAB/69-my_custom_roles.yaml), which will refer to this custom roles.

```
$ ansible-playbook 69-my_custom_roles.yaml
```

![alt text](../images/custom_role.png)

- verify
```yaml
$ ansible docker -m uri -a "url=http://localhost return_content=true"
docker | SUCCESS => {
    "accept_ranges": "bytes",
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "connection": "close",
    "content": "Welcome to DOCKER!! running on Ubuntu 24.04 and deployed via custom roles.\n\nMy FQDN is docker.path4cloud.com.\n",
    "content_length": "110",
    "content_type": "text/html",
    "cookies": {},
    "cookies_string": "",
    "date": "Sat, 26 Sep 2026 00:13:50 GMT",
    "elapsed": 0,
    "etag": "\"6e-65c577dfa9359\"",
    "last_modified": "Fri, 25 Sep 2026 23:58:25 GMT",
    "msg": "OK (110 bytes)",
    "redirected": false,
    "server": "Apache/2.4.58 (Ubuntu)",
    "status": 200,
    "url": "http://localhost",
    "vary": "Accept-Encoding"
}
```