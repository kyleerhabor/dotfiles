## Python

alias py=python

## mangadex-downloader
##
## Where would I be without you...

mangadex () {
  # mangadex-downloader supports configuration via a file, but I personally don't like it, since it's written to on each
  # execution and resolves paths. In other words, it's more so machine configuration than user configuration.
  #
  # Note the exclusion of the --no-group-name option. This option removes group names from folders, leaving us with just
  # the volume and chapter number (e.g. "Vol. 12 Ch. 65"). While the option is ideal, for Mangadex, it's not appropriate
  # to use since N groups may have uploaded for a manga—including for the same chapter. mangadex-downloader does not
  # provide an option for resolving this conflict (it seems to just pick the oldest of the set), making it not ideal if
  # a certain uploader's work is superior. Unfortunately, this requires manual labor, so I'll have to manually find the
  # chapter in question and download the correct one.
  mangadex-dl $1 \
    --language en \
    --folder $HOME/Media/Content \
    --no-oneshot-chapter \
    --progress-bar-layout none \
    ${@:2}
}

## yt-dlp

# Download videos (mostly for YouTube).
#
# The command downloads videos with subtitles (English) and chapters, writing the filename in
# the format "<channel> - <title> [<video id>].<filetype>".
#
# The download preferences are set to prefer AVC video (H.264, but HEVC / H.265 is an option)
# and AAC audio. While YouTube offers several codecs (AV1, AVC, VP9; AAC, Opus), not all can
# be played correctly or efficiently on my device (2019 MacBook Pro). In particular, AV1
# achieves a small filesize at the cost of incinerating my CPU (no hardware decoding support),
# while VP9 results in filesizes up to 5x more than AVC while also incincerating my CPU. The
# current configuration result in most videos looking fine, but can still cause issues (in
# particular, for real-life recordings like Not Just Bikes and China Street View).
#
# Some notes:
# - If a video with a playlist query parameter is given, only the video will be downloaded.
# - SponsorBlock segments are reflected as chapters.
# - No subtitle is set as the default.
ytv () {
  yt-dlp $1 \
    --no-playlist \
    --embed-subs --embed-chapters \
    --write-auto-sub --sub-langs 'en.*' \
    --sponsorblock-mark sponsor,selfpromo,interaction,poi_highlight \
    --format 'bv*[vcodec^=avc]+ba[acodec^=mp4a]' \
    --postprocessor-args 'EmbedSubtitle+ffmpeg:-disposition:s:0 -default' \
    --output '%(channel)s - %(title)s [%(id)s].%(ext)s' \
    ${@:2}
}
