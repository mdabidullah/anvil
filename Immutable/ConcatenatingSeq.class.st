Class {
	#name : #ConcatenatingSeq,
	#superclass : #Seq,
	#instVars : [
		'seqs'
	],
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
ConcatenatingSeq >> calculateFirstAndRest [
	| remainingSeqs firstNonEmptySeq |
	remainingSeqs := seqs.
	[| shouldExit |
		shouldExit := false.
		remainingSeqs isEmpty ifTrue: [
			firstNonEmptySeq := nil.
			remainingSeqs := nil.
			shouldExit := true.
		] ifFalse: [
			firstNonEmptySeq := remainingSeqs unsafeFirst seq.
			remainingSeqs := remainingSeqs unsafeRest.
			shouldExit := firstNonEmptySeq isEmpty not.
		].
		shouldExit
	] whileFalse: [].
	firstNonEmptySeq ifNotNil: [ :s |
		cachedFirst := s unsafeFirst.
		cachedRest := ConcatenatingSeq new initializeWithSeqs: (List createWithFirst: s unsafeRest rest: remainingSeqs)
	].
	seqs := nil. "so that it can be garbage-collected"
]

{ #category : #'as yet unclassified' }
ConcatenatingSeq >> initializeWithSeqs: ss [
	seqs := ss.
]
