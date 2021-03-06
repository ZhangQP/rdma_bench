#!/usr/bin/env bash
source $(dirname $0)/../scripts/utils.sh
source $(dirname $0)/../scripts/mlx_env.sh
export HRD_REGISTRY_IP="fawn-pluto0"

drop_shm

num_threads=10			# Threads per client machine
blue "Running $num_threads client threads"

# Check number of arguments
if [ "$#" -gt 2 ]; then
  blue "Illegal number of arguments."
  blue "Usage: ./run-machine.sh <machine_id>, or ./run-machine.sh <machine_id> gdb"
	exit
fi

if [ "$#" -eq 0 ]; then
  blue "Illegal number of arguments."
  blue "Usage: ./run-machine.sh <machine_id>, or ./run-machine.sh <machine_id> gdb"
	exit
fi

flags="\
  --num_threads $num_threads \
	--dual_port 1 \
	--use_uc 0 \
	--is_client 1 \
	--machine_id $1 \
	--size 32 \
	--postlist 4 \
  --do_read 1
"

# Check for non-gdb mode
if [ "$#" -eq 1 ]; then
  sudo -E numactl --cpunodebind=0 --membind=0 ../build/rw-tput-receiver $flags
fi

# Check for gdb mode
if [ "$#" -eq 2 ]; then
  sudo -E gdb -ex run --args ../build/rw-tput-receiver $flags
fi
