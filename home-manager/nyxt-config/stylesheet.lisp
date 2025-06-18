;; For version 3
(in-package #:nyxt-user)

;; This only works on the versions of Nyxt after 2.2.4.
(define-configuration browser
  ((theme (make-instance
           'theme:theme
           :dark-p t
           :background-color "#282a36"
           :text-color "#f8f8f2"
           :accent-color "#ff5555"
           :primary-color "#50fa7b"
           :secondary-color "#bd93f9"
           :tertiary-color "#6272a4"
           :quaternary-color "#44475a"))))

;; Custom Dark-mode for webpages
(define-configuration nyxt/style-mode:dark-mode
  ((style #.(cl-css:css
             '((*
                :background-color "#282a36 !important"
                :background-image "none !important"
                :color "#f8f8f2")
               (a
                :background-color "#282a36 !important"
                :background-image "none !important"
                :color "#6272a4 !important"))))))
