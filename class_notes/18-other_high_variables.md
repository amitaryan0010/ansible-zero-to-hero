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

# include_vars module
- We can load the variable from a file as a module into the play as task.
```
- name: Variables included as a module
  ansible.builtin.include_vars:
    file: my_variable.yaml
```
- In Ansible, you can simulate loading variables from a file into a distinct namespace or "as a module" by using the name parameter inside the ansible.builtin.include_vars module.
```
ansible.builtin.include_vars:
  file: my_variable.yaml
  name: custom_vars
```

- DEMO:
    - check this [14-variable_as_include_module.yaml](../LAB/14-variable_as_include_module.yaml)

# set_fact module
- It is used to create or modify variables dynamically during a playbook's execution.
- Unlike static variables defined in a vars: block, set_fact variables are evaluated at runtime. This means you can calculate their values using other variables, conditional logic, or outputs registered from previous tasks.
```
ansible.builtin.set_fact:
  my_fruit: banana
```
- Demo
    - check this [15-variable_set_fact.yaml](../LAB/15-variable_set_fact.yaml)

# vars_prompt
- The vars_prompt keyword in Ansible is used to interactively prompt the user for input when the playbook starts running. It is highly useful for gathering runtime configurations, confirmations, or sensitive details like passwords without hardcoding them into your files.
```
vars_prompt:
  - name: system_user
    prompt: "Enter the target username"
    private: false
    default: "admin"
```
- Demo
    - check this [16-variable_prompt.yaml](../LAB/16-variable_prompt.yaml)