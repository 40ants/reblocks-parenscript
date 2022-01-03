(defsystem reblocks-parenscript-test
  :author ""
  :license ""
  :depends-on (:reblocks-parenscript
               :prove
               :hamcrest-prove)
  :components ((:module "t"
                :components
                ((:test-file "reblocks-parenscript"))))
  :description "Test system for reblocks-parenscript"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
