#!/bin/sh

set -e

# Users & groups
RTORRENT_USER=rtorrent
RTORRENT_GROUP=nginx

# Directories
RTORRENT_LOG_DIR=/var/log/rtorrent
RTORRENT_RUNTIME_DIR=/var/run/rtorrent
RTORRENT_DATA_DIR=/var/rtorrent
RTORRENT_DATA_DOWNLOAD_DIR="${RTORRENT_DATA_DIR}/download"
RTORRENT_DATA_LOG_DIR="${RTORRENT_DATA_DIR}/log"
RTORRENT_DATA_LOG_EXECUTE_FILE="${RTORRENT_DATA_LOG_DIR}/execute.log"
RTORRENT_DATA_LOG_XMLRPC_FILE="${RTORRENT_DATA_LOG_DIR}/xmlrpc.log"
RTORRENT_DATA_SESSION_DIR="${RTORRENT_DATA_DIR}/.session"
RTORRENT_DATA_WATCH_DIR="${RTORRENT_DATA_DIR}/watch"
RTORRENT_DATA_WATCH_LOAD_DIR="${RTORRENT_DATA_WATCH_DIR}/load"
RTORRENT_DATA_WATCH_START_DIR="${RTORRENT_DATA_WATCH_DIR}/start"
RTORRENT_PRIVATE_LOG_DIR=/var/log/rtorrent-private
RTORRENT_PRIVATE_RUNTIME_DIR=/var/run/rtorrent-private
RTORRENT_PRIVATE_DATA_DIR='/Volumes/SN5000 Private/.rtorrent'
RTORRENT_PRIVATE_DATA_DOWNLOAD_DIR="${RTORRENT_PRIVATE_DATA_DIR}/download"
RTORRENT_PRIVATE_DATA_LOG_DIR="${RTORRENT_PRIVATE_DATA_DIR}/log"
RTORRENT_PRIVATE_DATA_LOG_EXECUTE_FILE="${RTORRENT_PRIVATE_DATA_LOG_DIR}/execute.log"
RTORRENT_PRIVATE_DATA_LOG_XMLRPC_FILE="${RTORRENT_PRIVATE_DATA_LOG_DIR}/xmlrpc.log"
RTORRENT_PRIVATE_DATA_SESSION_DIR="${RTORRENT_PRIVATE_DATA_DIR}/.session"
RTORRENT_PRIVATE_DATA_WATCH_DIR="${RTORRENT_PRIVATE_DATA_DIR}/watch"
RTORRENT_PRIVATE_DATA_WATCH_LOAD_DIR="${RTORRENT_PRIVATE_DATA_WATCH_DIR}/load"
RTORRENT_PRIVATE_DATA_WATCH_START_DIR="${RTORRENT_PRIVATE_DATA_WATCH_DIR}/start"

set_ownership () {
  local file="$1"
  local user="$2"
  local group="$3"
  local mode="$4"

  chown "$user:$group" "$file"
  chmod "$mode" "$file"
}

mk () {
  local directory="$1"
  local user="$2"
  local group="$3"
  local mode="$4"

  mkdir -p "$directory"
  set_ownership "$directory" "$user" "$group" "$mode"
}

make_file () {
  local file="$1"
  local user="$2"
  local group="$3"
  local mode="$4"

  echo "" > "$file"
  set_ownership "$file" "$user" "$group" "$mode"
}

mkrtorrent() {  
  local log_dir="${1}"
  local runtime_dir="${2}"
  local data_dir="${3}"
  local data_download_dir="${4}"
  local data_log_dir="${5}"
  local data_log_execute_file="${6}"
  local data_log_xmlrpc_file="${7}"
  local data_session_dir="${8}"
  local data_watch_dir="${9}"
  local data_watch_load_dir="${10}"
  local data_watch_start_dir="${11}"

  mk "$log_dir" "$RTORRENT_USER" "$RTORRENT_GROUP" u=rwx,go=rx
  mk "$runtime_dir" "$RTORRENT_USER" "$RTORRENT_GROUP" u=rwx,go=rx
  # This needs to be world-writable because the directory may be on a volume which ignores ownership.
  mk "$data_dir" "$RTORRENT_USER" "$RTORRENT_GROUP" a=rwx
  mk "$data_download_dir" "$RTORRENT_USER" "$RTORRENT_GROUP" a=rwx
  mk "$data_log_dir" "$RTORRENT_USER" "$RTORRENT_GROUP" a=rwx
  # make_file "$data_log_execute_file" "$RTORRENT_USER" "$RTORRENT_GROUP" a=rwx
  # make_file "$data_log_xmlrpc_file" "$RTORRENT_USER" "$RTORRENT_GROUP" a=rwx
  mk "$data_session_dir" "$RTORRENT_USER" "$RTORRENT_GROUP" a=rwx
  mk "$data_watch_dir" "$RTORRENT_USER" "$RTORRENT_GROUP" a=rwx
  mk "$data_watch_load_dir" "$RTORRENT_USER" "$RTORRENT_GROUP" a=rwx
  mk "$data_watch_start_dir" "$RTORRENT_USER" "$RTORRENT_GROUP" a=rwx
}

mkrtorrent "$RTORRENT_LOG_DIR" "$RTORRENT_RUNTIME_DIR" \
  "$RTORRENT_DATA_DIR" "$RTORRENT_DATA_DOWNLOAD_DIR" \
  "$RTORRENT_DATA_LOG_DIR" "$RTORRENT_DATA_LOG_EXECUTE_FILE" "$RTORRENT_DATA_LOG_XMLRPC_FILE" \
  "$RTORRENT_DATA_SESSION_DIR" \
  "$RTORRENT_DATA_WATCH_DIR" "$RTORRENT_DATA_WATCH_LOAD_DIR" "$RTORRENT_DATA_WATCH_START_DIR"

mkrtorrent "$RTORRENT_PRIVATE_LOG_DIR" "$RTORRENT_PRIVATE_RUNTIME_DIR" \
  "$RTORRENT_PRIVATE_DATA_DIR" "$RTORRENT_PRIVATE_DATA_DOWNLOAD_DIR" "$RTORRENT_PRIVATE_DATA_LOG_DIR" \
  "$RTORRENT_PRIVATE_DATA_LOG_EXECUTE_FILE" "$RTORRENT_PRIVATE_DATA_LOG_XMLRPC_FILE" \
  "$RTORRENT_PRIVATE_DATA_SESSION_DIR" \
  "$RTORRENT_PRIVATE_DATA_WATCH_DIR" "$RTORRENT_PRIVATE_DATA_WATCH_LOAD_DIR" "$RTORRENT_PRIVATE_DATA_WATCH_START_DIR"
