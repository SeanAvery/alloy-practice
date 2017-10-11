sig FSObject { parent: lone Dir }

sig Dir extends FSObject { contents: set FSObject  }

sig File extends FSObject { }

