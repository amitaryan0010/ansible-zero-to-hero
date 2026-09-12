# Managing facts
- Facts are variable that are automatically gathered by the Ansible.
- It allows you to dynamically discover, customize, and utilize system properties from your target nodes.
- By default, when a playbook starts, Ansible executes the setup module to gather system variables (IP addresses, OS versions, disk layout, memory, etc.) known as Ansible Facts.

### Viewing Available Facts
- To see every piece of system data Ansible automatically collects from a host, you can run an ad-hoc command in your terminal:

        $ ansible localhost -m setup

### Turning Off Fact Gathering
- Gathering facts takes time. If your playbook doesn't need system details (e.g., you are just creating a user with hardcoded data), you can speed up execution by disabling it:
    ```
    - name: Playbook with facts turned off
      hosts: all
      gather_facts: no  # <-- Disables automatic discovery
    ```

###  Custom Facts (Local Facts)
- You can define your own static or executable custom facts on a target machine. Ansible will automatically inject them into the boot tracking registry.
- Where to place them: 
    - On the target machine, create a directory at /etc/ansible/facts.d/.
    - File Format: Create a file ending in .fact (can be INI format or JSON format).

- Example (/etc/ansible/facts.d/info.fact)
    ```
    [ansible_training]
    trainer: path4cloud
    mode: online
    target: zero-to-hero
    ```
- Demo:
    - copy this [info.fact](../LAB/info.fact) file to any target node under `/etc/ansible/facts.d/` (if facts.d directory is not there then create it)
        ```
        $ ansible centos9 -b -a "mkdir -p /etc/ansible/facts.d"

        $ ansible centos9 -m copy -a "src=info.fact dest=/etc/ansible/facts.d/"

        $ ansible centos9 -b -a "ls -l /etc/ansible/facts.d"
        ```

    - Verify the facts
        ```
        $ ansible centos9 -m setup | grep -A5 -w ansible_local
                "ansible_local": {
                    "info": {
                        "ansible_training": {
                            "mode": "online",
                            "target": "zero-to-hero",
                            "trainer": "path4cloud"
        ```

    - When we need, we can callout those variables.
        - check this playbook [20-custom_facts.yaml](../LAB/20-custom_facts.yaml)
        
### Setting Facts Dynamically (set_fact)
- You can create or modify variables mid-playbook based on task outputs or inline logic using the ansible.builtin.set_fact module:
    ```
    - name: Calculate value on the fly
      ansible.builtin.set_fact:
        is_rhel_system: "{{ ansible_facts['os_family'] == 'RedHat' }}"
        backup_folder: "/opt/backup/{{ ansible_facts['date_time']['date'] }}"
    ```
    