#!/bin/bash

kernelsID=`lspci | cut -c 1-7`
linuxKernelPath=$1

if [ $# -lt 1 ]
then
    echo "Error! usage: $0 ~/pathToKernelSource"
    exit 1
fi

for kernelID in $kernelsID
do
    vendorID=`cat /sys/bus/pci/devices/*$kernelID/vendor`
    deviceID=`cat /sys/bus/pci/devices/*$kernelID/device`

    #find the name of definition of vendorID
    def=`grep -i $vendorID $linuxKernelPath/include/linux/pci_ids.h`
    read -ra definition <<< $def
    #echo $def
    #echo ${definition[1]} #the mnemonic name

    vendorsFiles=`grep -Rl ${definition[1]} $linuxKernelPath/*`
    
    #deviceID=`echo $deviceID | cut -d 'x' -f 2`
    echo $deviceID "vendor:" ${definition[1]}
    for vendorFile in $vendorsFiles
    do
	#echo " -"$vendorFile
        #a=`grep .*pci_devices_id.*'{'.*$deviceID.*'}'.* $vendorFile`
	#echo --$vendorFile
	a=`grep -i $deviceID $vendorFile`
        if [ $? -eq 0 ]
        then
            echo " "-$vendorFile
        fi
    done

done

exit 0
