;;*****************************************************************
;;
;;                     KBM's emacs config - Init
;;
;;*****************************************************************

;; A very basic and sleek Emacs setup for general purpose
;; editing and programming.

;;; Look and Feel ====================================================

;; Tweak UI.
(when (display-graphic-p)
  (tool-bar-mode 0)
  (scroll-bar-mode 1))
(setq inhibit-startup-screen t)
(column-number-mode)

;;Themes ef-theme
(add-to-list 'load-path "~/.emacs.d/manual-packages/ef-themes")
(require 'ef-themes)
(setq ef-themes-headings ; read the manual's entry or the doc string
      '((0 variable-pitch light 1.9)
        (1 variable-pitch light 1.8)
        (2 variable-pitch regular 1.7)
        (3 variable-pitch regular 1.6)
        (4 variable-pitch regular 1.5)
        (5 variable-pitch 1.4) ; absence of weight means `bold'
        (6 variable-pitch 1.3)
        (7 variable-pitch 1.2)
        (t variable-pitch 1.1)))

;; If you like two specific themes and want to switch between them, you
;; can specify them in `ef-themes-to-toggle' and then invoke the command
;; `ef-themes-toggle'.  All the themes are included in the variable
;; `ef-themes-collection'.
(setq ef-themes-to-toggle '(ef-cyprus ef-duo-light ef-eagle))

;; They are nil by default...
(setq ef-themes-mixed-fonts t
       ef-themes-variable-pitch-ui t)

;; Disable all other themes to avoid awkward blending:
(mapc #'disable-theme custom-enabled-themes)

;; Load the theme of choice:
(load-theme 'ef-cyprus :no-confirm)

;; Enable line numbers while writing config, code, or text.
(dolist (hook '(prog-mode-hook conf-mode-hook text-mode-hook))
  (add-hook hook 'display-line-numbers-mode))

;; Highlight matching pairs of parentheses.
(setq show-paren-delay 0)
(show-paren-mode 1)

;; Auto-complete inputs in the minibuffer.
(fido-vertical-mode)

;; (set-face-attribute 'default nil :font "Intel One Mono" :height 144)
;; (set-face-attribute 'default nil :font "Fira Code" :height 136)
;; (set-face-attribute 'default nil :font "JetBrains Mono" :height 136)
;; (set-face-attribute 'default nil :font "IBM Plex Mono" :height 136)
;; (set-face-attribute 'default nil :font "Consolas" :height 136)
;; (set-face-attribute 'default nil :font "Roboto Mono" :height 136)
;; (set-face-attribute 'default nil :font "Berkeley Mono" :height 136)
(set-face-attribute 'default nil :font "Google Sans Code" :height 142)

;;; Whitespace =======================================================

;; Show trailing whitespace while writing config, code, or text.
(dolist (hook '(conf-mode-hook prog-mode-hook text-mode-hook))
  (add-hook hook (lambda () (setq show-trailing-whitespace t))))

;; Show stray blank lines.
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

;; Add a newline automatically at the end of a file while saving.
(setq require-final-newline t)

;; Consider a period followed by a single space to be end of sentence.
(setq sentence-end-double-space nil)

;; Use spaces, not tabs, for indentation.
(setq-default indent-tabs-mode nil)

;; Display the distance between two tab stops as 4 characters wide.
(setq-default tab-width 4)


;;; Clean Working Directories ========================================

;; Write auto-saves and backups to separate directory.
(make-directory "~/.tmp/emacs/auto-save/" t)
(setq auto-save-file-name-transforms '((".*" "~/.tmp/emacs/auto-save/" t)))
(setq backup-directory-alist '(("." . "~/.tmp/emacs/backup/")))

;; Do not move the current file while creating backup.
(setq backup-by-copying t)

;; Disable lockfiles.
(setq create-lockfiles nil)

;; Write customizations to a separate file instead of this file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

;;; WSL specific config adaptations ==================================

(defun wslp ()
  "Return t if Emacs is running in WSL2, nil otherwise."
  (and
   ;; Check if the system is Linux
   (eq system-type 'gnu/linux)
   ;; Check for WSL-specific file
   (file-exists-p "/proc/sys/fs/binfmt_misc/WSLInterop")
   ;; Check for WSL2-specific file
   (file-exists-p "/run/WSL")
   ;; Additional check: look for Windows-style root directory
   (file-directory-p "/mnt/c")))

(when (wslp)
  ; WSLg breaks copy-paste from Emacs into Windows ; see: https://www.lukas-barth.net/blog/emacs-wsl-copy-clipboard/
  (setq select-active-regions nil select-enable-clipboard 't select-enable-primary nil interprogram-cut-function #'gui-select-text))

;;; Custom Command and Key Sequences =================================

;; Custom command.
(defun show-current-time ()
  "Show current time."
  (interactive)
  (message (current-time-string)))

;; Custom key sequences.
(global-set-key (kbd "C-c t") 'show-current-time)
(global-set-key (kbd "C-c d") 'delete-trailing-whitespace)
(global-set-key (kbd "C-<left>") 'backward-word)
(global-set-key (kbd "C-<right>") 'forward-word)

;;; Emacs Server =====================================================
(require 'server)
(unless (server-running-p)
  (server-start))


;;; Package Setup ====================================================

(defun install-packages ()
  "Install and set up packages for the first time."
  (interactive)
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (package-refresh-contents)
  (dolist (package '(markdown-mode
                     rainbow-delimiters
                     multiple-cursors
                     evil
                     projectile
                     vertico
                     meow))
    (unless (package-installed-p package)
      (package-install package))))

;;; EVIL Mode Configuration =========================================
;; (require 'evil)
;; (evil-mode 1)

;;;; Xah-Fly Mode Configuration =====================================
;; (add-to-list 'load-path "~/.emacs.d/lisp/")
;; (require 'xah-fly-keys)
;; specify a layout
;; (xah-fly-keys-set-layout "qwerty")
;; (xah-fly-keys 1)

;;;; Meow Mode Configuration =====================================
(use-package meow
  :ensure t
  :demand t
  :init
  (defun meow-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore))
    (meow-leader-define-key
     '("j" . "H-j")
     '("k" . "H-k")
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("/" . meow-keypad-describe-key)
     '("?" . meow-cheatsheet))
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("-" . negative-argument)
     '(";" . meow-reverse)
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("d" . meow-delete)
     '("D" . meow-backward-delete)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("f" . meow-find)
     '("g" . meow-cancel-selection)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("m" . meow-join)
     '("n" . meow-search)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("q" . meow-quit)
     '("Q" . meow-goto-line)
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
     '("s" . meow-kill)
     '("t" . meow-till)
     '("u" . meow-undo)
     '("U" . meow-undo-in-selection)
     '("v" . meow-visit)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("x" . meow-line)
     '("X" . meow-goto-line)
     '("y" . meow-save)
     '("Y" . meow-sync-grab)
     '("z" . meow-pop-selection)
     '("'" . repeat)
     '("<escape>" . ignore)))
  :config
  (meow-setup)
  (meow-global-mode 1))

;; Enable Vertico.
;; (use-package vertico
;;   :custom
;;   ;; (vertico-scroll-margin 0) ;; Different scroll margin
;;   ;; (vertico-count 20) ;; Show more candidates
;;   ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
;;   ;; (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
;;   :init
;;   (vertico-mode))

;; ;; Persist history over Emacs restarts. Vertico sorts by history position.
;; (use-package savehist
;;   :init
;;   (savehist-mode))

;; ;; Emacs minibuffer configurations.
;; (use-package emacs
;;   :custom
;;   ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
;;   ;; to switch display modes.
;;   (context-menu-mode t)
;;   ;; Support opening new minibuffers from inside existing minibuffers.
;;   (enable-recursive-minibuffers t)
;;   ;; Hide commands in M-x which do not work in the current mode.  Vertico
;;   ;; commands are hidden in normal buffers. This setting is useful beyond
;;   ;; Vertico.
;;   (read-extended-command-predicate #'command-completion-default-include-p)
;;   ;; Do not allow the cursor in the minibuffer prompt
;;   (minibuffer-prompt-properties
;;    '(read-only t cursor-intangible t face minibuffer-prompt)))

;;; Proejectile Mode Configuration ==================================
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;;; Rainbow Delimiters Configuration =================================

(when (fboundp 'rainbow-delimiters-mode)
  (dolist (hook '(emacs-lisp-mode-hook
                  ielm-mode-hook
                  lisp-interaction-mode-hook
                  lisp-mode-hook
                  c-mode-hook))
    (add-hook hook 'rainbow-delimiters-mode)))


;;; Language Specific Configurations ================================
;;;=== C ===;;;
(setq c-default-style "linux"
      c-basic-offset 4)

;;; Multiple-Cursors Configurations =================================
(require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)



;;; The End ==========================================================

(provide 'init)

;;; To-Do map the C-<- and C-> to alt-b and alt-f keys

;;; init.el ends here




