; (define-configuration browser
;   ((theme theme:+dark-theme+)))
;
; (define-configuration buffer
;   ((default-modes (append '(nyxt/mode/style:dark-mode) %slot-default%))
;    (search-engines (list (make-instance 'search-engine
;                                        :shortcut "g"
;                                        :search-url "https://www.google.com/search?q=~a"
;                                        :fallback-url "https://www.google.com")))))

(define-configuration web-buffer
  ((default-new-buffer-url "about:blank")
   (web-engine :blink)))
