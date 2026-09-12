# Managing facts
- Facts are variable that are automatically gathered by the Ansible.
- It allows you to dynamically discover, customize, and utilize system properties from your target nodes.
- By default, when a playbook starts, Ansible executes the setup module to gather system variables (IP addresses, OS versions, disk layout, memory, etc.) known as Ansible Facts.

- Viewing Available FactsTo see every piece of system data Ansible automatically collects from a host, you can run an ad-hoc command in your terminal:

        $ ansible localhost -m setup