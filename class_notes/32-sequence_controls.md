# Sequence Controls 
- In Ansible, tasks execute in a strict, predictable sequence from top to bottom within a play. However, when you introduce things like `pre-tasks`, `roles`, `standard tasks`, and `blocks`, the order follows a highly specific execution lifecycle.

    ```
    1. pre_tasks         (Runs before anything else)
    2. meta: flush_handlers (If triggered during pre_tasks)
    3. roles             (Statically imported roles run next)
    4. tasks             (Your standard, main task list)
    5. post_tasks        (Runs after your main tasks complete)
    6. handlers          (Triggered handlers run at the very end)
    ```

- Overriding Default Order:
    1. Blocks (block, rescue, always)
        - Blocks group tasks together and allow you to handle failures sequentially—similar to try/catch in programming.
        - block: Runs normal tasks in sequence.rescue: Runs only if a task inside the block fails.
        - always: Runs at the end of the block structure no matter what (even if it failed or succeeded).

    2. Flushing Handlers Mid-Play (meta: flush_handlers)
        - By default, handlers wait until the very end of the playbook to run. If you need a service restarted immediately before moving to the next task, you can force the sequence to pause and run handlers using a meta task:
    3. Conditional Breaks (any_errors_fatal & max_fail_percentage)
        - any_errors_fatal: true: If a task fails on even one host, Ansible immediately halts the entire playbook sequence across all hosts.
        - Serial Execution (serial: 2): Breaks your hosts into small batches. The entire task sequence runs completely for the first 2 servers before starting over on the next 2 servers.