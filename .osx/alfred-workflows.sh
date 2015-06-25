#!/bin/bash

# Alfred workflows
workflows=(
  https://raw.github.com/willfarrell/alfred-pkgman-workflow/master/Package%20Managers.alfredworkflow
  https://raw.github.com/willfarrell/alfred-caniuse-workflow/master/caniuse.alfredworkflow
  https://raw.github.com/willfarrell/alfred-encode-decode-workflow/master/encode-decode.alfredworkflow
  https://raw.github.com/willfarrell/alfred-github-workflow/master/Github.alfredworkflow
  https://github.com/nathangreenstein/alfred-process-killer/raw/master/Kill%20Process.alfredworkflow
  https://github.com/tzarskyz/Alfred-1/blob/master/stackoverflow.alfredworkflow?raw=true
  https://github.com/bachya/lp-vault-manager/raw/master/LastPass%20Vault%20Manager.alfredworkflow
)

mkdir /tmp/workflows
pushd /tmp/workflows
for path in "${workflows[@]}"; do
  wget "$path"
done
popd
echo "All workflows have been downloaded to /tmp/workflows."
echo "You need to open them manually to import them into alfred."
