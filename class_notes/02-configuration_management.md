## ✅ Usually, a computer needs Configuration where it got the instruction to perform some tasks.
- On Linux, Configuration is stored in many different files (readable text format).
- On Windows, Configuration is mainly stored in the registry.
- Hardware appliance also make a use of Configuration file.

In large environments like cloud and big datacenters, managing individual server's configuration is harder so we can use any configuration management solutions.

### ⚙️ A configuration management solution manages configuration in a centralized way. Some tools have an agent that pulls configuration from the central management solution. Whereas some tools use a push mechanism, where the configuration is pushed from the configuration manager to the managed devices.

## Product Available for Configuration Management as Code (CaC)
- [Puppet](https://www.puppet.com/): Leading Solution (Open Source).
- [Chef](https://www.chef.io/): Ruby-Based syntax to provide solution for configuration management (Small Solution).
- [SaltStack](https://saltproject.io/): Yaml based syntax for small solution.
- [Terraform](https://developer.hashicorp.com/terraform): It is an ideal solution for IaaC, but commonly or mistakenly used as CaC.
- [Ansible](https://docs.ansible.com/): Based on Python, use YAML based sysntax to provide solution. Product owned by RedHat.


✅ It is recommended to keep the configuration management code in a centrally managed, declarative, configuration files using a Git repositories or any other SVM solution.

 