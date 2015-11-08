{.compile: "logic.c".}
proc loop(): void {.importc.}

when isMainModule:
  loop()
