(module config.autocmd
  {import-macros [[{: autocmd} "aniseed.macros.autocmds"]]})

(autocmd ["CompleteDone"] {:command "pclose"})
