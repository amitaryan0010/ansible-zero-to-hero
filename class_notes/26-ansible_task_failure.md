# TASK Failure
- In Ansible, task failure occurs when a module encounters an error or a shell command returns a non-zero exit code (rc != 0).
- By default, when a task fails on a host, Ansible immediately halts all further execution for that specific host, discards any queued handlers, and moves on to the next host in the inventory.

### How to Control and Manage Task Failures
-  Ignore Errors (ignore_errors)
    - If a task failure is non-critical (like a directory cleanup failing because it's already empty), you can tell Ansible to log the failure but continue running the remaining tasks.
    - check this playbook