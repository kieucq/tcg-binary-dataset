#!/bin/bash -l
#SBATCH -N 1
#SBATCH -t 36:00:00
#SBATCH -J extract_domain_ncep
#SBATCH -p gpu --gpus 2
#SBATCH -A r00043 
set -x
module load PrgEnv-gnu
conda activate tc
cd /N/u/ckieu/BigRed200/model/deep-learning/preprocess/ncep
data_dir="/N/project/hurricane-deep-learning/data"
input_dir="${data_dir}/ncep-fnl"
output_dir="${data_dir}/ncep_extracted_41x161_13vars"
bestrack_file="${data_dir}/tc/ibtracs.ALL.list.v04r00.csv"
rm -f ${input_dir}/*/*.idx
rm -rf ${output_dir}

python extract_13vars_grib2.py $input_dir $output_dir --lat 5 45 --lon 100 260
for lead_time in 0 6 12 18 24 30 36 42 48 54 60 66 72;
do
    python create_labels_v2.py --best-track $bestrack_file --observations-dir $output_dir --leadtime $lead_time
    python split_train_test_v1.py --test-from 20210918 --val-from 20210801 --labels $output_dir/tc_${lead_time}h.csv
done

