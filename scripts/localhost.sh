echo =========================================================
echo Running $0 with $# arguments
echo [processID] $$
echo [arguments] $@
echo =========================================================

URL_PATH="notebook"
PORT=9999

separator_start() {
  echo '================================================================================= v';
}

separator_end() {
  echo '================================================================================= ^';
}

banner() {
  separator_start
  echo $1
  separator_end
}

case $1 in
  git)
    banner "git fetch --all -p; git pull; git status;"
    git fetch --all -p; git pull; git status;
    git merge origin/main;
    # git push;
    ;;
  start)
    banner "docker compose up"
    docker compose -f ./docker/docker-compose.yml up server -d
    cmd=$( open -a "Google Chrome" http://localhost:9999/$URL_PATH/ )
    echo opening chrome $cmd
    ;;
  stop)
    banner "docker compose down"
    docker compose -f ./docker/docker-compose.yml down
    ;;
  kill)
    # echo $(netstat -vanp tcp | grep 9999)
    banner "find process_id using the port $PORT and kill the process"
    PROCESS_ID=$(lsof -t -i:$PORT)
    if [ -n "$PROCESS_ID" ]; then
      echo "port $PORT is being used by $PROCESS_ID"
      kill -9 $PROCESS_ID
    else
      echo "No port assigned to kill process"
    fi
    ;;
  *)
    echo "  git - sync latest from main"
    echo "  start - start local"
    echo "  stop - stop local"
    echo "  kill - kill process using port"
    ;;
esac

echo
