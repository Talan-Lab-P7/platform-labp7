# Helm Chart for platform-labp7

platform-labp7 est une plateforme big data performante et sécurisée.

## Introduction

platform-labp7 presente une platforme complete pour processer,stocker et secureser les données
la plateforme repose sur ces technologies pour realiser ces taches:
 - spark thrift: moteur de calcule
 - hdfs: stockage distribué des données
 - kerberos: gestion d'authentifications des utilisateurs
 - apache: ranger: gestion des authorisations des utilisateurs
 - apache: ranger kms: gestion des clés de cryptage des données
 - hive metastore: gestion des schemas sql.
 - postgresql: stockage physique des metadonnées de hive
 - ldap: toDo 


## Prerequisites

il faut un cluster kube pour installer la plateforme avec un master et un worker en minimum
Helm version 3.0.0 ou plus
la platforme a besoin du kerberos client avant de commencer l'installation:
 - centos: yum install krb5-workstation krb5-libs
 - ubuntu: apt install krb5-user 


## Installing the Chart

Pour installer la chart, utilisez la commande suivante:
charts\platform-labp7\start.sh ns-name

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `parameter1` | Description of parameter1 | `default_value1` |
| `parameter2` | Description of parameter2 | `default_value2` |

[Include any additional configuration instructions, such as how to override default values or use custom configuration files.]

## Usage
### Configuration de la machine client

1- Installation MIT Kerberos Ticket Manager: https://web.mit.edu/kerberos/dist/
2- Rucuperation d'un ticket Kerberos en utilisant les login/password de l'utilisateur
3- En utilisant un ide de base données (ex: dbeaver) on ca configurer la connection avec spark thrift 
   - type de connection: URL
   - url: jdbc:hive2://(nom ou ip machine kube):30527/default;principal=hive/platform-labp7-spark-0.platform-labp7-spark.test.svc.cluster.local@LABP7.CNAM
4- C:\ProgramData\MIT\Kerberos5\krb5.ini
       ```
   [libdefaults]
   dns_lookup_realm = false
   ticket_lifetime = 24h
   renew_lifetime = 7d
   forwardable = true
   rdns = false
   default_realm = LABP7.CNAM
 
   [realms]
    LABP7.CNAM = {
    kdc = ip_adresse_kube:30226
    admin_server = ip_adresse_kube:30226
    }
    
   ```
5- C:\Users\user\AppData\Local\DBeaver\jaas.conf
   ```
   com.sun.security.jgss.initiate {
   com.sun.security.auth.module.Krb5LoginModule required
   debug=true
   doNotPrompt=true
   useKeyTab=true
   keyTab="C:/kerberos_cache/krb5cache"
   useTicketCache=true
   principal="login introduit dans mit";
   };
    
   ```

### urls des interfaces web

url spark ui: http://ip_adresse_kube:30526/
url hdfs ui: http://ip_adresse_namenode:9870/dfshealth.html#tab-datanode
url ranger admin: http://ip_adresse_kube:30523/login.jsp


## Uninstalling the Chart

Pour désinstaller/supprimer la chart, utilisez la commande suivante :
charts\platform-labp7\start.sh ns-name

La commande supprime tous les composants Kubernetes associés a la chart et supprime la version.

## Troubleshooting

[Include any troubleshooting tips or known issues, along with suggested solutions or workarounds.]

## Contributing

[Include information on how to contribute to the project, such as submitting bug reports or feature requests.]

## License

[Include licensing information for the project.]
