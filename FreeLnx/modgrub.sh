#!/bin/bash
# Grub modification script
# to disable KMS.

device_num=`lspci -vm | grep -e 'VGA' -B 1 | grep -e 'Device' | awk 'BEGIN {FS= " "};{print $2F}'| tail -n1 | cut -c1-7`

vendor_id=`lspci -vmmn | grep -e $device_num -A 3 | grep -e 'Vendor' | awk 'BEGIN {FS= " "} ; {print $2F}'`

device_id=`lspci -vmmn | grep -e $device_num -A 4 | grep -e 'Device:' | awk 'BEGIN {FS= " "} ; {print $2F}'`

sdevice_id=`lspci -vmmn | grep -e $device_num -A 5 | grep -e 'SDevice' | awk 'BEGIN {FS= " "} ; {print $2F}'`

video_brand=`lspci | grep VGA | awk 'BEGIN {FS = " " } ; {print $5F}'`

board_name=`/mnt/usr/sbin/dmidecode | grep -e 'Handle 0x0002' -A 5 | grep -e 'Product Name' | awk 'BEGIN {FS= ": "} ; {print $2F}'`

nv_device_id=`lspci -vm | grep -e '3D controller' -A 2 | awk 'BEGIN {FS= " "};{print $3F}' | tail -n1`

nv_sdevice_id=`lspci -vm | grep -e '3D controller' -A 4 | awk 'BEGIN {FS= " "};{print $3F}' | tail -n1`

case "$vendor_id" in

   # Check for nVidia
   "10de" )	
      modstr1="root=/dev/sda3 vesa=791 nouveau.modeset=0"
      modstr2="quiet splash vesa=791 nouveau.modeset=0"

      cp /mnt/boot/grub/grub.cfg /mnt/boot/grub/grub.tmp
      sync
      cat /mnt/boot/grub/grub.tmp | sed "s+root=/dev/sda3+$modstr1+" > /mnt/boot/grub/grub.cfg
      rm /mnt/boot/grub/grub.tmp
      cp /mnt/etc/default/grub /mnt/etc/default/grub.tmp
      sync
      cat /mnt/etc/default/grub.tmp | sed "s+quiet splash+$modstr2+" > /mnt/etc/default/grub
      rm /mnt/etc/default/grub.tmp
      ;;

   # Check for ATI
   "1002" )
      cp /mnt/boot/grub/grub.cfg /mnt/boot/grub/grub.tmp
      sync
      cat /mnt/boot/grub/grub.tmp | sed 's+root=/dev/sda3+root=/dev/sda3 quiet splash radeon.modeset=0+' > /mnt/boot/grub/grub.cfg
      rm /mnt/boot/grub/grub.tmp
      cp /mnt/etc/default/grub /mnt/etc/default/grub.tmp
      sync
      cat /mnt/etc/default/grub.tmp | sed 's+quiet splash+quiet splash radeon.modeset=0+' > /mnt/etc/default/grub
      rm /mnt/etc/default/grub.tmp
      ;;

   # Check for Intel
   "8086" )
      cp /mnt/boot/grub/grub.cfg /mnt/boot/grub/grub.tmp
      sync
      cat /mnt/boot/grub/grub.tmp | sed 's+root=/dev/sda3+root=/dev/sda3 quiet splash+' > /mnt/boot/grub/grub.cfg
      rm /mnt/boot/grub/grub.tmp
      cp /mnt/etc/default/grub /mnt/etc/default/grub.tmp
      sync
      cat /mnt/etc/default/grub.tmp | sed 's+quiet splash+quiet splash+' > /mnt/etc/default/grub
      rm /mnt/etc/default/grub.tmp
      ;;
esac

#Check for acpi 
if [ $board_name = 2AE0 ]; then
    cp /mnt/boot/grub/grub.cfg /mnt/boot/grub/grub.tmp
      sync
      cat /mnt/boot/grub/grub.tmp | sed 's+root=/dev/sda3+root=/dev/sda3 acpi=off+' > /mnt/boot/grub/grub.cfg
      rm /mnt/boot/grub/grub.tmp
      cp /mnt/etc/default/grub /mnt/etc/default/grub.tmp
      sync
      cat /mnt/etc/default/grub.tmp | sed 's+quiet splash+quiet splash acpi=off+' > /mnt/etc/default/grub
      rm /mnt/etc/default/grub.tmp
fi

#Check for 3335
if [ $board_name = 17A2 ]; then
	cp /mnt/boot/grub/grub.cfg /mnt/boot/grub/grub.tmp
	sync
	cat /mnt/boot/grub/grub.tmp | sed 's+root=/dev/sda3+root=/dev/sda3 reboot=bios+' > /mnt/boot/grub/grub.cfg
	rm /mnt/boot/grub/grub.tmp
	cp /mnt/etc/default/grub /mnt/etc/default/grub.tmp
	sync
	cat /mnt/etc/default/grub.tmp | sed 's+quiet splash+quiet splash reboot=bios+' > /mnt/etc/default/grub
	rm /mnt/etc/default/grub.tmp
fi

# Disabled - only needed if xserver-xorg-video-intel is installed
#Check for nVidia 3D controller with Intel VGA
#if [ $nv_device_id:$nv_sdevice_id = 1140:2aef ]; then
#	cp /mnt/boot/grub/grub.cfg /mnt/boot/grub/grub.tmp
#	sync
#	cat /mnt/boot/grub/grub.tmp | sed 's+root=/dev/sda3+root=/dev/sda3 i915.modeset=0+' > /mnt/boot/grub/grub.cfg
#	rm /mnt/boot/grub/grub.tmp
#	cp /mnt/etc/default/grub /mnt/etc/default/grub.tmp
#	sync
#	cat /mnt/etc/default/grub.tmp | sed 's+quiet splash+quiet splash i915.modeset=0+' > /mnt/etc/default/grub
#	rm /mnt/etc/default/grub.tmp
#fi
