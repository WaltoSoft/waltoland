REPO_LIST = (
  "waltopanel"
  "waltoland-switch"
)

executeScript() {
  installRepoApplications
}

installRepoApplications() {
  for REPO_NAME in "${REPO_LIST[@]}"; do
    local REPO_DIR="${GIT_DIR}/${REPO_NAME}"
    local REPO_URL="https://github.com/waltosoft/${REPO_NAME}.git"

    cloneRepo $REPO_URL $REPO_DIR "${REPO_DIR}/PKGBUILD"

    if [ -f "${REPO_DIR}/PKGBUILD" ]; then
      echo "Installing ${REPO_NAME} from LOCAL..."
      cd $REPO_DIR
      makepkg -si --noconfirm
      echo "Successfully installed ${REPO_NAME} from LOCAL."
    else
      echo "Error: PKGBUILD not found for ${REPO_NAME}. Skipping installation."
    fi
  done
}

executeScript