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

; (define-configuration browser
;   ((theme (make-instance
;            'theme:theme
;            :dark-p t
;            :background-color "#282a36"
;            :text-color "#f8f8f2"
;            :accent-color "#ff5555"
;            :primary-color "#50fa7b"
;            :secondary-color "#bd93f9"
;            :tertiary-color "#6272a4"
;            :quaternary-color "#44475a"))))
;
; ;; Custom Dark-mode for webpages
; (define-configuration nyxt/style-mode:dark-mode
;   ((style #.(cl-css:css
;              '((*
;                 :background-color "#282a36 !important"
;                 :background-image "none !important"
;                 :color "#f8f8f2")
;                (a
;                 :background-color "#282a36 !important"
;                 :background-image "none !important"
;                 :color "#6272a4 !important"))))))

; (define-configuration browser
;   ((theme theme:+dark-theme+)))

; (define-configuration web-buffer
;   ((web-engine :blink)))
