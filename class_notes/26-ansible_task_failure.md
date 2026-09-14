# TASK Failure
- In Ansible, task failure occurs when a module encounters an error or a shell command returns a non-zero exit code (rc != 0).
- By default, when a task fails on a host, Ansible immediately halts all further execution for that specific host, discards any queued handlers, and moves on to the next host in the inventory.

### How to Control and Manage Task Failures
-  Ignore Errors (ignore_errors)
    - If a task failure is non-critical (like a directory cleanup failing because it's already empty), you can tell Ansible to log the failure but continue running the remaining tasks.
    - `ignore_errors` can be defined at play level which will be applied to all tasks in that play or at a particular task level which will be applied only to that specific task.
    - check this playbook [37-ansible_ignore_error.yaml](../LAB/37-ansible_ignore_error.yaml)

-  Define Custom Failures (failed_when)
    - Sometimes a command succeeds (rc: 0), but the output text indicates a failure (e.g., "ERROR: connection timed out"). You can use `failed_when` to look inside the registered output and force a failure status.
    - check this playbook [38-ansible_custom_failure.yaml](../LAB/38-ansible_custom_failure.yaml)

-  Intentionally Force a Failure `(ansible.builtin.fail)`
    - You can use the fail module paired with a conditional when statement to explicitly stop the playbook run if a pre-check requirement isn't met.
    - check this playbook [39-ansible_fail_module.yaml](../LAB/39-ansible_fail_module.yaml)

- Some modules default resulted as changed state
    - `ansible.builtin.raw`, `ansible.builtin.shell`, `ansible.builtin.command`: these modules always result as changed state even they did not modify or changed something. Because the command, shell, and raw modules simply execute arbitrary lines of code, Ansible has no native way of knowing what your script actually did. It cannot see if your script modified a file, started a process, or just printed out text.
    - To remain safe, Ansible defaults to reporting `changed: true` every single time these tasks run, breaking the principle of idempotency.
    - So keep the idempotency, we can use `changed_when` and define the condition when it should result as changed.
    - Demo for `ansible.builtin.raw`
        - The ansible.builtin.raw module executes SSH commands directly on remote nodes without loading the Python interpreter. It bypasses Ansible’s standard module subsystem entirely.
        - check this playbook for default behaviour [40-ansible_raw_module.yaml](../LAB/40-ansible_raw_module.yaml)
        - check this playbook for fix [41-ansible_raw_module_fix.yaml](../LAB/41-ansible_raw_module_fix.yaml)
    - Demo for `ansible.builtin.command`
        - 