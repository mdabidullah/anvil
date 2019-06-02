"
If you want to create your own kind of Seq, but you don't want to go to the trouble of making a whole nother subclass like MappingSeq, you can just create an instance of SeqWithBlocks, and pass in a block (whose argument will be *another* block into which you're expected to pass the first and rest).
"
Class {
	#name : #SeqWithABlock,
	#superclass : #Seq,
	#instVars : [
		'firstBlock',
		'restBlock',
		'block'
	],
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
SeqWithABlock class >> block: aBlock [
	^ self new initializeWithBlock: aBlock
]

{ #category : #'as yet unclassified' }
SeqWithABlock >> calculateFirstAndRest [
	block value: [ :first :rest |
		cachedFirst := first.
		cachedRest := rest.
	].
	block := nil.  "so that it can be garbage-collected"

]

{ #category : #'as yet unclassified' }
SeqWithABlock >> initializeWithBlock: b [
	block := b.
]
