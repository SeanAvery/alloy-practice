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

pred two_votes {
	some vote0, vote1 : Vote |
		vote0.sender = vote1.sender && vote0.sender in SaneNode
}

pred justifaction_link [h_src, h : Hash] {
	h_src in h.(^h_prev) &&
   (#{n : Node | some vote : Vote | vote.sender = n && vote.checkpoint = h && vote.source = h_src.h_view}).mul[3] >= (#Node).mul[2]
}

pred finalized(h : JustifiedNonGenesis)
{
	some child : JustifiedNonGenesis | child.h_prev = h && justification_link[h, child]
}

run two_votes for 2
