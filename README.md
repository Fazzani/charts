# OpenVPN Helm chart

[![Build Status](https://dev.azure.com/fazzaniheni/openvpn/_apis/build/status/Fazzani.openvpn?branchName=master)](https://dev.azure.com/fazzaniheni/openvpn/_build/latest?definitionId=4&branchName=master)

[Helm Repository](https://fazzani.synker.ovh/openvpn/)

## docs

- [OpenVPN_Access_Server_Sysadmin_Guide_Rev](https://openvpn.net/images/pdf/OpenVPN_Access_Server_Sysadmin_Guide_Rev.pdf)
- [Docker image repo](https://github.com/linuxserver/docker-openvpn-as)

## TODO

- [x] ci/helm repo
  - [x] [chart repo with github pages](helm_repo_github_doc)
  - [x] [chart repo github 2](helm_repo_github_doc2)
- [ ] cluster configuration
- [ ] bridge and routed configuration
- [ ] env variables

## Spec

### envs

```sh
# cat config/exports

export AS_VERSION="2.7.5"
export AS_BUILD="932a08a3"
export OPENVPN_AS_BASE="/usr/local/openvpn_as"
export OPENVPN_AS_CONFIG="/usr/local/openvpn_as/etc/as.conf"
export PATH="/usr/local/openvpn_as/scripts:/usr/local/openvpn_as/bin:/usr/local/openvpn_as/sbin:$PATH"
export LD_LIBRARY_PATH="/usr/local/openvpn_as/lib"
export LDFLAGS="-L/usr/local/openvpn_as/lib"
export CPPFLAGS="-I/usr/local/openvpn_as/include"
export PS1="AS> "
export PYTHONHOME="/usr/local/openvpn_as"
```

### log

//cat config/log/openvpn.log
//cat config/init.log

### auth config

```conf
# cat config/etc/as.conf



# OpenVPN AS 1.1 configuration file
#
# NOTE:  The ~ symbol used below expands to the directory that
# the configuration file is saved in

# remove for production
# DEBUG=false

# enable AS Connect functionality
AS_CONNECT=true

# temporary directory
tmp_dir=/openvpn/tmp

lic.dir=~/licenses

# run_start retries
run_start_retry.give_up=60
run_start_retry.resample=10

# enable client gateway
sa.show_c2s_routes=true

# certificates database
certs_db=sqlite: ///~/db/certs.db

# user properties DB
user_prop_db=sqlite: ///~/db/userprop.db

# configuration DB
config_db=sqlite: ///~/db/config.db

# configuration DB Local
config_db_local=sqlite: ///~/db/config_local.db

# cluster DB
cluster_db=sqlite: ///~/db/cluster.db

# notification DB
notification_db=sqlite: ///~/db/notification.db

# log DB
log_db=sqlite: ///~/db/log.db

# wait this many seconds between failed retries
db_retry.interval=1

# how many retries to attempt before failing
db_retry.n_attempts=6

# On startup, wait up to n seconds for DB files to become
# available if they do not yet exist.  This is generally
# only useful on secondary nodes used for standby purposes.
# db_startup_wait=

# Node type: PRIMARY|SECONDARY.  Defaults to PRIMARY.
# node_type=

# bootstrap authentication via PAM -- allows
# admin to log into web UI before authentication
# system has been configured.  Configure PAM users
# allowed to access via the bootstrap auth mechanism.
boot_pam_service=openvpnas
boot_pam_users.0=admin
# boot_pam_users.1=
# boot_pam_users.2=
# boot_pam_users.3=
# boot_pam_users.4=

# System users that are allowed to access the server agent XML API.
# The user that the web server will run as should be in this list.
system_users_local.0=root
system_users_local.1=abc

# The user/group that the web server will run as
cs.user=abc
cs.group=abc

# socket directory
general.sock_dir=/openvpn/sock

# path to linux openvpn executable
# if undefined, find openvpn on the PATH
#general.openvpn_exe_path=

# source directory for OpenVPN Windows executable
# (Must have been built with MultiFileExtract)
sa.win_exe_dir=~/exe

# The company name will be shown in the UI
# sa.company_name=Access Server

# server agent socket
sa.sock=/openvpn/sock/sagent

# If enabled, automatically generate a client configuration
# when a client logs into the site and successfully authenticates
cs.auto_generate=true

# files for web server (PEM format)
cs.ca_bundle=~/web-ssl/ca.crt
cs.priv_key=~/web-ssl/server.key
cs.cert=~/web-ssl/server.crt

# web server will use three consecutive ports starting at this
# address, for use with the OpenVPN port share feature
cs.dynamic_port_base=870

# which service groups should be started during
# server agent initialization
sa.initial_run_groups.0=web_group
#sa.initial_run_groups.1=openvpn_group

# use this twisted reactor
sa.reactor=epoll

# The unit number of this particular AS configuration.
# Normally set to 0.  If you have multiple, independent AS instances
# running on the same machine, each should have a unique unit number.
sa.unit=0

# If true, open up web ports on the firewall using iptables
iptables.web=true

vpn.server.user=abc
vpn.server.group=abc
```

### network config

```json
// cat config/etc/config-local.json

{
  "Default": {
    "admin_ui.https.ip_address": "all",
    "admin_ui.https.port": "943",
    "cs.https.ip_address": "all",
    "cs.https.port": "943",
    "host.name": "94.177.201.235",
    "vpn.client.routing.inter_client": "false",
    "vpn.client.routing.reroute_dns": "true",
    "vpn.client.routing.reroute_gw": "true",
    "vpn.daemon.0.client.netmask_bits": "20",
    "vpn.daemon.0.client.network": "172.27.224.0",
    "vpn.daemon.0.listen.ip_address": "all",
    "vpn.daemon.0.listen.port": "9443",
    "vpn.daemon.0.listen.protocol": "tcp",
    "vpn.daemon.0.server.ip_address": "all",
    "vpn.server.daemon.enable": "true",
    "vpn.server.daemon.tcp.n_daemons": 1,
    "vpn.server.daemon.tcp.port": "9443",
    "vpn.server.daemon.udp.n_daemons": 1,
    "vpn.server.daemon.udp.port": "1194",
    "vpn.server.port_share.enable": "true",
    "vpn.server.port_share.ip_address": "1.2.3.4",
    "vpn.server.port_share.port": "1234",
    "vpn.server.port_share.service": "admin+client",
    "vpn.server.routing.private_access": "nat",
    "vpn.server.routing.private_network.0": "172.17.0.0/16"
  },
  "_INTERNAL": {
    "run_api.active_profile": "Default",
    "webui.edit_profile": "Default"
  }
```

[helm_repo_github_doc]:https://www.jacobtomlinson.co.uk/posts/2019/how-to-create-a-helm-chart-repository-with-chartpress-travis-ci-github-pages-and-jekyll/
[helm_repo_github_doc2]:https://medium.com/@mattiaperi/create-a-public-helm-chart-repository-with-github-pages-49b180dbb417