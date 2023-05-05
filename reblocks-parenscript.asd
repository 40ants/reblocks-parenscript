#-asdf3.1 (error "reblocks-parenscript requires ASDF 3.1 because for lower versions pathname does not work for package-inferred systems.")
(defsystem "reblocks-parenscript"
  :description "An utility to define JavaScript dependencies for Weblocks widgets using Parenscript."
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/reblocks-parenscript/"
  :source-control (:git "https://github.com/40ants/reblocks-parenscript")
  :bug-tracker "https://github.com/40ants/reblocks-parenscript/issues"
  :class :40ants-asdf-system
  :defsystem-depends-on ("40ants-asdf-system")
  :pathname "src"
  :depends-on ("reblocks"
               "reblocks-parenscript/reblocks-parenscript")
  :in-order-to ((test-op (test-op "reblocks-parenscript-tests"))))
