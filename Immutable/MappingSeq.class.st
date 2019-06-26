Class {
	#name : #MappingSeq,
	#superclass : #Seq,
	#instVars : [
		'originalSeq',
		'mappingBlock'
	],
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
MappingSeq >> calculateFirstAndRest [
	originalSeq ifEmpty: [
		cachedRest := nil.
	] ifNotEmpty: [ :originalFirst :originalRest |
		cachedFirst := mappingBlock value: originalFirst.
		cachedRest := originalRest collect: mappingBlock.
	].

	originalSeq := nil. "so that it can be garbage-collected"
]

{ #category : #'as yet unclassified' }
MappingSeq >> initializeWithOriginalSeq: s mappingBlock: b [
	originalSeq := s.
	mappingBlock := b.
]
