;;; -*- lexical-binding: t -*-

(defgroup photon-modeline-faces nil
  "Faces for Photon modeline"
  :group 'convenience)

(defun photon-modeline-recalculate-faces ()
  (interactive)
  (set-face-attribute 'photon-modeline--tab-bar-face nil
		      :box `(:line-width (1 . ,(/ (face-attribute 'default :height) 10)) :color ,(face-background 'default))
		      :underline `(:color ,(face-foreground 'default) :style line :position 'default)) 
  (if photon-modeline-mode
      (copy-face 'photon-modeline--tab-bar-face 'tab-bar))
  (set-face-attribute 'photon-modeline--buffer-face)
  )

;; Basic faces to build the mode-line
(defface photon-modeline--tab-bar-face
  `((t :inherit fixed-pitch
       :box (:line-width (1 . ,(/ (face-attribute 'default :height) 10)) :color ,(face-background 'default) :style flat-button)
       :underline (:color ,(face-foreground 'default) :style line :position 'default)))
  "Overall face for Photon modeline"
  :group 'photon-modeline-faces)

(defface photon-modeline--tab-bar-tab-face
  '((t ()))
  "Replaces tab-bar-tab"
  :group 'photon-modeline-faces)


;; Faces for the buffer title
(defface photon-modeline--buffer-face
  `((t :inherit fixed-pitch
       :weight bold
       :height ,(+ (face-attribute 'default :height) 10)))
  "Buffer title"
  :group 'photon-modeline-faces)

(defface photon-modeline--buffer-modified-face
  '((t :inherit photon-modeline--buffer-face
       :foreground "OrangeRed"))
  "Buffer title when buffer modified"
  :group 'photon-modeline-faces)

(defface photon-modeline--minibuffer-face
  `((t :inherit photon-modeline--buffer-face))
  "Minibuffer title"
  :group 'photon-modeline-faces)


;; Major mode face
(defface photon-modeline--major-mode-face
  '((t :inherit fixed-pitch))
  "Major mode"
  :group 'photon-modeline-faces)

;; Faces for the indicator
(defface photon-modeline--indicator-state-face
  `((t :inherit fixed-pitch
       :foreground "white"
       :height ,(- (face-attribute 'photon-modeline--buffer-face :height) 20)
       :width compressed
       :weight light))
  "Parent face for modeline indicators"
  :group 'photon-modeline-faces)

(defface photon-modeline--normal-state-face
  '((t :inherit photon-modeline--indicator-state-face
       :background "SeaGreen"))
  "Normal state indicator for Evil"
  :group 'photon-modeline-faces)

(defface photon-modeline--insert-state-face
  '((t :inherit photon-modeline--indicator-state-face
       :background "SkyBlue4"))
  "Insert state indicator for Evil"
  :group 'photon-modeline-faces)

(defface photon-modeline--visual-state-face
  '((t :inherit photon-modeline--indicator-state-face
       :background "red3"))
  "Visual state indicator for Evil"
  :group 'photon-modeline-faces)

(defface photon-modeline--misc-state-face
  '((t :inherit photon-modeline--indicator-state-face
       :background "Purple1"))
  "Miscellaneous state indicator for Evil"
  :group 'photon-modeline-faces)

(defface photon-modeline--command-face
  '((t :inherit photon-modeline--indicator-state-face
       :background "orange2"))
  "Miscellaneous state indicator for Evil"
  :group 'photon-modeline-faces)


;; Faces for Git
(defface photon-modeline--project-face
  '((t :inherit fixed-pitch))
  "Face to display the project name."
  :group 'photon-modeline-faces)

(defface photon-modeline--git-face
  '((t :inherit photon-modeline--project-face))
  "Face to display the Git indicator."
  :group 'photon-modeline-faces)

(defface photon-modeline--git-dirty-face
  '((t :inherit photon-modeline--git-face
       :weight bold))
  "Git indicator face when current working tree is dirty."
  :group 'photon-modeline-faces)



(provide 'photon-modeline-faces)
