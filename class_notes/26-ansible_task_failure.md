# TASK Failure
- In Ansible, task failure occurs when a module encounters an error or a shell command returns a non-zero exit code (rc != 0).
- By default, when a task fails on a host, Ansible immediately halts all further execution for that specific host, discards any queued handlers, and moves on to the next host in the inventory.

### How to Control and Manage Task Failures
-  Ignore Errors (ignore_errors)
    - If a task failure is non-critical (like a directory cleanup failing because it's already empty), you can tell Ansible to log the failure but continue running the remaining tasks.
    - `ignore_errors` can be defined at play level which will be applied to all tasks in that play or at a particular task level which will be applied only to that specific task.
    - check this playbook [37-ansible_ignore_error.yaml](../LAB/37-ansible_ignore_error.yaml)

-  Define Custom Failures (failed_when)
    - Sometimes a command succeeds (rc: 0), but the output text indicates a failure (e.g., "ERROR: connection timed out"). You can use failed_when to look inside the registered output and force a failure status.
    - check this playbook 