# the below is used to generate the yaml manifest

# amke sure the secret name matches the name of the secert created in previous step

flux create source git \
 odi-flux-source-git-app-deploy-prod \
--url=ssh://git@github.com/Techplain-Ltd/odibets_xops_deploy_prod \
--branch=main \
--interval=5m0s \
--secret-ref=odi-flux-source-github-prod-auth \
--export \
> github_git_source_dev_apps.yaml

# now add the manifest to the prod folder and copy the kustomize template also