# TASK Control
- An Ansible loop allows you to repeat a single task multiple times with different values, rather than duplicating the task block over and over.
- In modern Ansible, the universal keyword loop is the standard way to iterate over a list of items, strings, or dictionaries.
- We have many lookup plugins available in ansible which can help to go through or iterate the input or output.
- check out the available lookups

        $ ansible-doc -t lookup -l

    - to check the the particular lookup plugin:

        $ ansible-doc -t lookup items

    - We will discuss the other plugins later, as of now let us focus on `items` which can iterate the list of items and pass it to loop.

    - For example, let say, we need to create a bunch of users, we know, we can use `users` module to achieve the same, or to install number of packages via `dnf` or other OS specific modules, or need to start/check the status of services but we need to write the dedicated task for each user creation/package install/service stattus and that is where the actual problem starts. Now, the playbook will be messy, error prone, hard to manage. So we use a `loop` with `with_items`.
- loop vs Legacy with_items
    - You might see older playbooks using keywords like with_items, with_dict, or with_sequence. While they still work, loop is the modern best practice.Use loop for simple lists and list variables.

- Task control with loops 
    - It allows you to manage and track individual loop iterations by pairing structural loop declarations with keywords like loop_control, register, and ignore_errors.
    - By default, when looping through a large list, Ansible's terminal output can become messy, tracking variables can get overwritten, and a single loop item failure will crash the entire task. Task control properties resolve these challenges.

-  Simple List Loop (Looping over Strings)
    - The most basic loop takes a simple flat list. During execution, Ansible automatically assigns the current value to a special variable named item.
        ```
        - name: Ensure multiple packages are installed
          ansible.builtin.dnf:
            name: "{{ item }}"
            state: present
          loop:
            - httpd
            - mariadb-server
            - git
        ```

- Complex Loop (Looping over Dictionaries)
    - When you need to pass multiple parameters per iteration (like a username and their group membership), you pass a list of key-value dictionaries. You access the keys using dot notation `(item.key_name)`.
        ```
        - name: Create multiple users with distinct groups
        ansible.builtin.user:
          name: "{{ item.username }}"
          groups: "{{ item.group_name }}"
          state: present
        loop:
            - { username: 'sam', group_name: 'wheel' }
            - { username: 'alice', group_name: 'developers' }
            - { username: 'bob', group_name: 'webmasters' }
        ```
-  Looping over a Variable List
    - Instead of hardcoding items directly inside the task, you can pass a variable containing a pre-defined list:
        ```
        vars:
          system_services:
            - firewalld
            - httpd

        tasks:
          - name: Ensure services are running
            ansible.builtin.service:
              name: "{{ item }}"
              state: started
            loop: "{{ system_services }}"
        ```

### DEMO
- For simple list loop, check this playbook [24-simple_list_loop.yaml](../LAB/24-simple_list_loop.yaml)

- For dictionary loop, check this playbook [25-simple_dictionary_loop.yaml](../LAB/25-simple_dictionary_loop.yaml)
