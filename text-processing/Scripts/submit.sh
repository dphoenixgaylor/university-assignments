#!/bin/bash -1
# re-submitting because I used interactive mode when I submitted the last job
# would not use so many cpus when others needed the cluster
SBATCH --partition=staclass
SBATCH --cpus-per-task=50
SBATCH --job-name=Gaylor_hw4

bash hw4.sh
