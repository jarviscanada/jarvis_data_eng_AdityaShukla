#!/bin/sh

#Tasks:
# 1) Assign CLI arguments to variables
# 2) Parse host hardware specifications using bash commands
# 3) Assign the parsed outputs to variables
# 4) Construct the INSERT statement from specification variables
# 5) Execute the INSERT statement through the psql CLI tool

# Variable Assignment
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

#Making sure there are 5 arguments in CLI
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters. 5 parameters are expected to execute this script."
    exit 1
fi

#Local variables defined to be used as part of other commands
lscpu_out=`lscpu`

id=1
hostname=$(hostname -f)
cpu_num=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_arch=$(echo $lscpu_out | egrep "Architecture" | awk '{print $2}')
cpu_model=$(echo "$lscpu_out"  | egrep "Model name:" | awk -F"Model name:" '{print $2}' | xargs)
cpu_mhz=$(echo "$lscpu_out"  | egrep "Model name:" | awk -F"@" '{print $2}' | awk '{print $1*1000}' | xargs)
l2_cache=$(echo "$lscpu_out"  | egrep "L2 cache:" | awk '{print $3}' | xargs)
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')

insert_statement_psql="INSERT INTO host_info(id, hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, timestamp, total_mem) VALUES ($id, '$hostname', $cpu_num, '$cpu_arch', '$cpu_model', $cpu_mhz, $l2_cache, '$timestamp', $total_mem)"

export PGPASSWORD=$psql_password

psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_statement_psql"

exit $?