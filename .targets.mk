TARGETS_DRAFTS := draft-kuehlewind-quic-substrate
TARGETS_TAGS := 
draft-kuehlewind-quic-substrate-00.txt: draft-kuehlewind-quic-substrate.txt
	sed -e 's/draft-kuehlewind-quic-substrate-latest/draft-kuehlewind-quic-substrate-00/g' -e 's/draft-kuehlewind-quic-substrate-latest/draft-kuehlewind-quic-substrate-00/g' $< >$@
