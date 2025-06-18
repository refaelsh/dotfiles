(in-package #:nyxt-user)

;; Import Files
(nyxt::load-lisp "./statusline.lisp")
(nyxt::load-lisp "./stylesheet.lisp")

; (define-configuration browser
;   ((theme theme:+dark-theme+)))

(define-configuration web-buffer
  ((web-engine :blink)))
