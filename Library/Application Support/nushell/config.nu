use std/dirs

$env.config.buffer_editor = 'nvim'
$env.config.show_banner = false
$env.PROMPT_COMMAND_RIGHT = {||
  let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {
    ([(ansi rb) ($env.LAST_EXIT_CODE)] | str join)
  } else {
    ""
  }

  $last_exit_code
}

# Homebrew
$env.PATH = $env.PATH | prepend "/usr/local/bin"

# ...

let downloads = $'($env.HOME)/Downloads'
alias cdd = cd ($downloads)
alias cdv = cd $'($downloads)/[@] Videos'
alias open = ^open

# The git configuration to use for managing dotfiles in version control. Information about the repository itself (for
# e.g. the README.md) is stored in ~/.dotfiles (at least, on my system). The design is mostly based on this article:
#
#   https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/
#
# When managing any dotfiles, use `dotfiles`. When managing the repository itself, go to the folder and use `git`. Both
# will list a number of "deleted" files, but this is due to the different working trees. Make sure to be careful so
# only relevant changes are committed.
alias dotfiles = git --git-dir=($env.HOME)/.dotfiles/.git --work-tree=($env.HOME)

def link2 [destination: string ...sources: string] {
  let destination = $destination | path expand

  $sources
    | each {|source|
        let source = $source | path expand
        let target = $'($destination)/(basename $source)'

        ln -s -F -i $source $target
      }
    | ignore
}

def package2 [destination: string, ...sources: string] {
  let destination = $destination | path expand

  $sources 
    | each {|source|
        let source = $source | path expand
        let name = basename $source
        let folder = $'($destination)/($name)'
        let target = $'($folder)/($name).zip'

        mkdir $folder
        dirs add $source
        ^zip -r -0 -FS $target .
        dirs drop
      }
    | ignore
}

let ytdlp_config_video = $'($env.HOME)/.config/yt-dlp/config/video'

def --wrapped ytv [url: string ...rest: string] {
  yt-dlp $url --config-location $ytdlp_config_video ...$rest
}

let mangadex_folder = $'($env.HOME)/Data/Remote/Titles'

def --wrapped mangadex [url: string ...rest: string] {
  (
    mangadex-dl $url
      --path $'($mangadex_folder)/{manga.title} [MangaDex]'
      --filename-chapter '{manga.title} - c{chapter.chapter} (v{chapter.volume}) [MangaDex ({chapter.groups_name})]{file_ext}'
      --no-oneshot-chapter
      --save-as 'cbz'
      --progress-bar-layout 'none'
      --language 'en'
      ...$rest
  )
}

# pyenv
#
# Note that the Python version should be before 3.14 so mangadex-downloader can build optional dependencies.
$env.PYENV_ROOT = "~/.pyenv" | path expand
if (( $"($env.PYENV_ROOT)/bin" | path type ) == "dir") {
  $env.PATH = $env.PATH | prepend $"($env.PYENV_ROOT)/bin" }
$env.PATH = $env.PATH | prepend $"(pyenv root)/shims"
