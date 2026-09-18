# Ansible Block and Error Handlings
- In Ansible, blocks function similarly to try/catch/finally exception blocks in programming. They allow you to group related tasks together and define structured error-handling routines to catch failures, run cleanups, or perform rollbacks.
- Error handling with blocks relies on three key keywords: block, rescue, and always

### Core Structure & Components
- `block`: Contains the primary tasks you want to execute. Ansible attempts to run these sequentially.
- `rescue`: Tasks defined here only run if a task inside the block section fails. If everything inside the block succeeds, the rescue section is completely skipped.
- `always`: Tasks defined here will always execute, regardless of whether the tasks in the block succeeded or failed. This is ideal for closing connections, clearing temporary folders, or deleting credentials.

## DEMO
- for block, check this playbook [47-ansible_block.yaml](../LAB/47-ansible_block.yaml)
- for complete combination, check this playbook [48-ansible_block_rescue_always.yaml](../LAB/48-ansible_block_rescue_always.yaml)

#### How different combinations behave
- Depending on what your playbook requires, you can structure your tasks in three different ways:
    1. block + rescue (Most Common for Rollbacks)
        - Use this when you only care about catching errors. If the main tasks work, the playbook moves on. If they fail, your recovery code runs to fix the system.
    2. block + always (No Error Handling, Just Cleanup)
        - You can skip rescue completely if you don't need to fix errors but absolutely must run a cleanup task at the end (like deleting a password file you used during execution).
    3. block + rescue + always (The Full Lifecycle)
        - This uses all three layers: Try the task --> Fix it if it breaks --> Clean up the workspace when done.