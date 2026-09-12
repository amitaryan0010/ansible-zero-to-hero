## Registering variables
- You can create variables from the output of an Ansible task with the task keyword register. You can use the registered variables in any later task in your play.

- varaible created or result captured with register can be called directly with `var` keyword and no need to use {{ }}.
```
ansible.builtin.shell: /usr/bin/ls
    register: ls_result

ansible.builtin.debug:
    var: ls_result
    # var: {{ ls_result }} will not work here
```
- OR we can call it with debug or any other module but we need to use {{ }}
```
ansible.builtin.shell: /usr/bin/ls
    register: ls_result

ansible.builtin.debug:
    msg: {{ ls_result }}