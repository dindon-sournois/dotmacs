;;; early-init.el -*- lexical-binding: t; -*-

;; File introduced in emacs 27.1, it is run before init.el, before package and
;; UI initialization.

(defconst me/cache-directory
  (concat user-emacs-directory "cache/")
  "Directory where all cache files should be saved.")

;; Compile .eln files in cache folder
(setq native-comp-eln-load-path
      (append (list (concat me/cache-directory "eln"))
              (cdr native-comp-eln-load-path)))
(setq-default package-native-compile t
              native-comp-async-report-warnings-errors 'silent)

;; from doomacs
(unless (or (daemonp) noninteractive)
  ;; Emacs really shouldn't be displaying anything until it has fully started
  ;; up. This saves a bit of time.
  (setq-default inhibit-redisplay t
                inhibit-message t)
  (add-hook 'window-setup-hook
            (lambda ()
              (setq-default inhibit-redisplay nil
                            inhibit-message nil)
              (redisplay))))

;; set-language-enviornment sets default-input-method, which is unwanted
(setq default-input-method nil)
