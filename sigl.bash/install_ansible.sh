# #!/bin/bash

# # Vérifie si l'utilisateur est root
# if [ "$(id -u)" -ne 0 ]; then
#   echo "Ce script doit être exécuté en tant que root ou avec sudo." >&2
#   exit 1
# fi

# # Définir le dossier de configuration d'Ansible
 ANSIBLE_CONFIG_DIR="/mnt/c/Users/ndeno/Documents/ESEO/E5A/SIGL/Projet/sigl.terraform/ansible"

# # Création du dossier de configuration si non existant
# mkdir -p "$ANSIBLE_CONFIG_DIR"

# # Détection de la distribution
# if [ -f /etc/debian_version ]; then
#   DISTRO="Debian"
# elif [ -f /etc/redhat-release ]; then
#   DISTRO="RedHat"
# else
#   echo "Distribution non prise en charge." >&2
#   exit 1
# fi

# # Installation d'Ansible
# if [ "$DISTRO" == "Debian" ]; then
#   echo "Installation d'Ansible sur Debian/Ubuntu..."
#   apt update
#   apt install -y software-properties-common
#   add-apt-repository --yes --update ppa:ansible/ansible
#   apt install -y ansible
# elif [ "$DISTRO" == "RedHat" ]; then
#   echo "Installation d'Ansible sur CentOS/RHEL/Fedora..."
#   yum install -y epel-release
#   yum install -y ansible
# fi

# # Vérifie si Ansible a bien été installé
# if ! command -v ansible > /dev/null; then
#   echo "L'installation d'Ansible a échoué." >&2
#   exit 1
# fi

# echo "Ansible installé avec succès !"

# # Attribution des permissions au reprtoire
# chmod 755 $ANSIBLE_CONFIG_DIR

# # Création de la configuration de base dans ansible.cfg
# cat <<EOF > "$ANSIBLE_CONFIG_DIR/ansible.cfg"
# [defaults]
# inventory = $ANSIBLE_CONFIG_DIR/hosts
# roles_path = $ANSIBLE_CONFIG_DIR/roles
# remote_user = ansible_user      # Remplace par l'utilisateur distant SSH
# host_key_checking = False
# timeout = 30
# forks = 10
# pipelining = True
# log_path = $ANSIBLE_CONFIG_DIR/ansible.log

# [privilege_escalation]
# become = True
# become_method = sudo
# EOF

# # Création de l'inventaire par défaut
# cat <<EOF > "$ANSIBLE_CONFIG_DIR/hosts"
# [servers]
# # Liste des serveurs cibles, exemple :
# # server1 ansible_host=192.168.1.10 ansible_user=root
# # server2 ansible_host=192.168.1.11 ansible_user=root
# EOF

# # Configuration des permissions du fichier de log
# touch "$ANSIBLE_CONFIG_DIR/ansible.log"
# chmod 664 "$ANSIBLE_CONFIG_DIR/ansible.log"

# # Téléchargement de quelques rôles communs d'Ansible Galaxy dans le dossier spécifié
# ansible-galaxy install geerlingguy.apache --roles-path "$ANSIBLE_CONFIG_DIR/roles"
# ansible-galaxy install geerlingguy.haproxy --roles-path "$ANSIBLE_CONFIG_DIR/roles"
# ansible-galaxy install geerlingguy.docker --roles-path "$ANSIBLE_CONFIG_DIR/roles"
ansible-galaxy role install jamdoog.teleport --roles-path "$ANSIBLE_CONFIG_DIR/roles"
ansible-galaxy role install buanzo.crowdsec_plus_console --roles-path "$ANSIBLE_CONFIG_DIR/roles"


echo "Configuration de base d'Ansible terminée. Vous pouvez maintenant éditer $ANSIBLE_CONFIG_DIR/hosts pour ajouter vos serveurs."
