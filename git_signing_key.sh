#!/bin/bash

export GPG_TTY=$(tty)

PARAMETERS_FILE="keyparams.txt"

#cd /tmp

echo "This script will generate a new GPG key and upload it to GitHub"

# Check if openssl is installed
if ! [ -x "$(command -v openssl)" ]; then
  echo "Error: openssl is not installed." >&2
  exit 1
fi

# Check if gpg is installed
if ! [ -x "$(command -v gpg)" ]; then
  echo "Error: gpg is not installed." >&2
  exit 1
fi

# Check if gh is installed
if ! [ -x "$(command -v gh)" ]; then
  echo "Error: gh is not installed." >&2
  exit 1
fi

# Check if gpg-agent is running
if ! gpgconf --list-dirs agent-socket; then
  echo "Error: gpg-agent is not running." >&2
  exit 1
fi
 
# generate a random passphrase and escape special characters
random_passphrase=$(openssl rand -base64 32 | sed 's/[\/&]/\\&/g')

# replace the Passphrase line in keyparams.txt
sed -i "s|Passphrase: .*|Passphrase: $random_passphrase|g" $PARAMETERS_FILE

# Set email
email=$(cat $PARAMETERS_FILE | grep "Name-Email:" | awk '{print $2}')

# Kill the gpg-agent
gpgconf --kill gpg-agent

# Create a list of secret keys based on the email
list_of_secret_keys=$(gpg --list-secret-keys --keyid-format LONG | awk -v email="$email" '/^sec/{id=$2} /<'$email'>/{gsub("rsa2048/", "", id); print id}')
if [ -z "$list_of_secret_keys" ]; then
  echo "No secret keys found for $email"
fi 
if [ -n "$list_of_secret_keys" ]; then
  echo "Secret keys found for $email"
  for secret_key in $list_of_secret_keys;
  do
    # Remove the old keys based on keyparams
    gpg  --no-tty --delete-secret-keys $secret_key && gpg  --no-tty --delete-keys $secret_key
  done
fi

# Remove the old keys based on keyparams
# gpg --delete-secret-keys $(gpg --list-secret-keys --keyid-format LONG | awk -v email="$email" '/^sec/{id=$2} /<'$email'>/{gsub("rsa2048/", "", id); print id}')

# gpg --batch --yes --delete-secret-keys $(gpg --list-secret-keys --keyid-format LONG | grep -E "^sec" | awk '{print $2}' | awk -F'/' '{print $2}')
# generate the key with the parameters in the file keyparams.txt
echo $random_passphrase | gpg --batch --full-generate-key $PARAMETERS_FILE

# get the key id
key_id=$(gpg --list-secret-keys --keyid-format LONG | awk '/^sec/{id=$2} /<'$email'>/{gsub("rsa2048/", "", id); print id}')

echo "Email: $email" 
echo "Key ID: $key_id"

# export the public key
echo $random_passphrase > passphase.txt
echo $random_passphrase | gpg --armor --export $key_id > public_key.asc

# set the name as the default user name
git config --global user.email $email

# set the key as the default signing key
git config --global --replace-all user.signingkey $key_id

# set the gpg program
git config --global gpg.program gpg

# set the commit.gpgSign to true
git config --global commit.gpgSign true

# set the tag.gpgSign to true
git config --global tag.gpgSign true

# set the gpg.program to gpg
git config --global gpg.program gpg

# set the gpg.format to openpgp
git config --global gpg.format openpgp

gh gpg-key add public_key.asc

gpgconf --kill gpg-agent

exit 0

