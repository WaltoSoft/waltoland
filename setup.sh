executeScript() {
  local HOME_DIR=$1
  local GIT_DIR=$HOME_DIR/Git
  local REPO_BRANCH=$2
  local REPO_NAME="waltoland"
  local REPO_DIR="${GIT_DIR}/${REPO_NAME}"
  local REPO_URL="https://github.com/waltosoft/${REPO_NAME}.git"

  displayHeader
  installPackages
  cloneRepo
  startInstallation
}

cloneRepo() {
  if [ ! -d "${GIT_DIR}" ]; then
    mkdir -p "${GIT_DIR}"
  fi

  if [ -d "${REPO_DIR}" ]; then
    rm -rf "${REPO_DIR}"
  fi

  git clone -q --no-progress --depth 1 $REPO_URL "${REPO_DIR}"
  cd $REPO_DIR

  if [ ! -z "${REPO_BRANCH}" ]; then
    git config --get remote.origin.fetch
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git config --get remote.origin.fetch
    git remote update
    git fetch
    git checkout "${REPO_BRANCH}"
  fi
}

displayDefault() { echo -e "\033[0m"; }
displayAqua() { echo -e "\033[36m"; }

displayHeader() {
  clear

  displayAqua
cat << "EOF"
 ____       _               
/ ___|  ___| |_ _   _ _ __  
\___ \ / _ \ __| | | | '_ \ 
 ___) |  __/ |_| |_| | |_) |
|____/ \___|\__|\__,_| .__/ 
                     |_|                                                                                       
EOF
  displayDefault

  read -p "First we need to download the installation scripts.  Do you want to continue? (y/n): " answer

  case $answer in
    [Yy]* ) 
        echo "Continuing..."
        ;;
    [Nn]* ) 
        echo "Exiting..."
        exit 0
        ;;
    * ) 
        echo "Invalid response."
        exit 0
        ;;
  esac  
}

installPackages() {
  sudo pacman -Syu
  sudo pacman -Fy
  sudo pacman -Sq --noconfirm debugedit vim git gum rsync fakeroot figlet
}

startInstallation() {
  cd "${REPO_DIR}/scripts"
  chmod +x install.sh
  ./install.sh ${HOME_DIR}
}

set -e

while getopts ":b:" option; do
  case $option in
    b)  executeScript "${OPTARG}"
        exit 0
        ;;
    :)  echo "Option -${OPTARG} requires an argument."
        exit 1;;
    ?)  echo "Invalid option: -${OPTARG}." 
        exit 1
        ;;
  esac
done

executeScript
