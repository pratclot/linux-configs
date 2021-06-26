#!/bin/sh

ansible-playbook -l localhost site.yml -t $1
