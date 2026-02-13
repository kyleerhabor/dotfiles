# For a source file and destination directory, create a symbolic link in the destination with the source's filename.
link2 () {
  local dst="$1"

  for src in "${@:2}"; do
    local dest="$dst/$(basename $src)"

    ln -s -F -i "$src" "$dest"
  done
}

package2 () {
  local dst="$1"

  for src in "${@:2}"; do
    local name="$(basename $src)"
    local folder="$dst/$name"
    local dest="$dst/$name/$name.zip"

    mkdir "$folder"
    pushd "$src"

    # Funnily enough, -0 has generated smaller filesizes than -9 for me, at times.
    zip -r -0 -FS "$dest" .
    popd
  done
}

## Python

alias py=python

## mangadex-downloader

MANGADEX_FOLDER_PATH=$HOME/Data/Remote/Titles

_mangadex () {
  local url=$1

  # For 8.2 MB, level 9 compression from deflated, bzip2, or lzma yields 8 MB. It's not much, but hey...
  mangadex-dl "$url" \
    --path "$MANGADEX_FOLDER_PATH/{manga.title} [MangaDex]" \
    --filename-chapter "{manga.title} - c{chapter.chapter} (v{chapter.volume}) [MangaDex ({chapter.groups_name})]{file_ext}" \
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
