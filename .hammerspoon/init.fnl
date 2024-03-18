;;; Standard Lua operations

(fn nil? [x]
  (= nil x))

(fn inc [number]
  (+ number 1))

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

(fn map [f tbl]
  (collect [key val (pairs tbl)]
    (f key val)))

(fn mapkey [f tbl]
  (map #(values (f $1) $2) tbl))

(fn mapval [f tbl]
  (map #(values $1 (f $2)) tbl))

(fn tableset [tbl f]
  (map #(values (f $1 $2) true) tbl))

(fn filter [f tbl]
  (collect [key val (pairs tbl)]
    (if (f key val)
      (values key val))))

;; This probably shouldn't exist (especially for how it's being used).
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

;;; Hammerspoon conveniences

(fn currentApp []
  (hs.application.frontmostApplication))

(fn currentWindow []
  (hs.axuielement.windowElement (hs.window.focusedWindow)))

(fn app-by-bundle-id [id]
  (first (hs.application.applicationsForBundleID id)))

(local wf hs.window.filter)

;;; Hammerspoon operations

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

(global doppler-launched
  (launched "Doppler"
    (fn []
      ;; This sets Doppler as the current music app. It's useful so actions that work with audio (e.g. clicking the side
      ;; of an AirPod) don't open Apple Music by default.
      (hs.osascript.applescriptFromFile "scripts/doppler-launch.scpt"))))

(local keycodes hs.keycodes.map)

(global safari-launched
  (launched "Safari"
    (fn [app]
      ;; TODO: Convert this to use the accessibility API (as this is very fragile).
      (let [tab keycodes.tab
            space keycodes.space
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
        (press:post app)))))

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

;; ;; Increase brightness
;; (key "W" hyper-key
;;   (fn []
;;     (hs.brightness.set (+ (hs.brightness.get) control-step))))

;; ;; Decrease brightness
;; (key "X" hyper-key
;;   (fn []
;;     (hs.brightness.set (- (hs.brightness.get) control-step))))

(local apps {"Activity Monitor" "com.apple.ActivityMonitor"
             "Arc" "company.thebrowser.Browser"
             "Bike" "com.hogbaysoftware.Bike"
             "Books" "com.apple.iBooksX"
             "Console" "com.apple.Console"
             "Doppler" "co.brushedtype.doppler-macos"
             "Finder" "com.apple.finder"
             "Firefox" "org.mozilla.firefox"
             "Hyperkey" "com.knollsoft.Hyperkey"
             "IINA" "com.colliderli.iina"
             "Latest" "com.max-langer.Latest"
             "Mail" "com.apple.mail"
             "Maps" "com.apple.Maps"
             "MarkEdit" "app.cyan.markedit"
             "Meta" "com.nightbirdsevolve.Meta"
             "MusicBrainz Picard" "org.musicbrainz.Picard"
             "Neovide" "com.neovide.neovide"
             "Notes" "com.apple.Notes"
             "Orion" "com.kagi.kagimacOS"
             "Pages" "com.apple.iWork.Pages"
             "Photos" "com.apple.Photos"
             "Pixelmator Pro" "com.pixelmatorteam.pixelmator.x"
             "Preview" "com.apple.Preview"
             "Reminders" "com.apple.reminders"
             "Safari" "com.apple.Safari"
             "Safari Discord" "com.apple.Safari.WebApp.BB9407FF-3A12-4E98-88C4-AFC7E8210C8A"
             "Advance" "com.kyleerhabor.Advance"
             "SF Symbols" "com.apple.SFSymbols"
             "Shortcuts" "com.apple.shortcuts"
             "Sublime Text" "com.sublimetext.4"
             "System Settings" "com.apple.systempreferences"
             "The Unarchiver" "cx.c3.theunarchiver"
             "Tor Browser" "org.torproject.torbrowser"
             "Transmission" "org.m0k.transmission"
             "Visual Studio Code" "com.microsoft.VSCode"
             "Xcode" "com.apple.dt.Xcode"
             "Zed" "dev.zed.Zed"})

(local switches {"1" ["Doppler"]
                 "a" ["Advance" "Activity Monitor" "Arc"]
                 "b" ["Bike" "Books"]
                 "c" ["Console"]
                 "d" ["Safari Discord"]
                 "f" ["Finder" "Firefox"]
                 "i" ["IINA"]
                 "l" ["Latest"]
                 "m" ["Meta" "MusicBrainz Picard" "Mail" "MarkEdit" "Maps"]
                 "n" ["Neovide" "Notes"]
                 "o" ["Orion"]
                 "p" ["Pages" "Preview" "Pixelmator Pro" "Photos"]
                 "r" ["Reminders"]
                 "s" ["Safari" "System Settings" "SF Symbols" "Shortcuts" "Sublime Text"]
                 "t" ["Transmission" "The Unarchiver" "Tor Browser"]
                 "v" ["Visual Studio Code"]
                 "x" ["Xcode"]
                 "z" ["Zed"]})

(local app-switches
  (mapval
    (fn [names]
      {"position" 1
       "apps" (mapval #(. apps $) names)}) switches))

(var prior-switched-app nil)

(global app-switcher
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
                    apps (mapval #(app-by-bundle-id $) onames)
                    apps (sfilter #(and $2 (not= path ($2:path))) apps)]
                (match (first apps) app
                  (do
                    (print (.. "[Switcher] Activating " (app:title) "..."))
                    (when (hs.application.launchOrFocus (app:path))
                      (set prior-switched-app (app:pid))
                      (set switch.position pos))
                    true))))))))))

(app-switcher:start)

(local confirm-quit-apps (tableset ["Safari" "Doppler" "Finder"] #(. apps $2)))

(var prior-quit-app-pid nil)
(var prior-quit-timestamp nil)

(global quit-watcher
  (hs.eventtap.new [hs.eventtap.event.types.keyDown]
    (fn [event]
      (let [flags (event:getFlags)]
        (if flags.cmd
          (let [chars (event:getCharacters)]
            (if (= "q" chars)
              (let [app (currentApp)]
                (if (. confirm-quit-apps (app:bundleID))
                  (let [pid (app:pid)
                        ts (event:timestamp)]
                    (if (and
                          (. confirm-quit-apps (app:bundleID))
                          (= prior-quit-app-pid pid)
                          (>= 1_000_000_000 (- ts prior-quit-timestamp)))
                      false ; Quit the app
                      (do ; Log about our attempt to quit the app.
                        (print (.. "User tried to quit " (app:title)))
                        (set prior-quit-app-pid pid)
                        (set prior-quit-timestamp ts)
                        true))))))))))))

(quit-watcher:start)

(local command-tab-apps [])
(local command-tab-excluded (tableset command-tab-apps #(. apps $2)))

;; Disable Command-Tab except for select applications (currently none)
(global command-tab-watcher
  (hs.eventtap.new [hs.eventtap.event.types.keyDown]
    (fn [event]
      (let [flags (event:getFlags)]
        (if (and
              flags.cmd
              (= "\t" (event:getCharacters))
              (not (. command-tab-excluded (: (currentApp) :bundleID))))
          true)))))

(command-tab-watcher:start)

(fn app? [app name]
  (= (app:bundleID) (. apps name)))

;; Turns off the keyboard brightness when switching to IINA.
(global iina-watcher
  (hs.application.watcher.new
    (fn [name type app]
      (if (app? app "IINA")
        (let [keys {hs.application.watcher.activated "ILLUMINATION_DOWN"
                    hs.application.watcher.deactivated "ILLUMINATION_UP"}
              key (. keys type)]
          (if key
            (let [key-down true
                  event (hs.eventtap.event.newSystemKeyEvent key key-down)
                  down (= key "ILLUMINATION_DOWN")]
              (for [_ 1 (if down 20 1)]
                (event:post))
              (: (hs.eventtap.event.newSystemKeyEvent key (not key-down)) :post))))))))

(iina-watcher:start)

(global finder-watcher
  (hs.eventtap.new [hs.eventtap.event.types.keyDown]
    (fn [event]
      (if (app? (currentApp) "Finder")
        (let [flags (event:getFlags)
              chars (event:getCharacters)
              up-key "\u{F700}"
              down-key "\u{F701}"]
          (or
            ;; "Open" alternative
            (and flags.cmd (= down-key chars))
            ;; "Select Startup Disk"
            (and flags.cmd flags.shift (= up-key chars))))))))

(finder-watcher:start)
