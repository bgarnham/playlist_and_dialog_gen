#!/bin/bash 

# Author: Brendan Garnham

# generates a playlist in PLAYLIST_DIR for each subdirectory of MUSIC_DIR
# which contains mp3 and/or flac files, then generates a zenity playlist
# dialog script (DIALOG_SH) for choosing a playlist to play with PLAYER

# the idea is to run this script as needed when the music collection changes,
# and to run the playlist dialog script with a keyboard shortcut or whatever
# is most convenient

# I wrote this for use with parole where the call to parole is simply:
#     parole playlist.m3u
# your player may require different syntax

# The actual DIALOG_SH file will be created but the script assumes
# that MUSIC_DIR, PLAYLIST_DIR and the path FOR DIALOG_SH exist

############## USER VARIABLES ###############
# parent directory of music files
MUSIC_DIR="/home/user/music"
# directory path to save playlists to
PLAYLIST_DIR="/home/user/documents/playlists"
# audio player program
PLAYER="parole"
# path/filename for playlist dialog script
DIALOG_SH="/home/user/bin/playlist_dialog.sh"
#############################################

# set IFS to accommodate spaces in file paths
IFS=$(echo -en "\n\b")

# delete old playlists from PLAYLIST_DIR
echo "Delete old playlists..."
find "$PLAYLIST_DIR" -maxdepth 1 -type f -name '*.m3u' -execdir rm '{}' \;

# for each subdirectory of MUSIC_DIR
for i in $(find "$MUSIC_DIR" \( -name '*.mp3' -o -name '*.flac' \) \
-printf '%h\n' | sort -u) 
do
    echo "Create playlist $(basename $i)..."
    # create a sorted playlist named for the subdirectory
    for j in $(find "$i" -mindepth 1 -maxdepth 1 \
    \( -name '*.mp3' -o -name '*.flac' \) | sort)
        do
        echo "$j" >> "$PLAYLIST_DIR/$(basename $i).m3u"
        done
done

echo "Write dialog to $DIALOG_SH..."
# write header to DIALOG_SH
echo -e "#!/bin/bash 
PLAYLIST=\$(zenity --title=\"Playlists\" \\
--text=\"Select playlist\" \\
--width=800 \\
--height=600 \\
--list \\
--column=playlists \\" > "$DIALOG_SH"

items=""

# generate string of playlist entries
for i in $(find "$PLAYLIST_DIR" -name '*.m3u' | sort)
do
    items="$items\"$(echo $(basename $i .m3u) | sed 's/[$]/\\$/g')\" \\\\\n"
done

unset IFS

# write playlist items and footer to DIALOG_SH
echo -e "${items::-4})
if (( \$? == 0 )); then
    $PLAYER \"$PLAYLIST_DIR/\$PLAYLIST.m3u\"
fi" >> "$DIALOG_SH"

chmod +x "$DIALOG_SH"
