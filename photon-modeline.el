;;; -*- lexical-binding: t -*-

(require 'tab-bar)
(require 'photon-modeline-faces)
(require 'photon-modeline-variables)


(defgroup photon-modeline nil
  "Photon modeline customization options"
  :group 'convenience)

(defvar photon-modeline--backup-status nil)
(defvar photon-modeline--backup-format nil)
(defvar photon-modeline--backup-func nil)
(defvar photon-modeline--backup-functions nil)


(defvar photon-modeline-format 
  '(
    (:eval (photon-modeline-evil-indicator))
    (:eval (photon-modeline-modification-indicator))
    (:eval (photon-modeline-buffer))
    "  "
    (:eval (photon-modeline-project))
    ))


(defun photon-modeline-evil-indicator ()
  (if (minibufferp)
      (propertize " COMMAND " 'face 'photon-modeline--command-face)
    (cond ((eq evil-state 'normal) (propertize " NORMAL " 'face 'photon-modeline--normal-state-face))
	  ((eq evil-state 'insert) (propertize " INSERT " 'face 'photon-modeline--insert-state-face))
	  ((eq evil-state 'visual) (propertize " VISUAL " 'face 'photon-modeline--visual-state-face))
	  (t (propertize " OTHER " 'face 'photon-modeline--misc-state-face)))))

(defun photon-modeline-modification-indicator ()
  (if (and buffer-file-name (buffer-modified-p))
      (concat "   " (propertize photon-modeline--modification-icon 'face 'photon-modeline--buffer-modified-face) "  ")
    "  "))

(defun photon-modeline-buffer ()
  (if (string-match-p "Minibuf" (buffer-name))
      (propertize (photon-modeline-minibuffer-transform-core (prin1-to-string current-minibuffer-command)) 'face 'photon-modeline--minibuffer-face)
    (if (and buffer-file-name (buffer-modified-p))
	(propertize (photon-modeline-buffer-transform-core) 'face 'photon-modeline--buffer-modified-face)
      (propertize (photon-modeline-buffer-transform-core) 'face 'photon-modeline--buffer-face))))

(defun photon-modeline-project ()
  (let ((path (if buffer-file-name
		  buffer-file-name
		(if dired-directory
		    dired-directory))))
    (if path
	(if (vc-git-root path)
	    (if (or (string= "" (vc-git--run-command-string path "status" "--porcelain"))
		    (null (vc-git--run-command-string path "status" "--porcelain")))
		(propertize (concat "(" photon-modeline--git-icon " " (file-name-nondirectory (directory-file-name (vc-git-root path))) ")") 'face 'photon-modeline--git-face)
	      (propertize (concat "[" photon-modeline--git-icon " " (file-name-nondirectory (directory-file-name (vc-git-root path))) "]") 'face 'photon-modeline--git-dirty-face))
	  (if (project-name (project-current))
	      (propertize (concat "(" (project-name (project-current)) ")") 'face 'photon-modeline--project-face))))))

(defun photon-modeline-dired-cleanup ()
  (let ((inhibit-read-only t))
    (save-excursion
      (goto-char (point-min))
      (delete-region (point) (line-end-position))
      (delete-char 1))))


(defun photon-modeline-on ()
  "Activate Photon modeline"
  (if tab-bar-mode
      (setq photon-modeline--backup-status t))
  (setq photon-modeline--backup-format tab-bar-format)
  (setq photon-modeline--backup-func tab-bar-tab-name-format-function)
  (setq photon-modeline--backup-functions tab-bar-tab-name-format-functions)
  (tab-bar-mode t)

  (copy-face 'tab-bar 'photon-modeline--backup-face)
  (copy-face 'tab-bar-tab 'photon-modeline--backup-tab-face)

  (copy-face 'photon-modeline--tab-bar-face 'tab-bar)
  (copy-face 'photon-modeline--tab-bar-tab-face 'tab-bar-tab)

  (setq tab-bar-tab-name-format-function
        (lambda (_ _)
	  (format-mode-line photon-modeline-format)))
  (setq tab-bar-tab-name-format-functions nil)
  (setq tab-bar-format '(tab-bar-format-tabs tab-bar-format-align-right (lambda () (propertize (concat (format-mode-line mode-name) "  ") 'face 'photon-modeline--major-mode-face))))

  (add-hook 'dired-after-readin-hook 'photon-modeline-dired-cleanup)

  ;; TODO: Disable modeline HERE
  )

(defun photon-modeline-off ()
  (setq tab-bar-format photon-modeline--backup-format)
  (setq tab-bar-tab-name-format-function photon-modeline--backup-func)
  (setq tab-bar-tab-name-format-functions photon-modeline--backup-functions)
  (unless photon-modeline--backup-status
    (tab-bar-mode -1))

  (copy-face 'photon-modeline--backup-face 'tab-bar)
  (copy-face 'photon-modeline--backup-tab-face 'tab-bar-tab)

  (remove-hook 'dired-after-readin-hook 'photon-modeline-dired-cleanup)
  
  ;; TODO: Turn modeline back on
  )

;;;###autoload
(define-minor-mode photon-modeline-mode
  "Minor mode for Photon modeline"
  :global t
  :group 'photon-modeline

  (if photon-modeline-mode
      (photon-modeline-on)
    (photon-modeline-off)))

(provide 'photon-modeline)
