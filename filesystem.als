sig FSObject { parent: lone Dir }

sig Dir extends FSObject { contents: set FSObject  }

sig File extends FSObject { }

// a directory is the parent of its contents
fact { all d: Dir, o: d.contents | o.parent = d }

// all file system objects are either files or directories
fact { File + Dir = FSObject }

one sig Root extends Dir { } { no parent }

// file system is connected
fact { FSObject in Root.*contents }

// the contents path is acyclic
assert acyclic { no d: Dir | d in d.^contents }

// file system as one root
assert oneRoot { one d: Dir | no d.parent }

check oneRoot for 5
