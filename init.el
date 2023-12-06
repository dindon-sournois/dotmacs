;;; init.el -*- lexical-binding: t; -*-

;; UTF-8 nonsense
; not required?
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
; required
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; set tmp and cache directories
(defconst me/tmp-directory
  (concat temporary-file-directory "emacs-" user-login-name "/")
  "Directory where all tmp files should be saved.")
(setq temporary-file-directory me/tmp-directory)

(defconst me/cache-directory
  (concat user-emacs-directory "cache/")
  "Directory where all cache files should be saved.")

;; create tmp and cache directories
(when (not (file-directory-p me/tmp-directory))
  (make-directory me/tmp-directory t)
  (chmod me/tmp-directory (file-modes-symbolic-to-number "u+rwx,go-rwx")))

(when (not (file-directory-p me/cache-directory))
  (make-directory me/cache-directory t))

;; compile .eln files in cache folder
(setq native-comp-eln-load-path
      (append (list (concat me/cache-directory "eln"))
              (cdr native-comp-eln-load-path)))
(setq-default package-native-compile t
              native-comp-async-report-warnings-errors 'silent)

;; default init files location
(defconst me-config-file
  (concat user-emacs-directory "dotmacs.el")
  "The location of the generated elisp config file.")

(defconst me-config-file-org
  (concat user-emacs-directory "dotmacs.org")
  "The location of the `org-mode' config file.")

;; Already defined with `early-init.el'
(when (version< emacs-version "27.1")
  (defconst me/cache-directory
    (concat user-emacs-directory "cache/")
    "Directory where all cache files should be saved."))

(defun me/reload-user-org-file ()
  "Reload emacs configuration."
  (interactive)
  (org-babel-load-file me-config-file-org))

(let ((default-directory user-emacs-directory)
      (file-name-handler-alist nil)
      (gc-cons-percentage .6)
      (gc-cons-threshold most-positive-fixnum)
      (read-process-output-max (* 1024 1024)))

  ;; Disable that pesky echo message
  (setq inhibit-startup-echo-area-message user-login-name)

  ;; Mark safe variables early so that tangling won't break
  (put 'after-save-hook 'safe-local-variable
       (lambda (value) (equal value '(org-babel-tangle t))))
  (put 'display-line-numbers-width 'safe-local-variable 'integerp)

  ;; Tangle and compile if necessary only, then load the configuration
  (me/reload-user-org-file)

  ;; Set the working directory to home
  (cd "~/")

  ;; Collect garbage when all else is done
  (garbage-collect))
