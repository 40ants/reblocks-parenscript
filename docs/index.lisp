(uiop:define-package #:reblocks-parenscript-docs/index
  (:use #:cl)
  (:import-from #:pythonic-string-reader
                #:pythonic-string-syntax)
  #+quicklisp
  (:import-from #:quicklisp)
  (:import-from #:named-readtables
                #:in-readtable)
  (:import-from #:40ants-doc
                #:defsection
                #:defsection-copy)
  (:import-from #:reblocks-parenscript-docs/changelog
                #:@changelog)
  (:import-from #:docs-config
                #:docs-config)
  (:import-from #:40ants-doc/autodoc
                #:defautodoc)
  (:export #:@index
           #:@readme
           #:@changelog))
(in-package #:reblocks-parenscript-docs/index)

(in-readtable pythonic-string-syntax)


(defmethod docs-config ((system (eql (asdf:find-system "reblocks-parenscript-docs"))))
  ;; 40ANTS-DOC-THEME-40ANTS system will bring
  ;; as dependency a full 40ANTS-DOC but we don't want
  ;; unnecessary dependencies here:
  #+quicklisp
  (ql:quickload "40ants-doc-theme-40ants")
  #-quicklisp
  (asdf:load-system "40ants-doc-theme-40ants")
  
  (list :theme
        (find-symbol "40ANTS-THEME"
                     (find-package "40ANTS-DOC-THEME-40ANTS")))
  )


(defsection @index (:title "reblocks-parenscript - An utility to define JavaScript dependencies for Weblocks widgets using Parenscript."
                    :ignore-words ("JSON"
                                   "HTTP"
                                   "HTML"
                                   "URL"
                                   "TODO"
                                   "Unlicense"
                                   "REPL"
                                   "GIT"
                                   "ASDF:PACKAGE-INFERRED-SYSTEM"
                                   "ASDF"
                                   "40A")
                    :external-docs ("https://40ants.com/reblocks/"))
  (reblocks-parenscript system)
  "
[![](https://github-actions.40ants.com/40ants/reblocks-parenscript/matrix.svg?only=ci.run-tests)](https://github.com/40ants/reblocks-parenscript/actions)

![Quicklisp](http://quickdocs.org/badge/reblocks-parenscript.svg)
"
  (@installation section)
  (@usage section)
  (@api section))


(defsection-copy @readme @index)


(defsection @installation (:title "Installation")
  """
You can install this library from Quicklisp, but you want to receive updates quickly, then install it from Ultralisp.org:

```
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :reblocks-parenscript)
```
""")


(defsection @usage (:title "Usage")
  "
This library should be used to define JavaScript dependencies for Reblocks widgets.
")


(defautodoc @api (:system "reblocks-parenscript"))
