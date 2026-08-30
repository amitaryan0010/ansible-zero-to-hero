## 🧩 [Key Core Concepts](https://docs.ansible.com/projects/ansible/latest/getting_started/basic_concepts.html?extIdCarryOver=true&intcmp=7015Y000003t7aWQAQ&sc_cid=RHCTG0230000220540)
Control node:
- In Ansible, the control node is the central machine where the software is installed and from which all CLI tools, playbooks, and commands are executed.
- It manages the orchestration and configuration of target systems (known as managed nodes or hosts).
- It can be a laptop, a shared desktop, or a dedicated cloud server running Linux or macOS.

Managed nodes:
- In Ansible, a managed node (often called a host) is a target device or server that you want to configure, monitor, or automate.
- Unlike the control node, Ansible does not need to be installed on managed nodes because it operates agentlessly.
- The control node connects to managed nodes over standard protocols like SSH (for Linux/Unix) or WinRM (for Windows) to execute tasks.
- Managed nodes are listed and organized inside your network's inventory file.

Inventory: 
- The inventory is a file where you define the servers (hosts) that Ansible will manage.
- Can be static (INI/YAML file) or dynamic (cloud-based)
- Supports grouping (e.g., web, db)

Playbooks
- A playbook is a YAML file that defines what tasks to run and on which servers.
- It defines the desired state of target hosts, while running a playbook, it compares the current state of target host with described in playbook and if there is a difference, then the current state will be updated.
- Written in YAML
- Executes tasks in order
- Supports variables, loops, conditions

Modules
- Modules are the building blocks that perform actual work for platform-spcific and written in python scripts. Many Modules are available for a different spcific platforms.
- Since Ansible 2.9 version, we manages the module with content collections. Most collections are publicly available via galaxy.ansible.com
- Examples: apt, yum, copy, service
- Each module handles a specific task

Roles
- Roles help organize playbooks into reusable components.
- Structured folders (tasks, handlers, templates, etc.)
- Promote reusability and clean code

Tasks
- A task is a single action in a playbook.
- Each task uses a module
- Executed sequentially

Handlers
- Handlers are special tasks that run only when triggered.
- Used for actions like restarting services
- Triggered using notify

Variables
- Variables allow dynamic and reusable configurations.
- Defined in playbooks, inventory, or separate files
- Improve flexibility

Plugins
- Can be used to add specific functionality to Ansible.
- Plugins extend Ansible’s functionality.
- They are used behind the scenes to control how Ansible behaves and interacts with systems.
        
Common Types of Plugins
1. Connection Plugins
   - Define how Ansible connects to hosts
   - Example: ssh, paramiko
2. Callback Plugins
   - Control output/display of results
   - Example: show logs, format output
3. Lookup Plugins
   - Fetch data from external sources
4. Filter Plugins
   - Transform data using Jinja2 filters
5. Action Plugins
   - Control how modules are executed
   - Work on the control node before sending tasks

## Summary
Ansible works by combining these concepts:

        👉 Inventory → Where to run
        👉 Playbooks → What to run
        👉 Modules → How tasks are executed
        👉 Roles → Organize everything
        👉 Tasks → Individual steps
        👉 Handlers → Triggered actions
        👉 Variables → Dynamic values

## ✅ Ansible Navigator
It is an utility based on a container image (container) and includes a ansible content collections relevant to a specific environments. It is also called an execution environment.



## [ANSIBLE ARCHITECTURE](https://docs.ansible.com/projects/ansible/latest/getting_started/index.html)

                 +---------------------------+
                 |     CONTROL NODE          |
                 |  (Ansible Installed)      |
                 |                           |
                 |  - Playbooks (YAML)       |
                 |  - Inventory              |
                 |  - Roles                  |
                 |  - Modules                |
                 |  - Plugins                |
                 +------------+--------------+
                              |
                              | SSH (Agentless)
                              |
        -------------------------------------------------
        |                     |                         |
        +----------------+   +----------------+     +----------------+
        | MANAGED NODE 1 |   | MANAGED NODE 2 |     | MANAGED NODE 3 |
        | (Linux Server) |   | (Web Server)   |     | (DB Server)    |
        |                |   |                |     |                |
        | - Python       |   | - Python       |     | - Python       |
        | - SSH Access   |   | - SSH Access   |     | - SSH Access   |
        +----------------+   +----------------+     +----------------+


🔹 Simple Flow
Control Node (Ansible) ---> Run Playbook ---> Python Script created for each task ---> SSH connection to ---> Managed Nodes ---> Python Script copied and executed using Python Interpreter --> Tasks Executed

(in case of windows, its `winrm` conection plugin is used to connect to windows machine, and powershell script is created and executed.)



