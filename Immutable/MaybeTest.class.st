Class {
	#name : #MaybeTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
MaybeTest >> testIfPresentIfAbsent [
	| h |
	h := Map from: { 1 -> 'one'. 2 -> 'two' }.
	self assert: ((h maybeAt: 2) ifPresent: [ :v | v ] ifAbsent: [ 'nothing here' ]) equals: 'two'.
	self assert: ((h maybeAt: 3) ifPresent: [ :v | v ] ifAbsent: [ 'nothing here' ]) equals: 'nothing here'.
]
