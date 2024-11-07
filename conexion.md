Pour connecter votre serveur backend à la base de données PostgreSQL flexible que vous avez créée, suivez ces étapes. Ces instructions couvrent les configurations réseau et les vérifications de connectivité nécessaires pour que votre serveur backend puisse communiquer avec la base de données.

### 1. **Vérifier les paramètres réseau**

Vous avez défini un sous-réseau dédié pour la base de données et un autre pour le backend. Assurez-vous que le peering entre le **sous-réseau backend** et le **sous-réseau database** est bien configuré si les sous-réseaux sont dans différents réseaux virtuels (VNets).

- Si les deux sous-réseaux sont dans la même **VNet** (`vnet-backend`), la connectivité est automatique.
- Si les sous-réseaux sont dans des VNets distinctes, assurez-vous que le **peering** entre les VNets est configuré et fonctionnel.

### 2. **Accès à la base de données depuis le backend**

#### a. **Installer PostgreSQL Client sur la machine backend**
Si votre machine backend n'a pas encore l'outil PostgreSQL (`psql`) installé, vous pouvez l'installer en vous connectant à votre VM backend.

```bash
# Connexion SSH à la VM backend
ssh sigl-backend-admin@<public-ip-backend>

# Installation du client PostgreSQL
sudo apt update
sudo apt install postgresql-client -y
```

#### b. **Se connecter à la base de données PostgreSQL depuis la VM**

Une fois sur votre VM backend, utilisez le client PostgreSQL pour vous connecter à la base de données en utilisant les identifiants que vous avez fournis dans votre script Terraform :

```bash
psql -h pgsql-sigl-server.postgres.database.azure.com -U sigladmin -d sigl-postgres-db -W
```

### 3. **Configurer votre application backend pour se connecter à la base de données**

Dans le fichier de configuration de votre application backend (si vous avez une application en Python, Node.js, etc.), vous devez inclure les détails de connexion à la base de données PostgreSQL :

```bash
DB_HOST=pgsql-sigl-server.postgres.database.azure.com
DB_PORT=5432
DB_USER=sigladmin@pgsql-sigl-server
DB_PASSWORD=<admin_password>
DB_NAME=sigl-postgres-db
```

Assurez-vous que le fichier de configuration de votre application backend est correctement configuré pour se connecter à PostgreSQL.

### 4. **Vérifications supplémentaires**

#### a. **Vérifier la connectivité réseau**
Pour tester la connectivité réseau entre votre VM backend et la base de données, utilisez l'outil `nc` (netcat) pour vérifier si le port 5432 (par défaut pour PostgreSQL) est accessible :

```bash
nc -zv <postgresql-server-name>.postgres.database.azure.com 5432
```

#### b. **Vérifier les logs**
Sur votre serveur PostgreSQL flexible, vous pouvez surveiller les logs de connexion pour voir si votre serveur backend tente de se connecter.

Dans le portail Azure, allez dans la section **PostgreSQL Flexible Server** > **Logs** pour voir les tentatives de connexion et les erreurs éventuelles.

Pour monter un disque managé sur votre serveur backend sous Azure, vous devez suivre une série d'étapes dans votre configuration Terraform. Ces étapes comprennent la création du disque managé, l'attachement de ce disque à votre machine virtuelle existante et la configuration pour l'utiliser sous Linux.

### Étapes pour Monter le Disque Managé

1. **Créer le disque managé** (si ce n'est pas déjà fait).
2. **Attacher le disque managé à la machine virtuelle**.
3. **Configurer le système de fichiers sur le disque (pour Linux)**.

Voici comment procéder :

### 1. Créer le Disque Managé

Si vous avez déjà un disque managé créé dans votre configuration Terraform, vous pouvez passer cette étape. Sinon, voici un exemple de comment créer un disque managé :

```hcl
resource "azurerm_managed_disk" "managed_disk" {
  name                 = "managed-disk"
  location             = azurerm_resource_group.storage_rg.location
  resource_group_name  = azurerm_resource_group.storage_rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 64
}
```

### 2. Attacher le Disque Managé à la Machine Virtuelle

Vous devez référencer votre machine virtuelle existante et attacher le disque managé à celle-ci. Voici comment faire cela avec Terraform :

```hcl
data "azurerm_virtual_machine" "vm" {
  name                = "sigl-backend-server"
  resource_group_name = "backend-rg"  # Remplacez par le nom correct de votre groupe de ressources
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  virtual_machine_id = data.azurerm_virtual_machine.vm.id  # Référence à l'ID de la VM
  managed_disk_id    = azurerm_managed_disk.managed_disk.id  # Référence à votre disque managé
  lun                = 0                                        # Numéro logique d'unité pour le disque
  caching            = "ReadWrite"                             # Type de mise en cache
}
```

### 3. Configurer le Système de Fichiers sur le Disque (pour Linux)

Après avoir attaché le disque, vous devez le formater et le monter sur le serveur. Cela se fait généralement après avoir exécuté `terraform apply`, car vous devez vous connecter à la machine virtuelle pour exécuter les commandes nécessaires.

2. **Vérifiez que le disque est visible** :

   ```bash
   sudo fdisk -l
   ```

   Vous devriez voir quelque chose comme `/dev/sdc` ou `/dev/sdd` selon la configuration de votre VM.

3. **Formatez le disque** (remplacez `/dev/sdc` par le bon chemin si nécessaire) :

   ```bash
   sudo mkfs -t ext4 /dev/sdc
   ```

4. **Créez un point de montage** :

   ```bash
   sudo mkdir /mnt/mydata
   ```

5. **Montez le disque** :

   ```bash
   sudo mount /dev/sdc /mnt/mydata
   ```

6. **Pour rendre le montage persistant** au redémarrage, ajoutez une entrée dans `/etc/fstab` :

   ```bash
   echo '/dev/sdc /mnt/mydata ext4 defaults 0 2' | sudo tee -a /etc/fstab
   ```

### Résumé

Avec ces étapes, vous aurez monté votre disque managé sur votre serveur backend. Assurez-vous que votre configuration Terraform est correcte, exécutez les commandes après avoir appliqué les changements et configurez le disque pour une utilisation persistante. Si vous avez des questions supplémentaires ou des problèmes, n'hésitez pas à demander !