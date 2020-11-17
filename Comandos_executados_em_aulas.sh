# Inicia o vagrant
vagrant up



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


# Mudando o script para nao ficar escrevendo codigo repetido usando with_items


#Provision.yml neste comando:
---
- hosts: all
  tasks:
    - name: 'Instala pacotes de dependencia do sistema operacional'
      apt:
        name: "{{ item }}"
        state: latest
      become: yes # Indica usuario root 
      with_items:
        - php5
        - apache2
        - libapache2-mod-php5
        - php5-gd
    

# Comando no shell

ansible-playbook provision.yml -u vagrant -i hosts --private-key .vagrant/machines/wordpress/virtualbox/private_key

# Saida

# vate-key .vagrant/machines/wordpress/virtualbox/private_key

# PLAY [all] *********************************************************************************************

# TASK [Gathering Facts] *********************************************************************************
# ok: [172.17.177.40]

# TASK [Instala pacotes de dependencia do sistema operacional] *******************************************
# [DEPRECATION WARNING]: Invoking "apt" only once while using a loop via squash_actions is deprecated. 
# Instead of using a loop to supply multiple items and specifying `name: "{{ item }}"`, please use `name:
#  ['php5', 'apache2', 'libapache2-mod-php5', 'php5-gd']` and remove the loop. This feature will be 
# removed in version 2.11. Deprecation warnings can be disabled by setting deprecation_warnings=False in 
# ansible.cfg.
# changed: [172.17.177.40] => (item=['php5', 'apache2', 'libapache2-mod-php5', 'php5-gd'])

# PLAY RECAP *********************************************************************************************
# 172.17.177.40              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 



# Mudando o script para n'ao ficar escrevendo codigo repetido apenas com name


#Provision.yml neste comando:
---
- hosts: all
  tasks:
    - name: 'Instala pacotes de dependencia do sistema operacional'
      apt:
        name:
          - php5
          - apache2
          - libapache2-mod-php5
          - php5-gd
          - libssh2-php
          - php5-mcrypt
          - mysql-server-5.6
          - python-mysqldb
          - php5-mysql
        state: latest
      become: yes # Indica usuario root 
        
    

# Comando no shell

ansible-playbook provision.yml -u vagrant -i hosts --private-key .vagrant/machines/wordpress/virtualbox/private_key

# Saida

# vate-key .vagrant/machines/wordpress/virtualbox/private_key

# PLAY [all] *********************************************************************************************

# TASK [Gathering Facts] *********************************************************************************
# ok: [172.17.177.40]

# TASK [Instala pacotes de dependencia do sistema operacional] *******************************************
# [DEPRECATION WARNING]: Invoking "apt" only once while using a loop via squash_actions is deprecated. 
# Instead of using a loop to supply multiple items and specifying `name: "{{ item }}"`, please use `name:
#  ['php5', 'apache2', 'libapache2-mod-php5', 'php5-gd']` and remove the loop. This feature will be 
# removed in version 2.11. Deprecation warnings can be disabled by setting deprecation_warnings=False in 
# ansible.cfg.
# changed: [172.17.177.40] => (item=['php5', 'apache2', 'libapache2-mod-php5', 'php5-gd', 'libssh2-php', 'php5-mcrypt', 'mysql-server-5.6', 'python-mysqldb', 'php5-mysql'])

# PLAY RECAP *********************************************************************************************
# 172.17.177.40              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  


# Alterando o arquivo host para diminuir o c[odigo de comando do ansible
# para n'ao percisar ficar passando o usuario nem a chave privada

# arquivo hosts

[wordpress]
172.17.177.40 ansible_user=vagrant ansible_ssh_private_key_file="/home/gustavo/Desktop/wordpress_com_ansible/.vagrant/machines/wordpress/virtualbox/private_key"

# comando ansible depois da mudanca
# Agora so precisamos passor o nome do playbook e o arquivo de inventario

ansible-playbook provision.yml -i hosts 


# Criando o banco MySQL com ansible
# Script atual:

---
- hosts: all
  tasks:
    - name: 'Instala pacotes de dependencia do sistema operacional'
      apt:
        name:
          - php5
          - apache2
          - libapache2-mod-php5
          - php5-gd
          - libssh2-php
          - php5-mcrypt
          - mysql-server-5.6
          - python-mysqldb
          - php5-mysql
        state: latest
      become: yes # Indica usuario root 

    - name: 'Cria o banco MySQL'
      mysql_db:
        name: wordpress_db
        login_user: root
        state: present

# Comando no shell

ansible-playbook provision.yml -i hosts 

# Saida:
# PLAY [all] *************************************************************************************************************************

# TASK [Gathering Facts] *************************************************************************************************************
# ok: [172.17.177.40]

# TASK [Instala pacotes de dependencia do sistema operacional] ***********************************************************************
# ok: [172.17.177.40]

# TASK [Cria o banco MySQL] **********************************************************************************************************
# changed: [172.17.177.40]

# PLAY RECAP *************************************************************************************************************************
# 172.17.177.40              : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


# Entrando na maquina virtual e testando o banco:

gustavo@ubuntu:~/Desktop/wordpress_com_ansible$ vagrant ssh
Welcome to Ubuntu 14.04.6 LTS (GNU/Linux 3.13.0-170-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

  System information as of Tue Nov 17 04:19:22 UTC 2020

  System load:  0.0               Processes:           82
  Usage of /:   4.4% of 39.34GB   Users logged in:     0
  Memory usage: 59%               IP address for eth0: 10.0.2.15
  Swap usage:   0%                IP address for eth1: 172.17.177.40

  Graph this data and manage this system at:
    https://landscape.canonical.com/


Last login: Tue Nov 17 04:19:26 2020 from 172.17.177.1

vagrant@vagrant-ubuntu-trusty-64:~$ mysql -u root
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 45
Server version: 5.6.33-0ubuntu0.14.04.1 (Ubuntu)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| wordpress_db       | <--- Nosso database
+--------------------+
4 rows in set (0.00 sec)


# Criando um usuario com privilegios para o banco wordpress_db

# provision.yml

---
- hosts: all
  tasks:
    - name: 'Instala pacotes de dependencia do sistema operacional'
      apt:
        name:
          - php5
          - apache2
          - libapache2-mod-php5
          - php5-gd
          - libssh2-php
          - php5-mcrypt
          - mysql-server-5.6
          - python-mysqldb
          - php5-mysql
        state: latest
      become: yes # Indica usuario root 

    - name: 'Cria o banco MySQL'
      mysql_db:
        name: wordpress_db
        login_user: root
        state: present

    - name: 'Cria o usuario do MySQL'
      mysql_user:
        login_user: root
        name: wordpressuser
        password: 12345
        priv: 'wordpress_db.*:ALL' # Tem todos privilegios para o banco wordpress_db
        state: present

#  Comando Shell:

ansible-playbook provision.yml -i hosts 

# Saida

# PLAY [all] *************************************************************************************************************************

# TASK [Gathering Facts] *************************************************************************************************************
# ok: [172.17.177.40]

# TASK [Instala pacotes de dependencia do sistema operacional] ***********************************************************************
# ok: [172.17.177.40]

# TASK [Cria o banco MySQL] **********************************************************************************************************
# ok: [172.17.177.40]

# TASK [Cria o usuario do MySQL] *****************************************************************************************************
# [WARNING]: The value ******** (type int) in a string field was converted to u'********' (type string). If this does not look like
# what you expect, quote the entire value to ensure it does not change.
# [WARNING]: Module did not set no_log for update_password
# changed: [172.17.177.40]

# PLAY RECAP *************************************************************************************************************************
# 172.17.177.40              : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   



