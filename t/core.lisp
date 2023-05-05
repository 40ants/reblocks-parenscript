(uiop:define-package #:reblocks-parenscript-tests/core
  (:use #:cl)
  (:import-from #:rove
                #:deftest
                #:ok
                #:testing))
(in-package #:reblocks-parenscript-tests/core)


(deftest test-example ()
  (ok t "Replace this test with something useful."))
