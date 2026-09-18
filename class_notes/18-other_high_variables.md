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
```yaml
- name: Variables included as a module
  ansible.builtin.include_vars:
    file: my_variable.yaml
```
- In Ansible, you can simulate loading variables from a file into a distinct namespace or "as a module" by using the name parameter inside the ansible.builtin.include_vars module.
```yaml
ansible.builtin.include_vars:
  file: my_variable.yaml
  name: custom_vars
```

- DEMO:
    - check this [14-variable_as_include_module.yaml](../LAB/14-variable_as_include_module.yaml)

# set_fact module
- It is used to create or modify variables dynamically during a playbook's execution.
- Unlike static variables defined in a vars: block, set_fact variables are evaluated at runtime. This means you can calculate their values using other variables, conditional logic, or outputs registered from previous tasks.
```yaml
ansible.builtin.set_fact:
  my_fruit: banana
```
- Demo
    - check this [15-variable_set_fact.yaml](../LAB/15-variable_set_fact.yaml)

# vars_prompt
- The vars_prompt keyword in Ansible is used to interactively prompt the user for input when the playbook starts running. It is highly useful for gathering runtime configurations, confirmations, or sensitive details like passwords without hardcoding them into your files.
```yaml
vars_prompt:
  - name: system_user
    prompt: "Enter the target username"
    private: false
    default: "admin"
```
- Hashing values supplied by vars_prompt - [more info](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_prompts.html#hashing-values-supplied-by-vars-prompt)
  - You can hash the entered value so you can use it, for example, with the user module to define a password:
  ```yaml
  vars_prompt:
    - name: my_password2
      prompt: Enter password2
      private: true
      encrypt: sha512_crypt
      confirm: true
      salt_size: 7
  ```
- Allowing special characters in vars_prompt values
  - Some special characters, such as { and % can create templating errors. If you need to accept special characters, use the unsafe option
  ```yaml
  vars_prompt:
    - name: my_password_with_weird_chars
      prompt: Enter password
      unsafe: true
      private: true
  ```
- Demo
    - check this [16-variable_prompt.yaml](../LAB/16-variable_prompt.yaml)