(uiop:define-package #:reblocks-parenscript-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog)
  (:import-from #:reblocks-parenscript
                #:make-js-handler
                #:make-dependency*))
(in-package #:reblocks-parenscript-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "JS"
                              "HTTP"))
  (0.6.0 2023-05-06
         "* Add documentation.")
  (0.5.0 2023-03-03
         "* Fixed thread-safety issue happened in Parenscript.
            Parenscript is unsafe yet, the problem should be solved in the:
            https://gitlab.common-lisp.net/parenscript/parenscript/-/issues/11")
  (0.4.0 2021-01-03
         "* Added macro MAKE-JS-HANDLER, which allows easily create custom
            event handlers with Lisp and JS code parts.")
  (0.3.0 2018-02-03
         "* Fixed to work with weblocks>= 0.25.0.")
  (0.2.0 2017-09-21
         "* Added a function MAKE-DEPENDENCY*.")
  (0.1.0 2017-09-02
         "* Initial version."))
