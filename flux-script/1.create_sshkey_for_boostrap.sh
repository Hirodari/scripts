
# First create a new ssh key pair (NO PASSPHRASE

ssh-keygen -f ~/.ssh/odibets_xops_deploy_prod

#  kubectl get secret flux-system -n flux-system -o jsonpath='{.data.identity}' | base64 --decode

SECRET_PATH=$(realpath ~/.ssh/odibets_xops_deploy_prod)
echo $SECRET_PATH

# Now we must manually add the public key as a deploy key in the flux_system github repository