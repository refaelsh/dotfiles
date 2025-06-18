(in-package #:nyxt-user)

;; Import Files
(nyxt::load-lisp "~/.config/nyxt/statusline.lisp")
(nyxt::load-lisp "~/.config/nyxt/stylesheet.lisp")

(define-configuration browser
  ((theme theme:+dark-theme+)))

(define-configuration web-buffer
  ((web-engine :blink)))
