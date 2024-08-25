;;; -*- lexical-binding: t -*-

;; Modeline icons
(defcustom photon-modeline--modification-icon ""
  "String shown when the current buffer is unsaved."
  :type 'string
  :group 'photon-modeline)

(defcustom photon-modeline--git-icon "󰊢"
  "String shown when the current buffer is unsaved."
  :type 'string
  :group 'photon-modeline)


;; Transformation functions
(defun photon-modeline-buffer-transform-core ()
  "Core buffer name transformations. Customize `photon-modeline--buffer-transform-function' to define custom transformations."
  (if (funcall photon-modeline--buffer-transform-function)
      (funcall photon-modeline--buffer-transform-function)
    (cond ((derived-mode-p 'org-mode)
	   (if (org-get-title)
	       (org-get-title)
	     (buffer-name)))
	  ((derived-mode-p 'vterm-mode) (concat "  vterm [" (file-name-base vterm-shell) "]  " (abbreviate-file-name default-directory)))
	  (t (buffer-name)))))

(defun photon-modeline-minibuffer-transform-core (command)
  "Core minibuffer transformations. Customize `photon-modeline--minibuffer-transform-function' to define custom transformations."
  (if (funcall photon-modeline--minibuffer-transform-function command)
      (funcall photon-modeline--minibuffer-transform-function command)
    (cond ((equal command "find-file") "Open file...")
	  ((equal command "execute-extended-command") "M-x...")
	  (t command))))

(defcustom photon-modeline--buffer-transform-function (lambda ()
							)
  "Function to transform displayed buffer names. Should return a string or nil."
  :type 'function
  :group 'photon-modeline)

(defcustom photon-modeline--minibuffer-transform-function (lambda (command)
							    )
  "Function to transform displayed minibuffer command names. The input argument is a string with the name of the current command."
  :type 'function
  :group 'photon-modeline)

(provide 'photon-modeline-variables)
