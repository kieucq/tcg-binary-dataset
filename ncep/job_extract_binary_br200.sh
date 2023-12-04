#!/bin/bash -l
#SBATCH -N 1
#SBATCH -t 36:00:00
#SBATCH -J extract_binary_ncep
#SBATCH -p gpu --gpus 2
#SBATCH -A r00043 
set -x
module load PrgEnv-gnu
conda activate tc
cd /N/u/ckieu/BigRed200/model/deep-learning/preprocess/ncep
data_dir="/N/project/hurricane-deep-learning/data"
input_dir="${data_dir}/ncep-fnl/grib1/"
bestrack_dir="${data_dir}/tc/ibtracs.ALL.list.v04r00.csv"

domain_size=18
lead_time=0
basin="EP"
pos_neg_dist=35
for lead_time in 00 06 12 18 24 30 36 42 48 54 60 66 72;
do
    rm -f ${input_dir}/*/*.idx
    #output_dir="${data_dir}/ncep_extracted_binary_${domain_size}x${domain_size}/${basin}/${lead_time}"
    output_dir="${data_dir}/tmp_extracted_binary_${domain_size}x${domain_size}/${basin}/${lead_time}" 
    rm -rf $output_dir
    echo "Working with lead time $lead_time $output_dir" 
    python create_ncep_binary_stormcenter_grib1.py --best-track $bestrack_dir --ncep-fnl $input_dir --basin $basin --leadtime $lead_time --domain-size ${domain_size} --distance $pos_neg_dist --output $output_dir
done
