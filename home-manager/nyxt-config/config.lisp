; (in-package #:nyxt-user)

; (nyxt::load-lisp "./statusline.lisp")
; (nyxt::load-lisp "./stylesheet.lisp")

(define-configuration status-buffer ((glyph-mode-presentation-p t)))
(define-configuration nyxt/mode/force-https:force-https-mode ((glyph "")))
(define-configuration nyxt/mode/blocker:blocker-mode ((glyph "")))
(define-configuration nyxt/mode/proxy:proxy-mode ((glyph "")))
(define-configuration nyxt/mode/reduce-tracking:reduce-tracking-mode  ((glyph "")))
(define-configuration nyxt/mode/certificate-exception:certificate-exception-mode ((glyph "")))
(define-configuration nyxt/mode/style:style-mode ((glyph "")))
(define-configuration nyxt/mode/help:help-mode ((glyph "")))
(define-configuration document-mode ((glyph "ω")))

(define-configuration browser
    ((theme
      (make-instance 'theme:theme
                     :background-color "#282a36"
                     :on-background-color "#f8f8f2"
                     :accent-color "#ff5555"
                     :on-accent-color "#282a36"
                     :primary-color "#50fa7b"
                     :on-primary-color "#282a36"
                     :secondary-color "#bd93f9"
                     :on-secondary-color "#282a36"))))

(define-configuration prompt-buffer
    ((style
      (str:concat
       %slot-value%
       (theme:themed-css
        (theme *browser*)
        '("#prompt"
          :background-color "#282a36" :color "#f8f8f2")
        '("#prompt-extra"
          :background-color "#282a36" :color "#f8f8f2")
        '("#selection"
          :background-color "#44475a" :color "#f8f8f2")
        '("#input"
          :background-color "#6272a4" :color "#f8f8f2" :border-color "#44475a")
        '("#input:focus" :border-color "#6272a4"))))))

; (define-configuration browser
;   ((theme theme:+dark-theme+)))

; (define-configuration web-buffer
;   ((web-engine :blink)))
