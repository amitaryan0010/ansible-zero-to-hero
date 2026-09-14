# Ansible Conditions
- Ansible conditionals allow you to control whether a task runs or is skipped based on specific criteria, variables, or system properties. The primary keyword used for conditionals in Ansible is `when`.
- Few Evaluating Examples:
    - Basic Conditionals
        ```
        when: environment_type == "staging"  # Runs ONLY if environment_type equals staging
        ```
    - Fact-Based Conditionals
        ```
        when: ansible_facts['os_family'] == "RedHat"
        ```
    - Multiple Conditions (AND / OR Logic)
        ```
        when:
          - ansible_facts['distribution'] == "CentOS"
          - ansible_facts['distribution_major_version'] == "9"

        when: ansible_facts['os_family'] == "RedHat" or ansible_facts['os_family'] == "Debian"


        ## Grouping both
        when: >
            ( ansible_facts['distribution'] == "CentOS" and ansible_facts['distribution_major_version'] == "9")
            or
            ( ansible_facts['distribution'] == "RedHat" and ansible_facts['distribution_major_version'] == "9")
        ```
    - Evaluating Task Results (Registered States)
        ```
        - ansible.builtin.stat:
            path: /etc/nginx/nginx.conf
          register: nginx_conf

        - ansible.builtin.service:
            name: nginx
            state: started
          when: nginx_conf.stat.exists == true
        ```
    - Loop Conditionals (Evaluating loop items)
        ```
        - name: Create users, but skip system accounts
          ansible.builtin.user:
            name: "{{ item.name }}"
            state: present
          loop:
            - { name: 'sam', type: 'user' }
            - { name: 'root', type: 'system' }
          when: item.type == "user"  # Skips 'root', executes for 'sam'
        ```

- The following operations/operators can be used while working with conditions:

| Operation Type | Description | Operator | Markdown Syntax Example (`when: ...`) |
| :--- | :--- | :---: | :--- |
| **String Equal** | Matches exact text string characters. | `==` | `deployment_env == "production"` |
| **String Not Equal** | Evaluates true if text strings mismatch. | `!=` | `app_status != "maintenance"` |
| **Numeric Equal** | Evaluates exact math integers or floats. | `==` | `ansible_facts['processor_vcpus'] == 4` |
| **Numeric Greater Than** | True if number is higher than target. | `>` | `ansible_facts['memtotal_mb'] > 8192` |
| **Numeric Less Than** | True if number is lower than target. | `<` | `free_disk_space_gb < 10` |
| **Greater Than or Equal** | True if number is higher or exactly equal. | `>=` | `ansible_facts['distribution_major_version'] >= 9` |
| **Contains (In List)** | Checks if text exists inside a collection. | `in` | `"webservers" in group_names` |
| **Does Not Contain** | True if text is missing from a collection. | `not in` | `"production" not in group_names` |
| **Boolean True** | Validates if a flag is active. | *None* | `output.stat.writeable` |
| **Boolean False** | Validates if a flag is inactive. | `not` | `not output.stat.exists` |

- Demo
    - For simple when condition, check this playbook [31-ansible_simple_when.yaml](../LAB/31-ansible_simple_when.yaml)
    - For Ansible fact with condition, check this playbook [32-ansible_fact_when.yaml](../LAB/32-ansible_fact_when.yaml)

## Combining Loops And Conditions
- When you combine loop and when in the same Ansible task, the conditional check is evaluated separately for every single iteration in the loop.
- Ansible does not skip the entire task if the condition fails. Instead, it inspects each item one by one: it executes the task for items that evaluate to true, and cleanly skips items that evaluate to false.
- Core Execution Flow

           Looped Task Runs
              │
              ├──> Item 1: Does it match the 'when' condition?
              │       ├──> YES: Execute the module action for Item 1.
              │       └──> NO:  Skip Item 1 and mark status as "skipped".
              │
              └──> Item 2: Does it match the 'when' condition?
                      └──> ... (Repeats for all remaining items)

- For Ansible fact with loop and condition, check this playbook [33-ansible_loop_when.yaml](../LAB/33-ansible_loop_when.yaml)

## Condtion on basis of previous command output
- Let say, we want to execute the next task only when the previous task is executed successfully and then basis of condition, I want to execute the next task.
- check this playbook [34-ansible_rc_when.yaml](../LAB/34-ansible_rc_when.yaml)