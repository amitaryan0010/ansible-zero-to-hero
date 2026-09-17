# JINJA2 Template
- A Jinja2 Template is one of the most powerful features in Ansible. Instead of deploying static configuration files using the copy module, templates allow you to create dynamic text files that automatically adapt to your managed hosts using variables and code logic.

- ansible.builtin.template: 
    - Crucial. Instead of just copying a static file, this module takes a dynamic file written with Jinja2 templating. It swaps out variables (like IP addresses, hostnames, or custom settings) on the fly before sending the finalized configuration file to the managed host.

- The Anatomy of a Template (.j2 extension)
    - Jinja2 templates use specific delimiters to distinguish regular text from code:
        - {{ ... }}: Variables – Prints out the value of an Ansible variable or fact.
        - {% ... %}: Statements – Handles logic like if/else conditionals and for loops.
        - {# ... #}: Comments – Text that gets completely hidden from the final file.

### DEMO
- check this playbook [60-deploy_template.yaml](../LAB/60-deploy_template.yaml) to understand the normal j2 template.
- check this playbook [61-my_web_server.yaml](../LAB/61-my_web_server.yaml) to parse the ansible_facts in j2 template.
- check this playbook [62-multi_style.yaml](../LAB/62-multi_style.yaml) to understand the `for` loop and `if` condition, how we can parse the information to different style.