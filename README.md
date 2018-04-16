# playlist_and_dialog_gen
A short shell script to generate playlists from music dir subdirs, then make a zenity dialog to launch them

generates a playlist in PLAYLIST_DIR for each subdirectory of MUSIC_DIR
which contains mp3 and/or flac files, then generates a zenity playlist
dialog script (DIALOG_SH) for choosing a playlist to play with PLAYER

the idea is to run this script as needed when the music collection changes,
and to run the playlist dialog script with a keyboard shortcut or whatever
is most convenient

I wrote this for use with parole where the call to parole is simply:
    parole playlist.m3u
your player may require different syntax

The actual DIALOG_SH file will be created but the script assumes
that MUSIC_DIR, PLAYLIST_DIR and the path FOR DIALOG_SH exist

############# USER VARIABLES ###############
parent directory of music files
MUSIC_DIR="/home/user/music"
directory path to save playlists to
PLAYLIST_DIR="/home/user/documents/playlists"
audio player program
PLAYER="parole"
path/filename for playlist dialog script
DIALOG_SH="/home/user/bin/playlist_dialog.sh"
############################################
