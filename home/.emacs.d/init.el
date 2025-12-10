;;; init.el -*- lexical-binding: t; coding: utf-8; -*-

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")))
  (package-initialize)
  (use-package leaf :ensure t)

  (leaf leaf-keywords
    :ensure t
    :config (leaf-keywords-init)))

(leaf leaf-convert
  :doc "Convert many format to leaf format"
  :ensure t)

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `(custom-file . ,(locate-user-emacs-file "custom.el")))

(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :bind (("C-h" . 'puni-backward-delete-char) ; シェルに合わせるため、C-hは後退に割り当てる
         ([remap zap-to-char] . 'zap-up-to-char))
  :custom `((create-lockfiles . nil)
            (tab-width . 4)
            (frame-resize-pixelwise . t)
            (enable-recursive-minibuffers . t)
            ;; 履歴をたくさん保存する
            (history-length . 1000)
            ;; 同じ内容を履歴に記録しないようにする
            (history-delete-duplicates . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively . 100)
            (ring-bell-function . 'ignore)
            (text-quoting-style . 'straight)
            (use-dialog-box . nil)
            (use-file-dialog . nil)
            ;; メニューバーとツールバーとスクロールバーを消す
            (menu-bar-mode . nil)
            (tool-bar-mode . nil)
            (scroll-bar-mode . nil)
            ;; インデントにTABを使わないようにする
            (indent-tabs-mode . nil)
            ;; splash screenを無効にする
            (inhibit-splash-screen . t)
            ;; C-u C-SPC C-SPC ...でどんどん過去のマークを遡る
            (set-mark-command-repeat-pop . t)
            (display-time-24hr-format . t)
            ;; ログの記録行数を増やす
            (message-log-max . 10000)
            (dired-dwim-target . t))
  :global-minor-mode (;; 現在行に色をつける
                      global-hl-line-mode
                      ;; モードラインに時刻を表示する
                      display-time-mode
                      ;; 桁番号を表示する
                      column-number-mode
                      ;; 行番号を表示する
                      global-display-line-numbers-mode))

(leaf theme
  :config (load-theme 'tango-dark))

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :global-minor-mode global-auto-revert-mode)

(leaf delete-selection
  :doc "delete selection if you insert"
  :tag "builtin"
  :global-minor-mode t)

(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :custom ((eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))

(leaf savehist
  :doc "Save minibuffer history"
  :global-minor-mode t)

(leaf which-key
  :doc "Display available keybindings in popup"
  :ensure t
  :global-minor-mode t)

(leaf save-place
  :doc "ファイルを開いた位置を保存する"
  :tag "builtin"
  :global-minor-mode t)

;(leaf geiser-chez
;  :ensure t
;  :custom (geiser-chez-binary . "D:/tools/chez/bin/ta6nt/scheme.exe"))

;(leaf font-setting
;  :config
;  (create-fontset-from-ascii-font "HackGen-11:weight=normal" nil "HackGen")
;  (set-fontset-font "fontset-HackGen" 'unicode "HackGen-11:weight=normal" nil 'append)
;  (add-to-list 'default-frame-alist '(font . "fontset-HackGen")))

(leaf ace-jump-mode
  :defvar ace-jump-mode-move-keys
  :ensure t
  :bind ("C-:" . ace-jump-word-mode)
  :custom ((ace-jump-mode-gray-background . nil)
           (ace-jump-word-mode-use-query-char . nil))
  :config (setq ace-jump-mode-move-keys (append "asdfghjkl;:]qwertyuiop@zxcvbnm,." nil)))

(leaf other-window
  :tag "builtin"
  :bind ("M-o" . other-window))

(leaf ffap-bindings
  :tag "builtin"
  :config (ffap-bindings))

(leaf recentf-ext
  :ensure t
  :custom (;; 最近のファイル500個を保存する
           (recentf-max-saved-items . 500)
           ;; 最近使ったファイルに加えないファイルを正規表現で指定する
           (recentf-exclude . '(".recentf" "/TAGS$" "/var/tmp/")))
  :global-minor-mode recentf-mode)

(leaf goto-chg
  :ensure t
  :bind (([f8] . goto-last-change)
         ([M-f8] . goto-last-change-reverse)))

(leaf bm
  :defun (bm-buffer-save-all bm-repository-save)
  :ensure t
  :bind (("M-SPC" . bm-toggle)
         ("M-[" . bm-previous)
         ("M-]" . bm-next))
  :hook ((find-file-hook . bm-buffer-restore)
         (kill-buffer-hook . bm-buffer-save)
         (after-save-hook . bm-buffer-save)
         (after-revert-hook . bm-buffer-restore)
         (vc-before-checkin-hook . bm-buffer-save)
         (kill-emacs-hook . (lambda ()
                              (bm-buffer-save-all)
                              (bm-repository-save))))
  :custom ((bm-buffer-persistence . nil)
           (bm-restore-repository-on-load . t)))

(leaf visual-regexp
  :ensure t
  :bind ("M-%" . vr/query-replace)
  :init
  (leaf visual-regexp-steroids :ensure t)
  (leaf pcre2el :ensure t)
  :custom (vr/engine . 'pcre2el))

(leaf undo-tree
  :ensure t
  :custom `((undo-tree-mode-lighter . "")
            (undo-tree-history-directory-alist . '((".*" . ,(locate-user-emacs-file "undo-tree/")))))
  :global-minor-mode global-undo-tree-mode)

(leaf vertico
  :doc "VERTical Interactive COmpletion"
  :ensure t
  :global-minor-mode t)

(leaf marginalia
  :doc "Enrich existing commands with completion annotations"
  :ensure t
  :global-minor-mode t)

(leaf consult
  :doc "Consulting completing-read"
  :ensure t
  :hook (completion-list-mode-hook . consult-preview-at-point-mode)
  :defun consult-line
  :preface (defun c/consult-line (&optional at-point)
             "Consult-line uses things-at-point if set C-u prefix."
             (interactive "P")
             (if at-point
                 (consult-line (thing-at-point 'symbol))
               (consult-line)))
  :custom ((xref-show-xrefs-function . #'consult-xref)
           (xref-show-definitions-function . #'consult-xref)
           (consult-line-start-from-top . t))
  :bind (;; C-c bindings (mode-specific-map)
         ([remap repeat-complex-command] . consult-complex-command) ; C-x M-:
         ([remap list-buffers] . consult-buffer)     ; C-x C-b
         ([remap switch-to-buffer] . consult-buffer) ; C-x b
         ([remap switch-to-buffer-other-window] . consult-buffer-other-window) ; C-x 4 b
         ([remap switch-to-buffer-other-frame] . consult-buffer-other-frame) ; C-x 5 b
         ([remap switch-to-buffer-other-tab] . consult-buffer-other-tab) ; C-x t b
         ([remap bookmark-jump] . consult-bookmark) ; C-x r b
         ([remap project-switch-to-buffer] . consult-project-buffer) ; C-x p b

         ([remap yank-pop] . consult-yank-pop) ; M-y

         ;; M-g bindings (goto-map)
         ([remap goto-line] . consult-goto-line) ; M-g g
         ([remap imenu] . consult-imenu)         ; M-g i
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g I" . consult-imenu-multi)
         ("M-g r" . consult-ripgrep)
         ;; ("M-g f" . consult-flymake)

         ;; C-M-s bindings
         ("C-s" . c/consult-line)       ; isearch-forward
         ("C-M-s" . nil)                ; isearch-forward-regexp
         ("C-M-s s" . isearch-forward)
         ("C-M-s C-s" . isearch-forward-regexp)

         (minibuffer-local-map
          :package emacs
          ("C-r" . consult-history))))

(leaf affe
  :doc "Asynchronous Fuzzy Finder for Emacs"
  :ensure t
  :custom ((affe-highlight-function . 'orderless-highlight-matches)
           (affe-regexp-function . 'orderless-pattern-compiler))
  :bind (("C-M-s r" . affe-grep)
         ("C-M-s f" . affe-find)))

(leaf orderless
  :doc "Completion style for matching regexp in any order"
  :ensure t
  :custom ((completion-styles . '(orderless basic))
           (completion-category-defaults . nil)
           (completion-category-overrides . '((file (styles partial-completion))))))

(leaf embark
  :ensure t
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim)
         ([remap describe-bindings] . embark-bindings))
  :setq (prefix-help-command . #'embark-prefix-help-command)
  :config (add-to-list 'display-buffer-alist
                       '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                         nil
                         (window-parameters (mode-line-format . none)))))

(leaf embark-consult
  :doc "Consult integration for Embark"
  :ensure t
  :bind ((minibuffer-mode-map
          :package emacs
          ("M-." . embark-dwim)
          ("C-." . embark-act)))
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(leaf corfu
  :doc "COmpletion in Region FUnction"
  ;;  :ensure t
  :custom (corfu-auto . t)
  :global-minor-mode global-corfu-mode
  :custom ((tab-always-indent . 'complete)
           (text-mode-ispell-word-completion . nil)
           (read-extended-command-predicate . #'command-completion-default-include-p)))
  ;;  :bind ((corfu-map
  ;;          ("C-s" . corfu-insert-separator))))

(leaf corfu-terminal
  :custom (corfu-terminal-mode . t))

(leaf cape
  :doc "Completion At Point Extensions"
  :ensure t
  :config (add-to-list 'completion-at-point-functions #'cape-file))

;; (leaf eglot
;;   :doc "The Emacs Client for LSP servers"
;;   :defvar eglot-server-programs
;;   :hook ((c-mode-hook . eglot-ensure)
;;          (c++-mode-hook . eglot-ensure))
;;   :config (add-to-list 'eglot-server-programs '((c++mode c-mode) "clangd")))

(leaf csv-mode
  :ensure t
  :mode ("\\.csv\\'"
         ("\\.tsv\\'" . tsv-mode)))

(leaf rainbow-csv
  :vc (:url "https://github.com/emacs-vs/rainbow-csv")
  :hook ((csv-mode-hook . rainbow-csv-mode)
         (tsv-mode-hook . rainbow-csv-mode)))

(leaf slime
  :ensure t
  :custom (inferior-lisp-program . "sbcl"))

(leaf puni
  :doc "Parentheses Universalistic"
  :ensure t
  :global-minor-mode puni-global-mode
  :bind (puni-mode-map
         ;; default mapping
         ;; ("C-M-f" . puni-forward-sexp)
         ;; ("C-M-b" . puni-backward-sexp)
         ;; ("C-M-a" . puni-beginning-of-sexp)
         ;; ("C-M-e" . puni-end-of-sexp)
         ;; ("M-)" . puni-syntactic-forward-punct)
         ;; ("C-M-u" . backward-up-list)
         ;; ("C-M-d" . backward-down-list)
         ("C-)" . puni-slurp-forward)
         ("C-}" . puni-barf-forward)
         ("M-(" . puni-wrap-round)
         ("M-s" . puni-splice)
         ("M-r" . puni-raise)
         ;; ("M-z" . puni-squeeze)
         ("M-U" . puni-splice-killing-backward))
  :config
  (leaf electric-pair
    :doc "Automatic parenthesis pairing"
    :global-minor-mode t))

(provide 'init)
