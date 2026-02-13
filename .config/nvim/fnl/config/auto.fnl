(local {: highlight-duration} (require "config.core"))
(local n (require "nfnl.core"))
(local str (require "nfnl.string"))

(fn group [name opts]
  (let [opts (or opts {})]
    (vim.api.nvim_create_augroup name opts)))

(fn command [name group options]
  (vim.api.nvim_create_autocmd name
    (n.merge {"group" group}
      options)))

(local me (group "Me"))
(local comments {"fennel" ";; %s"})

(command "FileType" me
  {"pattern" (n.keys comments)
   "callback" (fn [{:match filetype}]
                (set vim.opt_local.commentstring (. comments filetype)))})

(command "TextYankPost" me
  {"callback" #(vim.highlight.on_yank {"timeout" highlight-duration})})

(command "LspAttach" me
  {"callback" #(vim.keymap.set "n" "<LocalLeader>pr" vim.lsp.buf.rename {"buffer" $.buf})})

(command "ModeChanged" me
  {"callback" (fn [{:match modes}]
                (let [mode (n.second (str.split modes ":"))]
                  (set vim.opt.list (and
                                      (= "n" mode)
                                      ;; In buffers that aren't modifiable (vimdoc/help, dependencies, etc.) it's annoying
                                      ;; for list to be enabled on e.g. navigation (especially when tabs are used, since
                                      ;; it renders as ^I, which is ugly).
                                      (vim.opt.modifiable:get)
                                      (not= "checkhealth" (vim.opt.filetype:get))))))})

{: command
 : group}
