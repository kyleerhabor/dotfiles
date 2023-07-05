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

;; While System Preferences > Keyboard > Keyboard Shortcuts... > App Shortcuts exists (and is better in certain ways,
;; like displaying the assigned shortcut), it sometimes doesn't work (at least, for the applications listed; it does for
;; e.g. Safari, which I have ⌘E to duplicate the current tab).

(local doppler-shortcuts {["command" "E"] #(: (currentApp) :selectMenuItem ["Song" "Edit Info With" "Meta"])})

(local doppler-hotkeys
  (icollect [keys f (pairs doppler-shortcuts)]
    (hs.hotkey.bind (butlast keys) (last keys) f)))

(fn app-hotkey-events [hotkeys]
  {wf.windowFocused (fn []
                      (each [_ hotkey (ipairs hotkeys)]
                        (hotkey:enable)))
   wf.windowUnfocused (fn []
                        (each [_ hotkey (ipairs hotkeys)]
                          (hotkey:disable)))})

(: (wf.new "Doppler") :subscribe (app-hotkey-events doppler-hotkeys))
