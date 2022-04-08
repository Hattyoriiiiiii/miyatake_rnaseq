#!/bin/bash

########## <<< functions >>> ##########

function mkproj()
{
    if [ ! -d "$@"} ]; then
        printf "\n Making a directory named \"${@}\" \n"
        mkdir -p "$@"
    else
        printf "\n There is already a directory named \"${@}\" \n"
    fi
}


########## <<< config >>> ##########

DIR=(data log others summary QualityAssessment 01_qc/{before/multiqc_before,after/multiqc_after} 02_trim 03_align 04_RSEM 05_rsem_counts 06_diff 07_topgo 08_reactomepa notebooks/{data,figures})
LINK=(01_qc/before/multiqc_before 01_qc/after/multiqc_after others scripts summary log notebooks QualityAssessment)

########## Making directories ##########

for directory in "${DIR[@]}"; do
    mkproj ${directory}
done

# For loop proccesing
touch README.md others/{sample.txt,rename.sh,rename.csv,SRR_Acc_List.txt}

# For scripts
# git clone

########## change directory to make symbolic link ##########
printf "\n <<< Type project name (e.g. RNA_Stra8) >>> \n\n"
read projname

mkproj REPORTS_${projname}; cd REPORTS_${projname}

for path in "${LINK[@]}"; do
    basename=`echo ${path} | xargs basename`
    ln -s ../${path} ${basename}
done


if type tree
then
    tree ~/work
else
    pwd; find ~/work | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'
fi

echo