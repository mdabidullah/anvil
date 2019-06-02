Class {
	#name : #FilteringSeq,
	#superclass : #Seq,
	#instVars : [
		'originalSeq',
		'filteringBlock'
	],
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
FilteringSeq >> calculateFirstAndRest [
	(originalSeq firstSeqSatisfying: filteringBlock) ifNotNil: [ :s |
		cachedFirst := s unsafeFirst.
		cachedRest := s unsafeRest select: filteringBlock.
	].
	originalSeq := nil. "so that it can be garbage-collected"
]

{ #category : #'as yet unclassified' }
FilteringSeq >> initializeWithOriginalSeq: s filteringBlock: b [
	originalSeq := s.
	filteringBlock := b.
]
