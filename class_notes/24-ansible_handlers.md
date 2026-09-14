# Handlers
- A handler in Ansible is a special type of task that only runs when triggered by a change made by another task. We can call this type of tasks as `dormant tasks`.
- Handlers are used for operational cleanup and maintenance actions—such as restarting a service or reloading a firewall—after a configuration file is altered. If your playbook runs and nothing changes, the handlers are intelligently skipped to maximize execution speed and maintain system stability.
- Core Mechanics & Workflow
    - `notify`: A normal task uses the notify keyword to call a handler by its exact name.
    - `changed state`: The handler is only queued if the notifying task reports a status of changed. If the task returns `ok` (meaning the configuration was already up to date), the handler is skipped.
    - `End-of-Play Execution`: By default, triggered handlers do not run immediately. They wait patiently and execute all together at the very end of the play, ensuring a service restarts exactly once even if multiple tasks notified it.

- Key Execution Rules to Remember
    - `Exact String Matching`: The string passed to `notify:` must match the `name:` of the handler exactly, **character-for-character (case-sensitive)**.
    - `Flawless Dependency Safety`: If a playbook crashes halfway through its tasks, none of the queued handlers will execute. This prevents your services from entering broken halfway states.
    - `Forcing Immediate Execution`: If you need a handler to run instantly mid-playbook (e.g., bringing up a firewall rule before installing software over the network), you can flush the queue manually using a meta task:
        ```
        - name: Flush handlers right now
          ansible.builtin.meta: flush_handlers
        ```

- `force_handlers: yes`
- This keyword is a global playbook setting that forces Ansible to run your triggered handlers even if a task fails later in the playbook.
- By default, Ansible values safety above all else. If a task crashes halfway through a play, Ansible will instantly halt execution for that host and discard all queued handlers, leaving services un-restarted to prevent bringing a half-configured system online. force_handlers changes this default behavior.
- check this playbook [35-ansible_force_handlers.yaml](../LAB/35-ansible_force_handlers.yaml)

- `Notify Demo`
    - check this playbook 