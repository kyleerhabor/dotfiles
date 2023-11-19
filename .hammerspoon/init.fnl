;; (fn package-path [path]
;;   (set package.path (.. package.path ";" path)))
;;
;; (package-path (.. hs.configdir "/Spoons/?.spoon/init.lua"))

(local wf hs.window.filter)

(fn first [table]
  (. table 1))

(fn last [table]
  (. table (length table)))

(fn butlast [table]
  (let [len (length table)]
    (icollect [index value (ipairs table)]
      (if (not= index len)
        value))))

(fn copy [table]
  (collect [key value (pairs table)]
    key value))

(fn append [tbl value]
  (table.insert tbl value)
  tbl)

(fn append-kv [tbl key value]
  (tset tbl key value)
  tbl)

(fn inc [number]
  (+ number 1))

(fn map [f tbl]
  (collect [key val (pairs tbl)]
    (f key val)))

(fn mapkey [f tbl]
  (map #(values (f $1) $2) tbl))

(fn mapval [f tbl]
  (map #(values $1 (f $2)) tbl))

(fn filter [f tbl]
  (collect [key val (pairs tbl)]
    (if (f key val)
      (values key val))))

(fn sfilter [f tbl]
  (icollect [key val (pairs tbl)]
    (if (f key val)
      val)))

(fn shift [tbl len distance]
  (mapkey
    (fn [key]
      (let [shifted (% (+ key distance) (inc len))]
        (if (< shifted key)
          (inc shifted)
          shifted)))
    tbl))

(fn nil? [x]
  (= nil x))

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

(local hyper-key ["command" "shift" "option" "control"])

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

(local meta-shortcuts {(append (copy hyper-key) "F") #(: (currentApp) :selectMenuItem ["File" "Open With" "MusicBrainz Picard"])})

(fn hotkeys [shortcuts]
  (icollect [keys f (pairs shortcuts)]
    (hs.hotkey.new (butlast keys) (last keys) f)))

(local doppler-hotkeys (hotkeys doppler-shortcuts))
(local meta-hotkeys (hotkeys meta-shortcuts))

(: (wf.new "Doppler") :subscribe (app-hotkey-events doppler-hotkeys))

(: (wf.new "Meta") :subscribe (app-hotkey-events meta-hotkeys))

;; When a Preview window is opened, automatically zoom it to fit. I really don't know why this isn't a built-in setting.
(: (wf.new "Preview") :subscribe {wf.windowCreated (fn [window]
                                                     (let [app (window:application)]
                                                       (app:selectMenuItem ["View" "Continuous Scroll"])
                                                       (app:selectMenuItem ["View" "Zoom to Fit"])))
                                  wf.windowFullscreened (fn [window]
                                                          (let [app (window:application)]
                                                            (app:selectMenuItem ["View" "Continuous Scroll"])))})

(fn launched [name f]
  (let [watcher (hs.application.watcher.new
                  (fn [app-name event app]
                    (let [launched hs.application.watcher.launched]
                      (match [app-name event] [name launched]
                        (f app)))))]
    (watcher:start)
    watcher))

(launched "Doppler"
  (fn []
    ;; This sets Doppler as the current music app. It's useful so actions that work with audio (e.g. clicking the side
    ;; of an AirPod) don't open Apple Music by default.
    (hs.osascript.applescriptFromFile "scripts/doppler-launch.scpt")))

(launched "Safari"
  (fn [app]
    ;; TODO: Convert this to use the accessibility API (as this is very fragile).
    (let [codes hs.keycodes.map
          tab codes.tab
          space codes.space
          settings (hs.eventtap.event.newKeyEvent ["cmd"] "," true)
          forward (hs.eventtap.event.newKeyEvent [] tab true)
          back (hs.eventtap.event.newKeyEvent ["shift"] tab true)
          press (hs.eventtap.event.newKeyEvent [] space true)]
      (settings:post app)
      (for [_ 1 11]
        (forward:post app))
      (press:post app)
      (for [_ 1 13]
        (back:post app))
      (press:post app))))

(fn key [key modifiers action]
  (hs.hotkey.bind modifiers key
    action nil action))

(local control-step 5)

(fn device-volume []
  (match (hs.audiodevice.defaultOutputDevice) device
    (match (device:volume) volume
      {:device device
       :volume volume})))

(fn set-volume [device level]
  (device:setOutputVolume level)
  (device:setOutputMuted (<= level 0)))

;; Increase system volume
(key "D" hyper-key
  (fn []
    (match (device-volume) {: device : volume}
      (set-volume device (+ volume control-step)))))

;; Decrease system volume
(key "A" hyper-key
  (fn []
    (match (device-volume) {: device : volume}
      (set-volume device (- volume control-step)))))

;; Increase brightness
(key "W" hyper-key
  (fn []
    (hs.brightness.set (+ (hs.brightness.get) control-step))))

;; Decrease brightness
(key "X" hyper-key
  (fn []
    (hs.brightness.set (- (hs.brightness.get) control-step))))

(local apps {"Activity Monitor" "com.apple.ActivityMonitor"
             "Books" "com.apple.iBooksX"
             "Doppler" "co.brushedtype.doppler-macos"
             "Finder" "com.apple.finder"
             "Firefox" "org.mozilla.firefox"
             "IINA" "com.colliderli.iina"
             "Mail" "com.apple.mail"
             "MarkEdit" "app.cyan.markedit"
             "Meta" "com.nightbirdsevolve.Meta"
             "MusicBrainz Picard" "org.musicbrainz.Picard"
             "Neovide" "com.neovide.neovide"
             "Pages" "com.apple.iWork.Pages"
             "Pixelmator Pro" "com.pixelmatorteam.pixelmator.x"
             "Preview" "com.apple.Preview"
             "Reminders" "com.apple.reminders"
             "Safari" "com.apple.Safari"
             "Sequential" "com.kyleerhabor.Sequential"
             "SF Symbols" "com.apple.SFSymbols"
             "Shortcuts" "com.apple.shortcuts"
             "System Settings" "com.apple.systempreferences"
             "Terminal" "com.apple.Terminal"
             "The Unarchiver" "cx.c3.theunarchiver"
             "Transmission" "org.m0k.transmission"
             "Visual Studio Code" "com.microsoft.VSCode"
             "Xcode" "com.apple.dt.Xcode"})

(local switches {"1" ["Doppler"]
                 "a" ["Activity Monitor"]
                 "b" ["Books"]
                 "f" ["Finder" "Firefox"]
                 "i" ["IINA"]
                 "m" ["Meta" "MusicBrainz Picard" "Mail" "MarkEdit"]
                 "n" ["Neovide"]
                 "p" ["Pages" "Preview" "Pixelmator Pro"]
                 "r" ["Reminders"]
                 "s" ["Safari" "Sequential" "System Settings" "SF Symbols" "Shortcuts"]
                 "t" ["Terminal" "Transmission" "The Unarchiver"]
                 "v" ["Visual Studio Code"]
                 "x" ["Xcode"]})

(local app-switches
  (mapval
    (fn [names]
      {"position" 1
       "apps" (mapval #(. apps $) names)}) switches))

(var prior-switched-app nil)

(local app-switcher
  (hs.eventtap.new [hs.eventtap.event.types.keyDown]
    (fn [event]
      (let [flags (event:getFlags)]
        (if (and flags.fn flags.ctrl)
          ;; If we don't specify clean characters, chars comes out blank.
          (let [chars (event:getCharacters true)]
            (match (. app-switches chars) switch
              (let [current (currentApp)
                    path (current:path)
                    names switch.apps
                    len (length names)
                    pos switch.position
                    pos (if (= prior-switched-app (current:pid)) (inc pos) pos)
                    pos (if (> pos len) 1 pos)
                    onames (shift names len (inc (- len pos)))
                    apps (mapval #(first (hs.application.applicationsForBundleID $)) onames)
                    apps (sfilter #(and $2 (not= path ($2:path))) apps)]
                (match (first apps) app
                  (do
                    (print (.. "[Switcher] Activating " (app:title) "..."))
                    (when (hs.application.launchOrFocus (app:path))
                      (set prior-switched-app (app:pid))
                      (set switch.position pos))
                    true))))))))))

(app-switcher:start)

(var prior-quit-app-pid nil)
(var prior-quit-timestamp nil)

(local quit-watcher
  (hs.eventtap.new [hs.eventtap.event.types.keyDown]
    (fn [event]
      (let [flags (event:getFlags)]
        (if flags.cmd
          (let [chars (event:getCharacters)]
            (if (= "q" chars)
              (let [app (currentApp)
                    pid (app:pid)
                    ts (event:timestamp)]
                (if (and
                      (= prior-quit-app-pid pid)
                      (>= 1_000_000_000 (- ts prior-quit-timestamp)))
                  false
                  (do
                    (print (.. "User tried to quit " (app:title)))
                    (set prior-quit-app-pid pid)
                    (set prior-quit-timestamp ts)
                    true))))))))))

(quit-watcher:start)

(set hs.shutdownCallback
  (fn []
    (quit-watcher:stop)
    (app-switcher:stop)))
