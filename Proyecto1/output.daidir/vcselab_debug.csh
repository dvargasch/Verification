#!/bin/csh -f

cd /mnt/vol_NFS_rh003/Est_Verif_II2023/DanielaVargas/Verification/Proyecto1

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/mnt/vol_NFS_rh003/tools/vcs/R-2020.12-SP2/linux64/bin/vcselab $* \
    -o \
    output \
    -nobanner \

cd -

