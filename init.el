(require 'use-package)

(use-package evil
  :defer .1 ;; don't block emacs when starting, load evil immediately after startup
  :init
  (setq evil-want-integration nil) ;; required by evil-collection
  (setq evil-want-keybinding nil) ;; required by evil-collection
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-shift-round nil)
  :config
  (evil-mode)

  ;; vim-like keybindings everywhere in emacs
  (use-package evil-collection
    :after evil
    :config
    (evil-collection-init))

  ;; like vim-surround
  (use-package evil-surround
    :commands
    (evil-surround-edit
     evil-Surround-edit
     evil-surround-region
     evil-Surround-region)
    :init
    (evil-define-key 'operator global-map "s" 'evil-surround-edit)
    (evil-define-key 'operator global-map "S" 'evil-Surround-edit)
    (evil-define-key 'visual global-map "S" 'evil-surround-region)
    (evil-define-key 'visual global-map "gS" 'evil-Surround-region))

  (message "Loading evil-mode...done"))
