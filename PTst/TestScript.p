test MainTest [main=Test]:
  assert NoOverdrafts in
  (union Client, Bank, { Test });