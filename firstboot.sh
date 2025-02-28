#!/bin/bash

# Log file
LOG_FILE="/var/log/vim_install.log"

# Install Vim
echo "Starting Vim installation..." | tee -a "$LOG_FILE"
apt-get update | tee -a "$LOG_FILE"
apt-get install -y vim | tee -a "$LOG_FILE"

# Check if vimrc.local has been adapted for FreePBX 17
isVimRcAdapted=$(grep "FreePBX 17 changes" /etc/vim/vimrc.local | wc -l)

if [ "$isVimRcAdapted" -eq 0 ]; then
    # Get the VIMRUNTIME path
#    VIMRUNTIME=$(/usr/bin/vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015')
#    VIMRUNTIME_FOLDER=$(echo "$VIMRUNTIME" | sed 's/ //g')

    # Check if VIMRUNTIME_FOLDER is empty and set a default if necessary
#    if [ -z "$VIMRUNTIME_FOLDER" ]; then
#        echo "VIMRUNTIME: $VIMRUNTIME" | tee -a "$LOG_FILE"
#        echo "VIMRUNTIME_FOLDER: $VIMRUNTIME_FOLDER" | tee -a "$LOG_FILE"
#	VIMRUNTIME_FOLDER=$(find /usr/share -type f -name "defaults.vim")  # Set default path
#        echo "VIMRUNTIME_FOLDER was empty. Using default: $VIMRUNTIME_FOLDER" | tee -a "$LOG_FILE"
#    else
#        echo "VIMRUNTIME: $VIMRUNTIME" | tee -a "$LOG_FILE"
#       echo "VIMRUNTIME_FOLDER: $VIMRUNTIME_FOLDER" | tee -a "$LOG_FILE"
#    fi

    # Append FreePBX 17 changes to vimrc.local
    cat <<EOF >> /etc/vim/vimrc.local
" FreePBX 17 changes - begin
" This file loads the default vim options at the beginning and prevents
" that they are being loaded again later. All other options that will be set,
" are added, or overwrite the default settings. Add as many options as you
" wish at the end of this file.

" Load the defaults
source \$VIMRUNTIME/defaults.vim

" Prevent the defaults from being loaded again later, if the user doesn't
" have a local vimrc (~/.vimrc)
let skip_defaults_vim = 1

" Set more options (overwrites settings from /usr/share/vim/vim80/defaults.vim)
" Add as many options as you wish

" Set the mouse mode to 'r'
if has('mouse')
  set mouse=r
endif
" FreePBX 17 changes - end
EOF

    echo "Updated /etc/vim/vimrc.local with FreePBX 17 changes." | tee -a "$LOG_FILE"
else
    echo "No changes made to /etc/vim/vimrc.local; it is already adapted for FreePBX 17." | tee -a "$LOG_FILE"
fi

echo "Vim installation and configuration completed." | tee -a "$LOG_FILE"
