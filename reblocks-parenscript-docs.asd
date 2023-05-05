(defsystem "reblocks-parenscript-docs"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/reblocks-parenscript/"
  :class :package-inferred-system
  :description "Provides documentation for reblocks-parenscript."
  :source-control (:git "https://github.com/40ants/reblocks-parenscript")
  :bug-tracker "https://github.com/40ants/reblocks-parenscript/issues"
  :pathname "docs"
  :depends-on ("reblocks-parenscript"
               "reblocks-parenscript-docs/index"))
