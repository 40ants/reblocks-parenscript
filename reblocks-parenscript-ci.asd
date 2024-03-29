(defsystem "reblocks-parenscript-ci"
  :author "Alexander Artemenko <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/reblocks-parenscript/"
  :class :package-inferred-system
  :description "Provides CI settings for reblocks-parenscript."
  :source-control (:git "https://github.com/40ants/reblocks-parenscript")
  :bug-tracker "https://github.com/40ants/reblocks-parenscript/issues"
  :pathname "src"
  :depends-on ("40ants-ci"
               "reblocks-parenscript-ci/ci"))
