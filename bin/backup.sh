#!/usr/bin/env bash

# MIT License
# 
# Copyright (c) 2019 Subhadip Ghosh
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

exec_admin_command() {
    if $user_has_sudo; then
        sudo $1
    else
        su -c "$1"
    fi
}

# Find the pretty hostname
# backup_laptop
comp_name=`hostnamectl --pretty`

if [ -z $comp_name ]; then
    echo "Computer name not set. Exiting"
    exit 1
fi

user_has_sudo=false
sudo -v 2>/dev/null
if [ $? -eq 0 ]; then
    user_has_sudo=true
fi
#TODO remove
echo User sudo status: $user_has_sudo

# List of directories that needs to be backed up
# Paths are relative from the user's home directory
backed_dirs[0]='Documents'
#backed_dirs[1]='Notebooks'
#backed_dirs[2]='Music'
#backed_dirs[3]='Pictures'
#backed_dirs[4]='Videos'

#TODO remove
#declare -A synced_dirs
#synced_dirs["/home/${USER}/Documents"]="backup_laptop"
#synced_dirs["/home/${USER}/Notebooks"]="backup_laptop"
#synced_dirs["/home/${USER}/Music"]="backup_laptop"
#synced_dirs["/home/${USER}/Pictures"]="backup_laptop"
#synced_dirs["/home/${USER}/Videos"]="backup_laptop"

device_label='TOSHIBA EXT'
mount_path="/media/${USER}/ext_hdd"

# Get the device path with the matching label
device_path=''
IFS_ORIG=$IFS
IFS='\n'
while read line
do
 label=`echo ${line} | cut -f2- -d' '`
 if [ "$label" = $device_label ]; then
     device_path=`echo ${line} | cut -f1 -d' '`
     break
 fi
done <<<`lsblk -f -o NAME,LABEL -l -n -p`
IFS=$IFS_ORIG

if [ -z "$device_path" ]; then
    echo "Device path not found. Exiting"
fi

# Mount the external drive
echo Mounting ${device_path} to ${mount_path}. Continue?
read choice
if [ "$choice" != "y" ]; then
    echo Selected $choice. Exiting.
    exit 1
fi

# Create the mount path if not exists
if [ ! -d ${mount_path} ]; then
    echo Path ${mount_path} does not exists. Creating..
    exec_admin_command "mkdir -p ${mount_path}"
fi

echo Mounting..
exec_admin_command "mount -t ntfs ${device_path} ${mount_path}"

echo

# Sync every path in synced_dir
for dir in "${backed_dirs[@]}"
do
    echo Syncing /home/${USER}/${dir} to ${mount_path}/${comp_name}/${dir} ..
    rsync -av --delete "/home/${USER}/${dir}" "${mount_path}/${comp_name}"
done

# Unmount the external drive
echo Unmounting ${device_path} ..
exec_admin_command "umount ${device_path}"
