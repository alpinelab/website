GIT_COMMITTER_NAME=$(git config user.name)
GIT_COMMITTER_EMAIL=$(git config user.email)

BUILD_DIR=build
BUILD_BRANCH=build_$(date +%Y-%m-%d_%H-%M-%S)
PUBLISH_BRANCH=${BUILD_BRANCH}_gh-pages

function prepare_build {
  git checkout -q master && \
  git pull -q origin master && \
  rm -rf ${BUILD_DIR}
}

function build_in_a_new_branch {
  git checkout -q -B ${BUILD_BRANCH} && \
  middleman build && \
  git add --force ${BUILD_DIR} && \
  git commit -q --no-gpg-sign --message "Middleman build $(date +'%Y-%m-%d %H:%M:%S')"
}

function publish_build_directory {
  git subtree split --prefix ${BUILD_DIR} --branch ${PUBLISH_BRANCH} && \
  git push -q --force origin ${PUBLISH_BRANCH}:gh-pages
}

function cleanup {
  git checkout -q master && \
  git branch -q -D ${BUILD_BRANCH} ${PUBLISH_BRANCH} && \
  rm -rf ${BUILD_DIR}
}

prepare_build           && \
build_in_a_new_branch   && \
publish_build_directory && \
cleanup                 && \
echo "Middleman site built and published 🚀"
