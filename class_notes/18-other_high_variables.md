### In this file, we will try to discuss all other types of modules.

[Variable Precedence](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence)

# vars_files
- We can define the variables in a file and that file can be defined at PLAY LEVEL.
```
vars_file:
  - my_variable.yaml
```
(whatever variable is defined in key:value or list of valyes format that will rendered in tasks in this play)

- DEMO:
    - check this [13-my_file_var.yaml](../LAB/13-my_file_var.yaml)

# include_vars as module
- We can load the variable from a file as a module into the play as task.
```
- name: Variables included as a module
  ansible.builtin.include_vars:
    file: my_variable.yaml
```
- In Ansible, you can simulate loading variables from a file into a distinct namespace or "as a module" by using the name parameter inside the ansible.builtin.include_vars module.