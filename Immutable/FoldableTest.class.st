Class {
	#name : #FoldableTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
FoldableTest >> testBasicStuff [
	| v |
	v := Vector containing: (1 to: 100).
	self assert: ((v foldable collect: #squared) select: [:n | n < 50]) asArray equals: { 1. 4. 9. 16. 25. 36. 49 }.
]

{ #category : #'as yet unclassified' }
FoldableTest >> testParallel [
	| v |
	v := Vector containing: (1 to: 1000).
	self assert: (v foldable fold: Monoid addition) equals: 500500.
	self assert: (ParallelFolding arrayedCollection: v fold: Monoid addition maxChunkSize: 1) equals: 500500.
	self assert: (ParallelFolding arrayedCollection: v fold: Monoid addition maxChunkSize: 15) equals: 500500.

]
