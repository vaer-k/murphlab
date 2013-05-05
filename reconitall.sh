#!/bin/bash

echo -n "What's the subject ID (Initials)?:"

read ID

echo -n "Drag your BRIK file here and press RETURN----->"

read BRIKFILE

echo -n "What email address do you want your processing updates sent to?:"

read EMAIL

echo -n "Okay, got the FreeSurfer segmentation for ${ID} going. It should be complete in approx 24 hours. You'll receive an email when it's done." | mail -s "The FreeSurfer segmentation process for ${ID} has begun" ${EMAIL}

NIFTI=`echo "$BRIKFILE" | sed 's/\.BRIK.*//'`  #strip BRIK suffix

3dAFNItoNIFTI -prefix ${ID}.nii.gz ${NIFTI}  #convert to NIFTI

RETURNDIR=`echo "$NIFTI" | sed "s/${ID}_.*//"`  

mv ${ID}.nii.gz $RETURNDIR #this moves the nifti file to subj directory

a="a"                 #Forced to add this to keep recon from exiting
if [ $a == a ]
then 
recon-all -i ${RETURNDIR}${ID}.nii.gz -subject ${ID} -all

echo -n "Recon-all of ${ID} has completed." | mail -s "The FreeSurfer segmentation process for ${ID} is COMPLETE!!!" ${EMAIL}
fi
exit
