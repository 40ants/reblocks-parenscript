(in-package :cl-user)
(defpackage reblocks-parenscript-test
  (:use :cl
        :reblocks-parenscript
        :prove
        :hamcrest.matchers))
(in-package :reblocks-parenscript-test)


(plan 1)

(subtest "Replace this test with real staff."
  (assert-that (foo 1 2 3)
               (contains 1 2 3)))

(finalize)
