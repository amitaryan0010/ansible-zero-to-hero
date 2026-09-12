## Magic Variables
- We can access information about Ansible operations, including the Python version being used, the hosts and groups in inventory, and the directories for playbooks and roles, using [magic variables](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_vars_facts.html#information-about-ansible-magic-variables). Like connection variables, magic variables are Special Variables. Magic variable names are reserved, check the list [here](https://docs.ansible.com/projects/ansible/latest/reference_appendices/special_variables.html#special-variables)

- The most commonly used magic variables are hostvars, groups, group_names, and inventory_hostname
    -  hostvars (Access data from other hosts): This is arguably the most powerful magic variable. It allows you to look up facts or variables belonging to a completely different machine in your inventory.
        - Use Case: Configuring a load balancer that needs to automatically list the IP addresses of all your web servers.
        - Syntax: {{ hostvars['centos9']['ansible_facts']['default_ipv4']['address'] }}
    - groups: A dictionary containing all hosts in the inventory, sorted by their inventory groups (e.g., {{ groups['dbservers'] }} returns a list of all database host strings).
    - group_names: A list of all groups that the current host belongs to. Excellent for conditional switches:
    - inventory_hostname: The exact name string of the current host as defined inside your hosts file (independent of what the system's actual hardware hostname fact says).