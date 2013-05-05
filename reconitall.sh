#!/bin/bash

echo -n "What's the subject ID (Initials)?:"

read ID

echo -n "Drag your BRIK file here and press RETURN----->"

read BRIKFILE

echo -n "What email address do you want your processing updates sent to?:"

read EMAIL

echo -n "Okay, got the FreeSurfer segmentation for ${ID} going. I believe it should be finished in approximately 23 years, err, I mean hours, yeah hours. Don't worry, I'll email you when it's done." | mail -s "The FreeSurfer segmentation process for ${ID} has begun" ${EMAIL}

NIFTI=`echo "$BRIKFILE" | sed 's/\.BRIK.*//'`  #strip BRIK suffix

3dAFNItoNIFTI -prefix ${ID}.nii.gz ${NIFTI}  #convert to NIFTI

RETURNDIR=`echo "$NIFTI" | sed "s/${ID}_.*//"`  

mv ${ID}.nii.gz $RETURNDIR #this moves the nifti file to subj directory

a="a"                 #Forced to add this to keep recon from exiting
if [ $a == a ]
then 
recon-all -i ${RETURNDIR}${ID}.nii.gz -subject ${ID} -all

echo -n "Okay, well, it's done. Finally, amirite? I trust it didn't really take years.  God, that would be awful.  I mean, you'd be all old, and stuff, and you probably wouldn't even have any use for this data anymore. I mean, unless it's one of those longitudinal things.  But I mean, come on. Wait, is it?  Is it one of those longitudinal things?  Well anyway, it's done, so what's next is up to you." | mail -s "The FreeSurfer segmentation process for ${ID} is COMPLETE!!!" ${EMAIL}
fi
exit