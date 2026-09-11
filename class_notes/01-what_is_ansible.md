# Intro
Ansible is an open-source automation tool used in DevOps to manage systems, deploy applications, and automate IT tasks.

## ⚙️ What Can Ansible Do?

Ansible helps you automate:

- 🖥️ Server setup (install packages, users, configs)
- 🚀 Application deployment (deploy apps across servers)
- 🔁 Configuration management (keep systems consistent)
- ☁️ Cloud provisioning (AWS, GCP, etc.)
- 🔧 Daily DevOps tasks


## 🧠 [How Ansible Works](https://www.redhat.com/en/ansible-collaborative/how-ansible-works) (Simple Explanation)

Ansible follows a very simple model:

- Control Node → your machine (where Ansible runs)
- Managed Nodes → servers you want to control
- Uses SSH (no agent required ✅)
- You write instructions in a file called a Playbook (YAML)
- Ansible executes those steps on multiple servers

## 🔥 Why Ansible is Popular
- ✅ Agentless (no software needed on servers)
- ✅ Easy to learn (uses simple YAML)
- ✅ Powerful (used in real DevOps environments)
- ✅ Idempotent (won’t repeat unnecessary changes)

## Types of Ansible:
1) **Red Hat Ansible Engine** (the older ansible engine 2.9 version) is officially available only for RHEL 7 and RHEL 8. It has been completely phased out in newer versions and is not available for RHEL 9 or RHEL 10. Starting with RHEL 8.6 and RHEL 9.0, Red Hat replaced Ansible Engine with Ansible Core. The Ansible Engine repository remained available for legacy purposes but stopped receiving security or bug fix updates after September 29, 2023.
2) [ansible-core](https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html#selecting-an-ansible-package-and-version-to-install) (comes by default with RHEL9): This package comes directly from standard AppStream repository (rhel-9-for-x86_64-appstream-rpms), It includes CLI tools such as the ansible-playbook and ansible commands and [basic modules](https://docs.ansible.com/projects/ansible-core/devel/collections/ansible/builtin/index.html#plugins-in-ansible-builtin).
    - [Using Ansible in RHEL 8.6 and later](https://access.redhat.com/articles/6393361)
    - [Using Ansible in RHEL 9](https://access.redhat.com/articles/6393321)
    - [Scope of support for the Ansible Core](https://access.redhat.com/articles/6325611)
3) [Community Ansible](https://docs.ansible.com/projects/ansible/latest/installation_guide/installation_distros.html#installing-ansible-from-epel): open source but with limited support, built on top of ansible-core, comes with [community supported collections](https://docs.ansible.com/projects/ansible/latest/collections_guide/index.html#collections) with more plugins & modules.
4) [AAP (Ansible Automation Platform)](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7): is an enterpise licence based solution. It comes with:
    - [Automation Controller](https://www.redhat.com/en/technologies/management/ansible/automation-controller) (web user interface)
    - [Automation Hub](https://www.redhat.com/en/technologies/management/ansible/automation-hub) (verfied content collections)
    - [Ansible Navigator](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.7/develop-con_about_ansible_navigator#con-navigator-mode)
    - [Execution Environment](https://www.redhat.com/en/technologies/management/ansible/automation-execution-environments)(Container Image used by Ansible Navigator)
    - [Red Hat Ansible Automation Platform product trials](https://www.redhat.com/en/products/trials#ansible)
5) [Ansible Automation Controller](https://www.redhat.com/en/technologies/management/ansible/automation-controller) (formerly known as Ansible Tower). This is the specific component within AAP that provides the user-facing web interface and REST API. 
6) [Ansible LightSpeed](https://docs.redhat.com/en/documentation/red_hat_ansible_lightspeed_with_ibm_watsonx_code_assistant/2.x_latest): Red Hat Ansible Lightspeed with IBM watsonx Code Assistant is an enterprise-grade, generative AI-powered development tool designed to accelerate and simplify the creation of Ansible automation content. By integrating directly into Visual Studio Code via the official Ansible extension, it acts as an intelligent coding partner that converts natural language prompts into production-ready Ansible code
7) [EDA (Event Driven Ansible)](https://www.redhat.com/en/technologies/management/ansible/event-driven-ansible): It is a technology developed by Red Hat as part of the Ansible Automation Platform that enables automated IT tasks to trigger in real time based on system events, Alerts, Webhooks, Monitoring tools rather than running scripts manually or on a fixed schedule.
8) [Ansible on Clouds](https://docs.redhat.com/en/documentation/ansible_on_clouds/2.x) It is available on Microsoft Azure and AWS.
9) [Red Hat Ansible Inside](https://docs.redhat.com/en/documentation/red_hat_ansible_inside/1.3): Red Hat Ansible Inside 1.3 is a specialized product bundle designed for Red Hat Partners to natively embed and integrate Ansible automation directly into their own applications. It allows developers to control and execute automation routines programmatically using the Command Line Interfaces (CLIs) of core Ansible components
10) [Ansible Automation Platform — automation orchestrator](https://docs.redhat.com/en/documentation/automation_orchestrator/2026.8): An automation orchestrator is a centralized software tool or platform designed to coordinate, manage, and execute multiple automated tasks and workflows across different systems, applications, and departments
11) [Ansible AWX](https://www.redhat.com/en/ansible-collaborative/awx): Ansible AWX is a free, open-source web application that provides a graphical user interface, a REST API, and a task engine for Ansible. It acts as the upstream, community-supported project for the commercial Red Hat Ansible Automation Platform (previously known as Ansible Tower).

## Ansible ecosystem
- The projects in the Ansible collaborative let you expand automation to an unlimited set of use cases.
- [View All Projects](https://www.redhat.com/en/ansible-collaborative/ecosystem)

## Ansible collections
- With Ansible Galaxy, you can jump-start your automation with pre-packaged roles and collections. Use this content in Ansible Playbooks to automate your work faster and improve productivity.
- [Explore all collections on Ansible Galaxy](https://galaxy.ansible.com/ui/collections/?extIdCarryOver=true&intcmp=7015Y000003t7aWQAQ&sc_cid=RHCTG0230000220540)

## Subscription Requirements
The subscription you need depends entirely on how you plan to use Ansible:

| Use Case | Subscription Required | Scope of Support |
|----------|----------------------|-----------------|
| **Basic Red Hat Automation** | Standard RHEL Subscription | Fully Supported by Red Hat only when executing built-in or Red Hat-provided playbooks (such as RHEL System Roles, IDM automation, or playbooks generated by Red Hat Insights). |
| **Custom / Enterprise Automation** | Red Hat Ansible Automation Platform (AAP) Subscription | Fully Supported for custom playbooks, custom modules, full-scale enterprise orchestrations, and access to automation mesh infrastructure. |
| **Community Playbooks (Self-Support)** | Standard RHEL Subscription | Unsupported (Self-Support). You can write your own playbooks or use community collections, but Red Hat will not provide technical support if your custom playbooks break or fail. |


[Red Hat Ansible Automation Platform Life Cycle](https://access.redhat.com/support/policy/updates/ansible-automation-platform)