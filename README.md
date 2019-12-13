# manage_ssh_access_with_vault
These scripts can be used enable ssh secrets engine on vault and use the generated key to authenticate on ssh server. 

#Pre-requisites
1. You need to have vault enterprise setup running
2. Have an ubuntu ssh server for which you can manage ssh credentials


#How to use scripts.
1. Execute server_ssh_otp.ssh on vault to enable the secrete engine
2. Execute client_vault_helper.sh on ssh server to setup ssh-vault-helper
3. Generate otp
vault login -method=userpass username=<username> password=<password>
vault write otp/creds/otp_key_role ip=<IP of ssh server>

Example - 
#vault write otp/creds/otp_key_role ip=172.31.14.90

Key                Value

---                -----

lease_id           otp/creds/otp_key_role/l2toadoYSMgl1Uy2CK8H5VfV

lease_duration     768h

lease_renewable    false

ip                 172.31.14.90

key                800d547a-e639-944b-5404-5bd4d00322a6

key_type           otp

port               22

username           ubuntu

4. test your login
#ssh ubuntu@172.31.14.90

and use key '800d547a-e639-944b-5404-5bd4d00322a6' as password.

