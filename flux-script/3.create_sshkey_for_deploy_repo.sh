# Not required if use git approach with ssh
export GITHUB_TOKEN=XXXXXXXXXXXX

# Note that the GitHub PAT is stored in the cluster as a Kubernetes Secret named flux-system inside the flux-system namespace.
# If you want to avoid storing your PAT in the cluster, please see how to configure GitHub Deploy Keys.

# Using Github Deploys keys without a PAT (SSH) requires --token-auth=false
# By default, the GitHub deploy key is set to read-only access. If you’re using Flux image automation, you must give it write access with --read-write-key=true.
# To use a SSH key instead of a GitHub PAT, the command changes to flux bootstrap git
# Note that you must generate a SSH private key and set the public key as a deploy key on GitHub in advance.

# We added the private key to 1Password for safe keeping - link TBC

flux bootstrap git \
  --token-auth=false \
  --private-key-file=/home/keith/.ssh/odibets_xops_deploy_prod \
  --url=ssh://git@github.com/Techplain-Ltd/odibets_xops_flux_system \
  --branch=main \
  --path=clusters/prod \
  --context=gke_kareco_africa-south1_odi-prod-cluster

# Deploy Key rotation
# Note that when the PAT is removed or when it expires, the GitHub deploy key will stop working. To regenerate the deploy key,
# delete the flux-system secret from the cluster and re-run the bootstrap command using a valid GitHub PAT.