# Ansible Block and Error Handlings
- In Ansible, blocks function similarly to try/catch/finally exception blocks in programming. They allow you to group related tasks together and define structured error-handling routines to catch failures, run cleanups, or perform rollbacks.
- Error handling with blocks relies on three key keywords: block, rescue, and always

### Core Structure & Components
- `block`: Contains the primary tasks you want to execute. Ansible attempts to run these sequentially.
- `rescue`: Tasks defined here only run if a task inside the block section fails. If everything inside the block succeeds, the rescue section is completely skipped.
- `always`: Tasks defined here will always execute, regardless of whether the tasks in the block succeeded or failed. This is ideal for closing connections, clearing temporary folders, or deleting credentials.

## DEMO
- for block, check this playbook [47-ansible_block.yaml](../LAB/47-ansible_block.yaml)
