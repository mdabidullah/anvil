Class {
	#name : #CyclingSeq,
	#superclass : #Seq,
	#instVars : [
		'currentSeq',
		'seqAtStartOfCycle'
	],
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
CyclingSeq >> calculateFirstAndRest [
	| restOfOriginalSeq |
	restOfOriginalSeq := currentSeq unsafeRest.
	cachedFirst := currentSeq unsafeFirst.
	cachedRest := CyclingSeq new initializeWithCurrentSeq: (restOfOriginalSeq isEmpty ifTrue: [seqAtStartOfCycle] ifFalse: [restOfOriginalSeq]) startingSeq: seqAtStartOfCycle.
	
	"so that they can be garbage-collected"
	currentSeq := nil.
	seqAtStartOfCycle := nil.
]

{ #category : #'as yet unclassified' }
CyclingSeq >> initializeWithCurrentSeq: c startingSeq: s [
	(c isEmpty or: [s isEmpty]) ifTrue: [ self error: 'The seq to cycle through must not be empty.' ].
	currentSeq := c.
	seqAtStartOfCycle := s.
	
]

{ #category : #'as yet unclassified' }
CyclingSeq >> printOn: aStream [
	aStream nextPutAll: 'a CyclingSeq (don''t try to print infinite sequences!)'.
]
