## ✅ Usually, a computer needs Configuration where it got the instruction to perform some tasks.
- On Linux, Configuration is stored in many different files (readable text format).
- On Windows, Configuration is mainly stored in the registry.
- Hardware appliance also make a use of Configuration file.

In large environments like cloud and big datacenters, managing individual server's configuration is harder so we can use any configuration management solutions.

## ⚙️ A configuration management 
- It is the practice of handling changes to a system’s software, hardware, and settings in a structured, automated, and predictable way.Instead of a system administrator manually logging into 50 different servers to install software, tweak settings, or update security patches, Configuration Management allows you to write the desired state of your infrastructure into code. The config management tool then reads this code and automatically configures all the target servers to match that exact state.

- This solution allow to manage configuration in a centralized way. Some tools have an agent that pulls configuration from the central management solution. Whereas some tools use a push mechanism, where the configuration is pushed from the configuration manager to the managed devices.

## Product Available for Configuration Management as Code (CaC)
- [Puppet](https://www.puppet.com/): Leading Solution (Open Source). It requires an agent software installed on every target server. The agent checks in with a master server to pull updates.
- [Chef](https://www.chef.io/): Ruby-Based syntax to provide solution for configuration management (Small Solution). It is used to define "recipes" for server configurations.
- [SaltStack](https://saltproject.io/): Yaml based syntax for small solution. Known for extreme speed and real-time execution across thousands of servers.
- [Terraform](https://developer.hashicorp.com/terraform): It is an ideal solution for IaaC, but commonly or mistakenly used as CaC.
- [Ansible](https://docs.ansible.com/): Based on Python, use YAML based sysntax to provide solution. Product owned by RedHat.


✅ It is recommended to keep the configuration management code in a centrally managed, declarative, configuration files using a Git repositories or any other SVM solution.

 ## Real-Time Examples of Ansible in Action
 - Example 1: Setting Up a Fleet of Web Servers (The Apache Deployment)
    - Imagine a company launching a new web application that requires the Apache web server (httpd) to be running on 10 new RHEL-9 servers.Instead of logging into all 10 servers, you write one Ansible Playbook (webserver.yml):
        ```yaml
        ---
        - name: Configure Web Servers
          hosts: web_servers
          become: yes
          tasks:
            - name: Ensure Apache is installed
              dnf:
                name: httpd
                state: present

            - name: Ensure Apache configuration file is in place
              copy:
                src: /local/path/httpd.conf
                dest: /etc/httpd/conf/httpd.conf
                mode: '0644'

            - name: Ensure Apache service is started and enabled
              service:
                name: httpd
                state: started
                enabled: yes
        ```

- Example 2: User and Permission Onboarding (Tying back to ACLs!)
    - When a new System Administrator named alice joins the company, she needs an account, an SSH key deployed, and specific sudo permissions across 100 corporate staging and production servers.
        ```yaml
        ---
        - name: Onboard New System Administrator
          hosts: all_servers
          become: yes
          tasks:
            - name: Create user account for Alice
              user:
                name: alice
                state: present
                shell: /bin/bash

            - name: Deploy Alice's public SSH key
              authorized_key:
                user: alice
                state: present
                key: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."

            - name: Ensure Alice has sudo access
              copy:
                content: "alice ALL=(ALL) NOPASSWD:ALL"
                dest: /etc/sudoers.d/alice
                mode: '0440'
        ```

- Example 3: Automated Security Patching & Kernel Updates
    - The Scenario: A critical security vulnerability (like an openssh exploit) is discovered. The security team demands that 200 Linux servers across the company be patched immediately, and any server running an outdated kernel must be rebooted during a designated 2 AM maintenance window.
        ```yaml
        ---
        - name: Critical Security Patching Window
          hosts: production_servers
          become: yes
          tasks:
            - name: Upgrade all packages via DNF/YUM to get security fixes
              dnf:
                name: "*"
                state: latest
                update_cache: yes

            - name: Check if a reboot is required after updates
              command: needs-restarting -r
              register: reboot_required
              ignore_errors: yes
              failed_when: false

            - name: Reboot the server if kernel was updated
              reboot:
                msg: "Ansible triggered reboot for security patches"
                connect_timeout: 5
                reboot_timeout: 300
              when: reboot_required.rc == 1
        ```

- Example 4: Hardening Corporate SSH Configurations (Compliance Enforcement)
    - The Scenario: To pass a security audit (like ISO 27001 or PCI-DSS), your company must enforce a strict policy: Root login over SSH must be completely disabled, password authentication must be blocked (only SSH keys allowed), and an official warning banner must display upon login on every single machine.
        ```yaml
        ---
        - name: Enforce SSH Security Hardening
          hosts: all
          become: yes
          tasks:
            - name: Distribute the corporate legal warning banner
              copy:
                content: "WARNING: Authorized access only. All activity is monitored."
                dest: /etc/ssh/sshd_banner
                mode: '0644'

            - name: Configure strict sshd settings
              lineinfile:
                path: /etc/ssh/sshd_config
                regexp: "{{ item.regexp }}"
                line: "{{ item.line }}"
                state: present
              loop:
                - { regexp: '^PermitRootLogin', line: 'PermitRootLogin no' }
                - { regexp: '^PasswordAuthentication', line: 'PasswordAuthentication no' }
                - { regexp: '^Banner', line: 'Banner /etc/ssh/sshd_banner' }
              notify: Restart SSH Service

          handlers:
            - name: Restart SSH Service
              service:
                name: sshd
                state: restarted
        ```

- Example 5: Database Maintenance (Automated Backups & Log Rotation)
    - The Scenario: Your database administrators (DBAs) need to ensure that every MySQL/MariaDB server in the infrastructure has a nightly backup script deployed to cron, and old database logs are automatically rotated so disk space never runs out.
        ```yaml
        ---
        - name: Configure Database Maintenance Tasks
          hosts: db_servers
          become: yes
          tasks:
            - name: Copy the database backup script to the server
              copy:
                src: files/mysql_backup.sh
                dest: /usr/local/bin/mysql_backup.sh
                mode: '0750'
                owner: root

            - name: Create a cron job to run the backup every night at 1:30 AM
              cron:
                name: "Nightly MySQL Backup"
                minute: "30"
                hour: "1"
                job: "/usr/local/bin/mysql_backup.sh > /dev/null 2>&1"

            - name: Ensure logrotate configuration for MySQL is active
              template:
                src: templates/mysql-logrotate.j2
                dest: /etc/logrotate.d/mysql
                mode: '0644'
        ```