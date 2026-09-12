# Managing facts
- [Facts](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_vars_facts.html#vars-and-facts) are variable that are automatically gathered by the Ansible.
- It allows you to dynamically discover, customize, and utilize system properties from your target nodes.
- By default, when a playbook starts, Ansible executes the setup module to gather system variables (IP addresses, OS versions, disk layout, memory, etc.) known as Ansible Facts.

### Viewing Available Facts
- To see every piece of system data Ansible automatically collects from a host, you can run an ad-hoc command in your terminal:

        $ ansible localhost -m setup

### Turning Off Fact Gathering
- Gathering facts takes time. If your playbook doesn't need system details (e.g., you are just creating a user with hardcoded data), you can speed up execution by disabling it:
    ```
    - name: Playbook with facts turned off
      hosts: all
      gather_facts: no  # <-- Disables automatic discovery
    ```

###  Custom Facts (Local Facts)
- You can define your own static or executable custom facts on a target machine. Ansible will automatically inject them into the boot tracking registry.
- Where to place them: 
    - On the target machine, create a directory at /etc/ansible/facts.d/.
    - File Format: Create a file ending in .fact (can be INI format or JSON format).

- Example (/etc/ansible/facts.d/info.fact)
    ```
    [ansible_training]
    trainer: path4cloud
    mode: online
    target: zero-to-hero
    ```
- Demo:
    - copy this [info.fact](../LAB/info.fact) file to any target node under `/etc/ansible/facts.d/` (if facts.d directory is not there then create it)
        ```
        $ ansible centos9 -b -a "mkdir -p /etc/ansible/facts.d"

        $ ansible centos9 -m copy -a "src=info.fact dest=/etc/ansible/facts.d/"

        $ ansible centos9 -b -a "ls -l /etc/ansible/facts.d"
        ```

    - Verify the facts
        ```
        $ ansible centos9 -m setup | grep -A5 -w ansible_local
                "ansible_local": {
                    "info": {
                        "ansible_training": {
                            "mode": "online",
                            "target": "zero-to-hero",
                            "trainer": "path4cloud"
        ```

    - When we need, we can callout those variables.
        - check this playbook [20-custom_facts.yaml](../LAB/20-custom_facts.yaml)
        
### Setting Facts Dynamically (set_fact)
- You can create or modify variables mid-playbook based on task outputs or inline logic using the ansible.builtin.set_fact module:
    ```
    - name: Calculate value on the fly
      ansible.builtin.set_fact:
        is_rhel_system: "{{ ansible_facts['os_family'] == 'RedHat' }}"
        backup_folder: "/opt/backup/{{ ansible_facts['date_time']['date'] }}"
    ```

    - run this playbook [21-setting_fact.yaml](../LAB/21-setting_fact.yaml)

### Fact Caching
- [Cache plugins](https://docs.ansible.com/projects/ansible/latest/plugins/cache.html#cache-plugins) allow Ansible to store gathered facts or inventory source data without the performance hit of retrieving them from the source.
- To speed up plays across large inventories, you can store gathered facts in a centralized cache (like Redis, Memcached, or a local JSON file) so Ansible doesn't re-query machines on every run.
- The default cache plugin is the memory plugin, which only caches the data for the current execution of Ansible and non persistent.
- Other plugins with persistent storage are available to allow caching of the data across runs. Some of these cache plugins write to files, and others write to databases.
- Enabling fact cache plugins
    - Fact caching is always enabled. However, only one fact cache plugin can be active at a time. You can select the cache plugin to use for fact caching in the Ansible configuration, either with an environment variable:
        ```
        $ export ANSIBLE_CACHE_PLUGIN=jsonfile

        or in the ansible.cfg file
        [defaults]
        gathering = smart
        fact_caching = jsonfile
        fact_caching_connection = /tmp/ansible_fact_cache
        fact_caching_timeout = 86400 # Cache valid for 24 hours

        Step-by-Step Breakdown
        gathering = smart : By default, Ansible runs the time-consuming fact-gathering phase at the beginning of every single play. smart changes this behavior. It tells Ansible: "Only gather facts if they haven't been gathered yet or if they aren't already saved in our cache."

        fact_caching = jsonfileThis sets the storage engine for your cache. It tells Ansible to save the gathered system details as standard JSON text files.

        fact_caching_connection = /tmp/ansible_fact_cacheThis is the directory path on your control machine where the JSON files will be written. When you run a playbook against a host named centos9, Ansible will create a file at /tmp/ansible_fact_cache/centos9 filled with all its system specifications.

        fact_caching_timeout = 86400This defines the expiration lifetime of the cache in seconds. 86400 seconds is exactly 24 hours. For the next day, Ansible will instantly read the system properties from the local folder instead of logging into the remote machine to scan it.
        ```
- Enabling inventory cache plugins
    - Inventory caching is disabled by default. To cache inventory data, you must enable inventory caching and then select the specific cache plugin you want to use. Not all inventory plugins support caching, so check the documentation for the inventory plugin(s) you want to use. You can enable inventory caching with an environment variable:
        ```
        export ANSIBLE_INVENTORY_CACHE=True

        or in the ansible.cfg file:
        [inventory]
        cache=True

        using inventory cache plugins (Only one inventory cache plugin can be active at a time)
        You can set it with an environment variable:
        export ANSIBLE_INVENTORY_CACHE_PLUGIN=jsonfile

        or in the ansible.cfg file:
        # Enable the caching mechanism
        cache = True

        # Define the storage backend engine
        cache_plugin = jsonfile

        # Define where to save the server list files
        cache_connection = /tmp/ansible_inventory_cache

        # Set how long the server list stays valid (in seconds)
        cache_timeout = 3600
        ```
    - Since we are using a static inventory, enabling inventory caching provides absolutely no performance benefit. Ansible reads static text files from your local disk instantly. Inventory caching is strictly designed for dynamic inventories to prevent slow, repetitive API calls to cloud providers (like AWS, Azure, or GCP).

    - ⚠️ Crucial Caveat to Remember
        - Unlike static text hosts files, inventory caching will hide changes if servers are quickly created or destroyed. If you spin up a new virtual machine in your cloud console, Ansible will not see it until the cache_timeout limit expires. You can manually force a cache refresh at runtime by adding the --flush-cache flag to your command:

                $ ansible-playbook site.yml --flush-cache
            