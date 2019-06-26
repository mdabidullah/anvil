"
This is just a place to put a few functions that need to be used by both ArrayedCollection and Vector.
"
Class {
	#name : #ParallelFolding,
	#superclass : #Object,
	#instVars : [
		'originalArrayedCollection',
		'maxChunkSize',
		'startIndex',
		'stopIndex'
	],
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
ParallelFolding class >> arrayedCollection: c fold: aMonoid from: startIndex to: stopIndex maxChunkSize: maxChunkSize [
	^ (stopIndex + 1 - startIndex) <= maxChunkSize
		ifTrue: [ self arrayedCollection: c inject: aMonoid identityElement into: aMonoid combiningBlock from: startIndex to: stopIndex ]
		ifFalse: [ self arrayedCollection: c parallelFold: aMonoid from: startIndex to: stopIndex maxChunkSize: maxChunkSize ]
]

{ #category : #'as yet unclassified' }
ParallelFolding class >> arrayedCollection: c fold: aMonoid maxChunkSize: maxChunkSize [
	^ self arrayedCollection: c fold: aMonoid from: 1 to: c size maxChunkSize: maxChunkSize
]

{ #category : #'as yet unclassified' }
ParallelFolding class >> arrayedCollection: c inject: initialValue into: injectBlock from: startIndex to: stopIndex [
	| v i |
	v := initialValue.
	i := startIndex.
	[i <= stopIndex] whileTrue: [
		v := injectBlock value: v value: (c at: i).
		i := i + 1.
	].
	^ v
]

{ #category : #'as yet unclassified' }
ParallelFolding class >> arrayedCollection: c parallelFold: aMonoid from: startIndex to: stopIndex maxChunkSize: maxChunkSize [
	"OK, this isn't really parallel because Pharo doesn't support multicore. But you get the idea."
	| middleIndex leftPromise rightValue |
	middleIndex := ((startIndex + stopIndex) / 2) floor.
	leftPromise := [self arrayedCollection: c fold: aMonoid from: startIndex to: middleIndex maxChunkSize: maxChunkSize] go.
	rightValue   := self arrayedCollection: c fold: aMonoid from: middleIndex + 1 to: stopIndex maxChunkSize: maxChunkSize.
	^ aMonoid combiningBlock value: leftPromise await value: rightValue
]
