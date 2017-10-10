module votes

enum Bool { True, False }

abstract sig Node {}

sig SaneNode extends Node {}
sig SlashNode extends Node {}

sig View {
	v_prev: lone View
}

abstract sig Hash {
	h_prev: lone Hash,
	h_view: lone View
}

abstract sig JustifiedHash extends Hash {}
one sig Genesis extends JustifiedHash {}
sig JustifiedNonGenesis extends JustifiedHash {}
sig NonJustifiedHash extends Hash {}

fact {
  no x : Hash | x in x.(^h_prev)
}

fact {
	no x: View | x in x.(^v_prev)
}

sig Vote {
	epoch : View,
	checkpoint : Hash,
	source : View,
	sender : one Node
}

fact {
	all vote : Vote | vote.source in (vote.checkpoint.h_view.(^v_prev))
}

pred some_votes {
	some vote : Vote |
		vote.sender in SaneNode
}

run some_votes for 1
