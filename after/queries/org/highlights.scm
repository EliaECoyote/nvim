; extends

(listitem (bullet) @bullet (#any-of? @bullet "-" "+" "*")  (#set! conceal "•"))

(checkbox
  status: (expr "-") @status.in_progress (#set! conceal "○"))
(checkbox
  status: (expr "str") @status.checked (#any-of? @status.checked "x" "X") (#set! conceal "✔"))
