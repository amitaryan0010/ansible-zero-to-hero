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

    - The command module executes binaries directly without loading a shell processor, making it faster and more secure. The shell module initializes a full shell session before running the command, which is required if you want to use advanced features like pipes (|), redirects (>), or environment variables.

    - Demo for `ansible.builtin.command`
        - check this playbook for default behaviour [42-ansible_command_module.yaml](../LAB/42-ansible_command_module.yaml)
        - heck this playbook for fix [43-ansible_command_module_fix.yaml](../LAB/43-ansible_command_module_fix.yaml)
    - Demo for `ansible.builtin.shell`
        - check this playbook for default behaviour [44-ansible_shell_module.yaml](../LAB/44-ansible_shell_module.yaml)
        - check this playbook for fix [45-ansible_shell_module_fix.yaml](../LAB/45-ansible_shell_module_fix.yaml)

### any_errors_fatal: true
- Aborts the entire playbook run for all hosts if even one host fails a task.
- Defined at PLAY Level
- By default, if you are running a playbook against 10 servers and Server 1 fails a task, Ansible will drop Server 1 but continue running the rest of the tasks on Servers 2 through 10.
- When you set `any_errors_fatal: true`, you change this behavior: if even one single server fails a task, the entire playbook stops immediately for all servers.
- This is crucial for multi-tier deployments (like a load balancer cluster or database replication grid) where a single node failure means the cluster is broken and continuing is dangerous.
- Scenario:
    - If you are updating two servers (redhat and docker) and the installation succeeds on the first but fails on the second, here is exactly how this setting protects your environment:
    1. It Blocks Downstream Tasks Instantly
        - `Without any_errors_fatal`, Ansible would leave the docker server behind but continue executing all subsequent tasks (like copying config files, starting services, or updating firewall rules) on the redhat server.
        - `With any_errors_fatal: true`, the moment the installation fails on the docker node, the playbook immediately stops for the redhat server as well. No further tasks are executed anywhere.
    2. It Prevents a "Split-Brain" Configuration State
        - If the playbook were allowed to continue running on the redhat node, you would end up with an asymmetrical setup:
            - redhat server: Fully updated, service restarted, and actively serving traffic.
            - docker server: Half-configured or broken.
        - If these two servers are part of a balanced application cluster, your users would experience errors 50% of the time depending on which server the load balancer directed them to. Stopping the playbook immediately alerts your engineering team to fix the issue before the application layer goes out of sync.

    - check this playbook [46-ansible_any_error_fatal.yaml](../LAB/46-ansible_any_error_fatal.yaml)