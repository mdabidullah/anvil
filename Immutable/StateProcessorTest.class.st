Class {
	#name : #StateProcessorTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
StateProcessorTest >> stackPop [
	^ StateProcessor withBlock: [ :aStack | { aStack unsafeFirst. aStack unsafeRest } ]
]

{ #category : #'as yet unclassified' }
StateProcessorTest >> stackPush: aValue [
	^ StateProcessor withBlock: [ :aStack | { nil. aStack cons: aValue } ]
]

{ #category : #'as yet unclassified' }
StateProcessorTest >> testBasicStuff [
	| p |
	p := (self stackPush: 3) >> (self stackPush: 4) >> self stackPop.
	self assert: ((p runState: List empty) seq destructure: [ :result :stack | result = 4 and: [ stack = { 3 } seq ] ]).
]
