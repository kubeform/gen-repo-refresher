#!/bin/bash
# set -eou pipefail

SCRIPT_ROOT=$(realpath $(dirname "${BASH_SOURCE[0]}"))
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")

GITHUB_USER=${GITHUB_USER:-1gtm}
PR_BRANCH=gen-repo-refresher # -$(date +%s)
COMMIT_MSG="Update dependencies"

REPO_ROOT=/tmp/gen-repo-refresher

refresh() {
    echo "refreshing repository: $1"
    rm -rf $REPO_ROOT
    mkdir -p $REPO_ROOT
    pushd $REPO_ROOT
    git clone --no-tags --no-recurse-submodules --depth=1 https://${GITHUB_USER}:${GITHUB_TOKEN}@$1.git
    cd $(ls -b1)
    git checkout -b $PR_BRANCH
    go env -w GOPRIVATE=kubeform.dev/*
    # ref: https://stackoverflow.com/a/11287896
    if grep -q generator-v1 go.mod; then
        go mod edit \
            -require=kubeform.dev/generator-v1@v0.0.13
    fi
    if grep -q generator-v2 go.mod; then
        go mod edit \
            -require=kubeform.dev/generator-v2@v0.0.29
    fi

    if [[ $2 == *"="* ]]; then
        go mod edit -replace=$2
    else
        go mod edit -require=$2
    fi

    go mod tidy
    go mod vendor
    sed -i 'N;s|go mod edit \\\n    -dropreplace=google.golang.org/api \\|go mod edit \\\n    -require=go.bytebuilders.dev/audit@v0.0.11 \\\n    -dropreplace=google.golang.org/api \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/azure-sdk-for-go \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/go-autorest \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/go-autorest/autorest \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/go-autorest/autorest/adal \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/go-autorest/autorest/date \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/go-autorest/autorest/mocks \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/go-autorest/autorest/to \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/go-autorest/autorest/validation \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/go-autorest/logger \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/go-autorest/tracing \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -dropreplace=github.com/Azure/go-ansiterm \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\\n    -require=kubeform.dev/terraform-backend-sdk@v0.0.0-20210922115523-21574335f0db \\|g' hack/scripts/generate.sh
    # sed -i 'N;s|go mod edit \\\n    -replace=google.golang.org/api=google.golang.org/api@v0.59.0 \\|go mod edit \\\n    -dropreplace=google.golang.org/api \\|g' hack/scripts/generate.sh
    sed -i 's|kmodules.xyz/client-go@13d22e91512b80f1ac6cbb4452c3be73e7a21b88|kmodules.xyz/client-go@5e9cebbf1dfa80943ecb52b43686b48ba5df8363|g' hack/scripts/generate.sh
    sed -i 's|kubeform.dev/apimachinery@7bcd34a30eb5956ae85815ea522e58b0c85db48e|kubeform.dev/apimachinery@ba5604d5a1ccd6ea2c07c6457c8b03f11ab00f63|g' hack/scripts/generate.sh
    # [ -z "$2" ] || (
    #     echo "$2"
    #     $2 || true
    # )
    git add --all
    if git diff --exit-code -s HEAD; then
        echo "Repository $1 is up-to-date."
    else
        git commit -a -s -m "$COMMIT_MSG"
        git push -u origin $PR_BRANCH -f
        hub pull-request \
            --labels automerge \
            --message "$COMMIT_MSG" \
            --message "Signed-off-by: $(git config --get user.name) <$(git config --get user.email)>" || true
    fi
    popd
}

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "Correct usage: $SCRIPT_NAME <path_to_repos_list>"
    exit 1
fi

if [ -x $GITHUB_TOKEN ]; then
    echo "Missing env variable GITHUB_TOKEN"
    exit 1
fi

# ref: https://linuxize.com/post/how-to-read-a-file-line-by-line-in-bash/#using-file-descriptor
while IFS=' ' read -r -u9 repo cmd; do
    if [ -z "$repo" ]; then
        continue
    fi
    refresh "$repo" "$cmd"
    echo "################################################################################"
done 9<$1
