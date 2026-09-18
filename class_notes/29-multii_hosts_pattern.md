## Multi Hosts Patteren
- Sometimes, we have many hosts into inventory and those are or those are not a part of groups in inventory. We can use different hosts pattern while operating against using below techniques. It will work with adhoc as well as playbook.


### Ansible Host Patterns Cheat Sheet

| Logical Operator | Syntax Symbol | Example Pattern | Target Matching Criteria |
| :--- | :--- | :--- | :--- |
| **OR** (Union) | `,` or `:` | `linux,non-prod` | Targets hosts that belong to `linux` **OR** `non-prod` (or both). |
| **AND** (Intersection) | `:&` or `,&` | `linux:&no-prod` | Targets hosts **ONLY** if they exist in both `linux` **AND** `non-prod`. |
| **NOT** (Exclusion) | `:!` or `,!` | `linux:!non-prod` | Targets hosts in `linux`, but **EXCLUDES** any that belong to `non-prod`. |
| **Wildcard** | `*` | `*.path4cloud.com` | Targets all hosts with names ending in `.path4cloud.com`. |
| **Mixed Complex** | Combo | `linux:&no-prod:!db` | Targets nodes in `linux` **AND** `no-prod`, but **EXCLUDES** `db` hosts. |


#### DEMO
```
We will play against linux inventory file, since we don't have multi hosts so I created a dummy hosts lists. We will run adhoc commannd:

$ pwd
/home/ansibleuser/ansible-zero-to-hero/master_inventory/dev
$ cat linux
[linux]
server1.path4cloud.com
server2.path4cloud.com
server[a:d].path4cloud.com

[webservers]
web1.path4cloud.com
web2.path4cloud.com

[dbservers]
db1.path4cloud.com
db2.path4cloud.com
oracledb[1:10].path4cloud.com

[webapp:children]
webservers
dbservers

[onprem]
server1.path4cloud.com

[cloud]
servera.path4cloud.com

[all:children]
linux
webservers
dbservers
onprem
cloud
```
- To print all hosts:
```
$ ansible -i linux all --list-hosts
  hosts (20):
    server1.path4cloud.com
    server2.path4cloud.com
    servera.path4cloud.com
    serverb.path4cloud.com
    serverc.path4cloud.com
    serverd.path4cloud.com
    web1.path4cloud.com
    web2.path4cloud.com
    db1.path4cloud.com
    db2.path4cloud.com
    oracledb1.path4cloud.com
    oracledb2.path4cloud.com
    oracledb3.path4cloud.com
    oracledb4.path4cloud.com
    oracledb5.path4cloud.com
    oracledb6.path4cloud.com
    oracledb7.path4cloud.com
    oracledb8.path4cloud.com
    oracledb9.path4cloud.com
    oracledb10.path4cloud.com

OR
$ ansible -i linux '*' --list-hosts
(will list the all hosts)
```
- To print the list with specific string using `*`
```
$ ansible -i linux 'oracle*' --list-hosts
  hosts (10):
    oracledb1.path4cloud.com
    oracledb2.path4cloud.com
    oracledb3.path4cloud.com
    oracledb4.path4cloud.com
    oracledb5.path4cloud.com
    oracledb6.path4cloud.com
    oracledb7.path4cloud.com
    oracledb8.path4cloud.com
    oracledb9.path4cloud.com
    oracledb10.path4cloud.com
```
- To print the servers which are part of both groups (`and` condition)
```
$ ansible -i linux 'webservers,&webapp' --list-hosts
  hosts (2):
    web1.path4cloud.com
    web2.path4cloud.com

$ ansible -i linux 'linux,&cloud' --list-hosts
  hosts (1):
    servera.path4cloud.com
```
- To print the server, which are part of first group but not part of second groups (`not` condition)
```
$ ansible -i linux 'linux,!cloud' --list-hosts
  hosts (5):
    server1.path4cloud.com
    server2.path4cloud.com
    serverb.path4cloud.com
    serverc.path4cloud.com
    serverd.path4cloud.com
```
- To work with playbooks, like how can we define the hosts at PLAY level.
    - check this playbook [63-multi_host_patteren.yaml](../LAB/63-multi_host_patteren.yaml)
    
    - run as `$ anr 63-multi_host_patteren.yaml -i ../master_inventory/dev/linux`
    OR
    `$ ap -i ../master_inventory/dev/linux 63-multi_host_patteren.yaml`