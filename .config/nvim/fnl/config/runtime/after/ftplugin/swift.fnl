(module config.runtime.after.ftplugin.swift)

(def opt vim.opt)

(set opt.commentstring "// %s")
;; Vim sets Swift's indentation to 4, which makes no sense, given Swift has no standard on indentation.
(set opt.shiftwidth 2)
