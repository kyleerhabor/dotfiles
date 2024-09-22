;;; Standard Lua operations

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

(fn tableset [tbl]
  (map #(values $2 true) tbl))

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

(fn current-app []
  (hs.application.frontmostApplication))

(fn current-window []
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

(local doppler-shortcuts {["command" "E"] #(: (current-app) :selectMenuItem ["Song" "Edit Info With" "Meta"])
                          ["command" "shift" "L"] #(: (current-app) :selectMenuItem ["Song" "Like"])
                          ;; ["command" "R"] (fn []
                          ;;                   (: (current-window) :elementSearch
                          ;;                     (fn []
                          ;;                       (print "Hi?"))
                          ;;                     (hs.axuielement.searchCriteriaFunction "AXCell"))
                          ;;                   (print (: (: (current-window) :asHSApplication) :title)))
                          })

(local meta-shortcuts {(append (copy hyper-key) "F") #(: (current-app) :selectMenuItem ["File" "Open With" "MusicBrainz Picard"])})

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
      (hs.osascript.applescriptFromFile "scripts/doppler-launch.scpt"))))

(local keycodes hs.keycodes.map)

;(global safari-launched
;  (launched "Safari"
;    (fn [app]
;      ;; TODO: Convert this to use the accessibility API (as this is very fragile).
;      (let [tab keycodes.tab
;            space keycodes.space
;            settings (hs.eventtap.event.newKeyEvent ["cmd"] "," true)
;            forward (hs.eventtap.event.newKeyEvent [] tab true)
;            back (hs.eventtap.event.newKeyEvent ["shift"] tab true)
;            press (hs.eventtap.event.newKeyEvent [] space true)]
;        (settings:post app)
;        (for [_ 1 11]
;          (forward:post app))
;        (press:post app)
;        (for [_ 1 13]
;          (back:post app))
;        (press:post app)))))

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

(local apps {"Activity Monitor" "com.apple.ActivityMonitor"
             "Arc" "company.thebrowser.Browser"
             "Bike" "com.hogbaysoftware.Bike"
             "Books" "com.apple.iBooksX"
             "Console" "com.apple.Console"
             "Doppler" "co.brushedtype.doppler-macos"
             "Element" "im.riot.app"
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
             "Orion RC" "com.kagi.kagimacOS.RC"
             "Pages" "com.apple.iWork.Pages"
             "Photos" "com.apple.Photos"
             "Pixelmator Pro" "com.pixelmatorteam.pixelmator.x"
             "Preview" "com.apple.Preview"
             "Reminders" "com.apple.reminders"
             "Safari" "com.apple.Safari"
             "Safari Discord" "com.apple.Safari.WebApp.2E50AFEE-7B57-46DA-98D1-BE3565BF2694"
             "Advance" "com.kyleerhabor.Advance"
             "SF Symbols" "com.apple.SFSymbols"
             "Shortcuts" "com.apple.shortcuts"
             "Sublime Text" "com.sublimetext.4"
             "System Settings" "com.apple.systempreferences"
             "TextEdit" "com.apple.TextEdit"
             "The Unarchiver" "cx.c3.theunarchiver"
             "Tor Browser" "org.torproject.torbrowser"
             "Transmission" "org.m0k.transmission"
             "Visual Studio Code" "com.microsoft.VSCode"
             "VSCodium" "com.vscodium"
             "Xcode" "com.apple.dt.Xcode"
             "Zed" "dev.zed.Zed"})

(local switches {"1" ["Doppler"]
                 "a" ["Advance" "Activity Monitor" "Arc"]
                 "b" ["Bike" "Books"]
                 "c" ["Console"]
                 "d" ["Safari Discord"]
                 "e" ["Element"]
                 "f" ["Finder" "Firefox"]
                 "i" ["IINA"]
                 "l" ["Latest"]
                 "m" ["Meta" "MusicBrainz Picard" "Mail" "MarkEdit" "Maps"]
                 "n" ["Neovide" "Notes"]
                 "o" ["Orion" "Orion RC"]
                 "p" ["Pages" "Preview" "Pixelmator Pro" "Photos"]
                 "r" ["Reminders"]
                 "s" ["Safari" "System Settings" "SF Symbols" "Shortcuts" "Sublime Text"]
                 "t" ["TextEdit" "Transmission" "The Unarchiver" "Tor Browser"]
                 "v" ["Visual Studio Code" "VSCodium"]
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
              (let [current (current-app)
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

(local confirm-quit-apps (tableset (mapval (partial . apps) ["Safari" "Doppler" "Finder"])))

(var prior-quit-app-pid nil)
(var prior-quit-timestamp nil)

(global quit-watcher
  (hs.eventtap.new [hs.eventtap.event.types.keyDown]
    (fn [event]
      (let [flags (event:getFlags)]
        (if flags.cmd
          (let [chars (event:getCharacters)]
            (if (= "q" chars)
              (let [app (current-app)]
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

;; Disable Command-Tab except for select applications (currently none)
(global command-tab-watcher
  (hs.eventtap.new [hs.eventtap.event.types.keyDown]
    (fn [event]
      (let [flags (event:getFlags)]
        (if (and
              flags.cmd
              (= "\t" (event:getCharacters)))
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

(local key-up "\u{F700}")
(local key-down "\u{F701}")

(local programs [{"name" "Finder"
                  "id" "com.apple.finder"
                  "title" "Finder"}
                 {"name" "mpv"
                  "title" "mpv"}
                 {"name" "Orion"
                  "id" "com.kagi.kagimacOS"
                  "title" "Orion"}
                 {"name" "Transmission"
                  "id" "org.m0k.transmission"
                  "title" "Transmission"}])

(local name->program (map #(values $2.name $2) programs))
(local id->name (map #(values $1 $2.name) name->program))
(local title->name (map #(values $1 $2.title) name->program))

(fn app->name [app ids titles]
  (let [ids (or ids id->name)
        titles (or titles title->name)]
    (or
      (-?>> (app:bundleID) (. ids))
      (-?>> (app:title) (. titles)))))

(local keyprograms [;; "Select Startup Disk"
                    {"name" "Finder"
                     "key" key-up
                     "flags" (tableset ["cmd" "shift"])}
                    ;; "Open" alternative
                    {"name" "Finder"
                     "key" key-down
                     "flags" (tableset ["cmd"])}
                    ;; "Pause Selected"
                    ;; {"name" "Transmission"
                    ;;  "key" "."
                    ;;  "flags" (tableset ["cmd"])}
                    ;; "Pause All"
                    {"name" "Transmission"
                     "key" "."
                     "flags" (tableset ["alt" "cmd"])}])

(local name->keys
  (accumulate [tbl {}
               _ keyprog (ipairs keyprograms)]
    (let [id (. (. name->program keyprog.name) "name")]
      (append-kv tbl id (append (or (. tbl id) []) keyprog)))))


(global keydown-watcher
  (hs.eventtap.new [hs.eventtap.event.types.keyDown]
    (fn [event]
      (match (-?>> (app->name (current-app)) (. name->keys)) keys
        (let [flags (event:getFlags)
              chars (event:getCharacters)]
          (accumulate [val false
                       _ keyprog (ipairs keys)
                       &until val]
            (and
              ;; A workaround for (flags:containExactly ...) not working (at least, for me).
              (= flags.cmd keyprog.flags.cmd)
              (= flags.shift keyprog.flags.shift)
              (= flags.alt keyprog.flags.alt)
              (= flags.ctrl keyprog.flags.ctrl)
              (= chars keyprog.key))))))))

(keydown-watcher:start)
