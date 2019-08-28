# linux-configs

The repo contains Ansible playbook to quickly setup convenient working environment.

Do this to configure your freshly dispatched Mac:

```bash
./basics.sh 
ansible-playbook -l localhost site.yml
```