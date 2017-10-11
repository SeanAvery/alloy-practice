sig FSObject { parent: lone Dir }

sig Dir extends FSObject { contents: set FSObject  }

sig File extends FSObject { }

// a directory is the parent of its contents
fact { all d: Dir, o: d.contents | o.parent = d }

// all file system objects are either files or directories
fact { File + Dir = FSObject }
