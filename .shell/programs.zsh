# For a source file and destination directory, create a symbolic link in the destination with
# the source's filename.
link2 () {
  local src=$1
  local path2=$2
  local dst="$path2/$(basename $src)"

  ln -s -F -i "$src" "$dst"
}

## Python

alias py=python

## mangadex-downloader

MANGADEX_FOLDER=$HOME/Data/Remote/Titles

_mangadex () {
  local url=$1

  # Note the exclusion of the --no-group-name option. This option removes group names from
  # folders, leaving us with just the volume and chapter number (e.g. "Vol. 12 Ch. 65"). While
  # the option is ideal, it's not appropriate to use since N groups may have uploaded for a
  # manga—including for the same chapter. mangadex-downloader does not provide a option for
  # resolving this conflict (it seems to just pick the oldest of the set), making it not ideal
  # if a certain uploader's work is superior. Unfortunately, this requires manual labor, so
  # I'll have to manually find the chapter in question and download the correct one.
  mangadex-dl "$url" \
    --folder "$MANGADEX_FOLDER" \
    --no-oneshot-chapter \
    --save-as cbz \
    --progress-bar-layout none \
    "${@:2}"
}

# Download chapters from Mangadex
mangadex () {
  local url=$1

  _mangadex "$url" --language en "${@:2}"
}

mdcover () {
  local url=$1

  _mangadex "cover:$url" --language all "${@:2}"
}

## yt-dlp

YTDLP_CONFIG_VIDEO=$HOME/.config/yt-dlp/config/video
YTDLP_CONFIG_MUSIC=$HOME/.config/yt-dlp/config/music

# Download videos (mostly from YouTube).
#
# The command downloads videos with English subtitles and chapters, writing the filename in
# the format "<channel> - <title> [<video id>].<filetype>".
#
# The download preferences are set to prefer AVC video (H.264, but HEVC / H.265 is an option)
# and AAC audio. While YouTube offers several codecs (AV1, AVC, VP9; AAC, Opus), not all can
# be played correctly or efficiently on my device (2019 MacBook Pro). In particular, AV1 and
# VP9 achieve small filesizes at the cost of incinerating my CPU. The current configuration
# results in most videos looking fine, but can still cause issues (in particular, for real-life
# recordings like Not Just Bikes and China Street View).
#
# Some notes:
# - If a video with a playlist query parameter is given, only the video will be downloaded.
# - SponsorBlock segments are reflected as chapters.
#
# TODO: Disable default subtitles.
ytv () {
  local url=$1

  yt-dlp $url --config-location $YTDLP_CONFIG_VIDEO ${@:2}
}

ytm () {
  local url=$1

  yt-dlp $url --config-location $YTDLP_CONFIG_MUSIC ${@:2}
}

## rtorrent

# Start RTorrent
alias rt=rtorrent

## Neovim

# Set nvim as the default editor.
export EDITOR=nvim
