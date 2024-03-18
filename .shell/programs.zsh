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

# --format-sort uses the default sorting options except for size, which uses ascending order.
#
# The video codec is set to prefer HEVC.
ytv () {
  yt-dlp $1 \
    --no-playlist \
    --embed-subs --embed-chapters \
    --write-auto-sub --sub-langs 'en.*' \
    --format-sort lang,vcodec:h265,quality,res,fps,hdr:12,channels,acodec,+size,br,asr,proto,ext,hasaud,source,id \
    --sponsorblock-mark sponsor,selfpromo,interaction,poi_highlight \
    ${@:2}
}
