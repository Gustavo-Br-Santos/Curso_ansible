ansible wordpress -u vagrant --private-key .vagrant/machines/wordpress/virtualbox/private_key -i hosts -m shell -a 'echo Hello world!'


# Saida
# 172.17.177.40 | CHANGED | rc=0 >>
# Hello world!





# ```
# Adicionar o -vvvv permite trazer detalhes na saida sobre a conexao ssh e pode
# ser muito util para depuracao
# ```
ansible -vvvv wordpress -u vagrant --private-key .vagrant/machines/wordpress/virtualbox/private_key -i hosts -m shell -a 'echo Hello world!'




# ```
# Comando usado para criar um arquivo texto chamado world.txt, que est[a com seus parametros dentro 
# de provision.yml
# ```

# ```
# provision.yml neste momento 

---
- hosts: all
  tasks:
    - shell: 'echo hello > /vagrant/world.txt'


# Comando no shell
ansible-playbook provision.yml -u vagrant -i hosts --private-key .vagrant/machines/wordpress/virtualbox/private_key


# ```
# provision.yml neste momento 

# ---
# - hosts: all
#   tasks:
#     - shell: 'echo hello > /vagrant/world.txt'

# ```

# ```
# Saida comando ansible:
# ordpress/virtualbox/private_key

# PLAY [all] *************************************************************************************************************************

# TASK [Gathering Facts] *************************************************************************************************************
# ok: [172.17.177.40]

# TASK [shell] ***********************************************************************************************************************
# changed: [172.17.177.40]

# PLAY RECAP *************************************************************************************************************************
# 172.17.177.40              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  

#```



# Instalando um pacote com o ansible?

#Provision.yml neste comando:
---
- hosts: all
  tasks:
    - apt:
        name: php5
        state: latest
      become: yes # Indica usuario root 

# Comando no shell

ansible-playbook provision.yml -u vagrant -i hosts --private-key .vagrant/machines/wordpress/virtualbox/private_key



# Saida

# ordpress/virtualbox/private_key

# PLAY [all] *************************************************************************************************************************

# TASK [Gathering Facts] *************************************************************************************************************
# ok: [172.17.177.40]

# TASK [apt] *************************************************************************************************************************
# changed: [172.17.177.40]

# PLAY RECAP *************************************************************************************************************************
# 172.17.177.40              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  


