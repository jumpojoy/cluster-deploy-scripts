# Print the commands being run so that we can see the command that triggers
# an error.  It is also useful for following along as the install occurs.
set -o xtrace

# Begin trapping error exit codes
set -o errexit

# Make sure custom grep options don't get in the way
unset GREP_OPTIONS

# We also have to unset other variables that might impact LC_ALL
# taking effect.
unset LANG
unset LANGUAGE
LC_ALL=en_US.utf8
export LC_ALL

# Make sure umask is sane
umask 022

MANDATORY_PARAMS="CLUSTER_NAME"

# Not all distros have sbin in PATH for regular users.
PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin

# Keep track of the DevStack directory
TOP_DIR=$(cd $(dirname "$0") && pwd)

# Configure proper hostname
# Make sure it exists in /etc/hosts so that is always true.
if ! fgrep -qwe "$LOCAL_HOSTNAME" /etc/hosts; then
  sudo sed -i "s/\(^127.0.0.1.*\)/\1 $LOCAL_HOSTNAME/" /etc/hosts
fi

# Import common functions
source $TOP_DIR/functions-common

# Import functions
source $TOP_DIR/functions

if [[ -f $TOP_DIR/bootstrap.conf ]]; then
  source $TOP_DIR/bootstrap.conf
else
  echo "bootstrap.conf not found. Trying to install from exported ENV"
fi
source $TOP_DIR/bootstraprc

for param in $MANDATORY_PARAMS; do
  if [[ -z "${!param}" ]]; then
    die 'Mandatory variable is not defined'
  fi
done

# Source project function libraries
source $TOP_DIR/lib/salt
source $TOP_DIR/lib/reclass


add_extra_repo_deb "$FORMULA_REPOSITORY_URL,,,$FORMULA_REPOSITORY_GPG"

if is_service_enabled 'salt-master'; then
  install_salt_master
  install_reclass
fi

if is_service_enabled 'salt-minion'; then
  install_salt_minion
fi
