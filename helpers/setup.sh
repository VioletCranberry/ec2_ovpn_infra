#!/bin/bash

_PATH="$(dirname "$(realpath -s "$0")")" PORT=1194 PROTO="udp"

function get_help() {
  echo "Usage: $0 [-acd]"
  echo " -a (setup  infra)"
  echo " -c (converge ^^ )"
  echo " -d (remove infra)"
}

function set_path() {
	local dirs
	readarray -d '' dirs < <(find "$_PATH/../terraform/infra/" `
	              `-type d -maxdepth 1 -mindepth 1 -print0)
	echo "${dirs[@]}"
}

function set_vars() {
	local vars
	readarray -d '' vars < <(find "$_PATH/../" `
	              `-name "*.tfvars" -print0)
	printf -- "-var-file=%s " "${vars[@]}"
}

function set__all() {
  local dirs
  readarray -d '' dirs < <(find "$_PATH/../ansible/infra" `
	              `-type d -maxdepth 1 -mindepth 1 -print0)
	for dir in "${dirs[@]}"; do
	  cd ../ansible || exit
	  ANSIBLE_HOST_KEY_CHECKING=False `
	 `ansible-playbook `
	 `-i "$dir" `
	 `playbooks/site.yml `
	 `--user "$USER" `
	 `--become `
	 `--become-method sudo `
	 `-vv;
	 done
}

while getopts ":achd" opt; do
  case ${opt} in
	a )
	  for dir in $(set_path); do
	    cd "$dir" || exit
	    terraform init
		  terraform apply `
		   `-auto-approve `
		   `-var instance_user="$USER" `
		   `-var instance_port="$PORT" `
		   `-var openvpn_proto="$PROTO" `
		   `$(set_vars);
		  done
	  ;;
	d )
	  for dir in $(set_path); do
	    cd "$dir" || exit
      terraform destroy `
       `-auto-approve `
	   `-var instance_user="$USER" `
	   `-var instance_port="$PORT" `
	   `-var openvpn_proto="$PROTO" `
       `$(set_vars);
      done
	  ;;
	c )
	  set__all
	  ;;
	h )
	  get_help
	  exit 0
	  ;;
	\? )
	  echo "Invalid option: -$OPTARG" >&2
	  get_help
	  exit 0
	  ;;
  esac
done
