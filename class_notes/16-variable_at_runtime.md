# [Defining variables at runtime](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime)

- Variable Value passed at runtime (at cli) will be having a high precendence.
- You can define variables when you run your playbook by passing variables at the command line using the --extra-vars (or -e) argument. You can also request user input with a vars_prompt (check [Interactive input: prompts](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_prompts.html#interactive-input-prompts)). If you pass variables at the command line, use a single quoted string that contains one or more variables in one of the formats below.

1. Key-value format
    - Values passed in using the key=value syntax are interpreted as strings.
        
        $  ansible-playbook <playbook.yaml> --extra-vars "version=1.23 other_variable=Ansible"

2. JSON string format
    - Use the JSON format if you need to pass non-string values such as Booleans, integers, floats, and lists.

        $ ansible-playbook <playbook.yaml> --extra-vars '{"version":"1.23.45","other_variable":"Ansible"}'

        $ ansible-playbook <playbook.yaml> --extra-vars '{"pacman":"mrs","ghosts":["inky","pinky","clyde","sue"]}'

3. Escaping Quotes (Dealing with Special Characters)
    - When your variables contain quotes, apostrophes, or exclamation marks, shell escaping becomes highly problematic.

        $ ansible-playbook <playbook.yaml> --extra-vars "{\"name\":\"Conan O'Brien\"}"

4. Loading Variables from a File (Best Practice)
    - To avoid the "escaping nightmare" shown above, write your variables cleanly into a separate file and tell Ansible to load it by prepending the filename with the @ symbol.
    - Option A: Using a YAML file
        - Create a file named my_vars.yaml:
        ```
        version: 1.23.45
        name: "Conan O'Brien"
        dialog: 'He said "I just can\'t get enough of those single and double-quotes!"'
        ghosts:
          - inky
          - pinky
        ```

            $ ansible-playbook <playbook.yaml> --extra-vars "@my_vars.yaml"

    - Option B: Using a JSON file
        - Create a file named my_vars.json:
        ```
        {
        "version": "1.23.45",
        "name": "Conan O'Brien",
        "ghosts": ["inky", "pinky"]
        }
        ```

            $ ansible-playbook <playbook.yaml> --extra-vars "@my_vars.json"

### DEMO
- use this [11-var_at_runtime.yaml](../LAB/11-var_at_runtime.yaml) for this demo.
- required files:
    - [my_vars.json](../LAB/my_vars.json)
    - [my_vars.yaml](../LAB/my_vars.yaml)