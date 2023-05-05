(defsystem "reblocks-parenscript-tests"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/reblocks-parenscript/"
  :class :package-inferred-system
  :description "Provides tests for reblocks-parenscript."
  :source-control (:git "https://github.com/40ants/reblocks-parenscript")
  :bug-tracker "https://github.com/40ants/reblocks-parenscript/issues"
  :pathname "t"
  :depends-on ("reblocks-parenscript-tests/core")
  :perform (test-op (op c)
                    (unless (symbol-call :rove :run c)
                      (error "Tests failed"))))
