;;; early-init.el -*- lexical-binding: t; -*-

;; File introduced in emacs 27.1, it is run before init.el, before package and
;; UI initialization.

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
