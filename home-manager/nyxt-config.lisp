(define-configuration browser
  ((theme theme:+dark-theme+)))

(define-configuration nyxt/mode/style:dark-mode
  ((style (theme:themed-css (theme *browser*)
            `(* :background-color ,theme:background "!important"
                :color ,theme:text "!important")))))

(define-configuration buffer
  ((default-modes (pushnew 'nyxt/mode/style:dark-mode %slot-value%))
   (search-engines (list (make-instance 'search-engine
                                       :shortcut "g"
                                       :search-url "https://www.google.com/search?q=~a"
                                       :fallback-url "https://www.google.com")))))

(define-configuration web-buffer
  ( (web-engine :blink)))
