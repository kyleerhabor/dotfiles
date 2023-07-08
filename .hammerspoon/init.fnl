(local wf hs.window.filter)

(fn last [table]
  (. table (length table)))

(fn butlast [table]
  (let [len (length table)]
    (icollect [index value (ipairs table)]
      (if (not= index len)
        value))))

(fn currentApp []
  (hs.application.frontmostApplication))

(fn currentWindow []
  (hs.axuielement.windowElement (hs.window.focusedWindow)))

(fn app-hotkey-events [hotkeys]
  {wf.windowFocused (fn []
                      (each [_ hotkey (ipairs hotkeys)]
                        (hotkey:enable)))
   wf.windowUnfocused (fn []
                        (each [_ hotkey (ipairs hotkeys)]
                          (hotkey:disable)))})

;;; Doppler

;; While System Preferences > Keyboard > Keyboard Shortcuts... > App Shortcuts exists (and is better in certain ways,
;; like displaying the assigned shortcut), it sometimes doesn't work (at least, for the applications listed; it does for
;; e.g. Safari, which I have ⌘E to duplicate the current tab).

(local doppler-shortcuts {["command" "E"] #(: (currentApp) :selectMenuItem ["Song" "Edit Info With" "Meta"])
                          ["command" "shift" "L"] #(: (currentApp) :selectMenuItem ["Song" "Like"])
                          ;; ["command" "R"] (fn []
                          ;;                   (: (currentWindow) :elementSearch
                          ;;                     (fn []
                          ;;                       (print "Hi?"))
                          ;;                     (hs.axuielement.searchCriteriaFunction "AXCell"))
                          ;;                   (print (: (: (currentWindow) :asHSApplication) :title)))
                          })

(local doppler-hotkeys
  (icollect [keys f (pairs doppler-shortcuts)]
    (hs.hotkey.new (butlast keys) (last keys) f)))

(: (wf.new "Doppler") :subscribe (app-hotkey-events doppler-hotkeys))

;; When a Preview window is opened, automatically zoom it to fit. I really don't know why this isn't a built-in setting.
(: (wf.new "Preview") :subscribe {wf.windowCreated (fn [window]
                                                     (let [app (window:application)]
                                                       (app:selectMenuItem ["View" "Continuous Scroll"])
                                                       (app:selectMenuItem ["View" "Zoom to Fit"])))})
;; (: (wf.new ["Safari" "Safari Technology Preview"]) :subscribe {wf.windowFocused #$})
