# Download the vault-ssh-helper
wget https://releases.hashicorp.com/vault-ssh-helper/0.1.4/vault-ssh-helper_0.1.4_linux_amd64.zip

# Unzip the vault-ssh-helper in /usr/local/bin
sudo unzip -q vault-ssh-helper_0.1.4_linux_amd64.zip -d /usr/local/bin

# Make sure that vault-ssh-helper is executable
sudo chmod 0755 /usr/local/bin/vault-ssh-helper

# Set the usr and group of vault-ssh-helper to root
sudo chown root:root /usr/local/bin/vault-ssh-helper

#ecgi Create vaykt ssg gekoer configuration file
echo '
vault_addr = "https://immcanadian.com:8200"
ssh_mount_point = "otp"
ca_cert = "/home/vaultadmin/vault.pem"
allowed_roles = "*"
' > /etc/vault-ssh-helper.d/config.hcl
# enable ChallengeResponseAuthentication
sed -i -e 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' ${SSHD_CONFIG_PATH}
# allow to use PAM
sed -i -e 's/UsePAM no/UsePAM yes/g' ${SSHD_CONFIG_PATH}
# disable password authentication
sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/g' ${SSHD_CONFIG_PATH}
# restart SSH server

### Configure PAM
sed -i -e 's/@include common-auth/#@include common-auth/g' /etc/pam.d/sshd
echo '
auth    requisite pam_exec.so quiet expose_authtok log=/tmp/vaultssh.log /usr/local/bin/vault-ssh-helper -config=/etc/vault-ssh-helper.d/config.hcl
auth optional pam_unix.so not_set_pass use_first_pass nodelay
' >> /etc/pam.d/sshd
systemctl restart sshd
echo 'Use following command to verify if your vault ssh helper configuration is successful. Once done you are ready to use otp based authentication
vault-ssh-helper -verify-only -config="/etc/vault-ssh-helper.d/config.hcl"'
