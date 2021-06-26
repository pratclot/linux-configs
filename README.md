# linux-configs

The repo contains Ansible playbook to quickly setup convenient working environment.

Do this to configure your freshly dispatched Mac:

```bash
./basics.sh 
ansible-playbook -l localhost site.yml
```

This even works for arch now!

Use `apply.sh` script to apply a tag quickly:

```bash
./apply.sh bash
```
