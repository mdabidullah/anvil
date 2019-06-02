Class {
	#name : #TakingSeq,
	#superclass : #Seq,
	#instVars : [
		'originalSeq',
		'numberOfElementsToTake'
	],
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
TakingSeq >> calculateFirstAndRest [
	(numberOfElementsToTake = 0 or: [originalSeq isEmpty]) ifTrue: [
		cachedRest := nil.
	] ifFalse: [
		cachedFirst := originalSeq unsafeFirst.
		cachedRest := TakingSeq new initializeWithOriginalSeq: originalSeq unsafeRest number: numberOfElementsToTake - 1.
	].
	
	originalSeq := nil. "so that it can be garbage-collected"
]

{ #category : #'as yet unclassified' }
TakingSeq >> initializeWithOriginalSeq: s number: n [
	originalSeq := s.
	numberOfElementsToTake := n.
]
