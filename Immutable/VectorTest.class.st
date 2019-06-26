Class {
	#name : #VectorTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
VectorTest >> testBigEnoughToNeedNodes [
	| squares |
	squares := Vector containing: ((1 to: 40) seq collect: [:n | n * n]).
	self assert: squares size equals: 40.
	self assert: (squares at: 1) equals: 1.
	self assert: (squares at: 19) equals: 19 * 19.
	self assert: (squares at: 32) equals: 32 * 32.
	self assert: (squares at: 33) equals: 33 * 33.
	self assert: (squares at: 39) equals: 39 * 39.
	self assert: (squares at: 40) equals: 40 * 40.
	self assert: squares seq asArray equals: ((1 to: 40) seq collect: [:n | n * n]) asArray.

]

{ #category : #'as yet unclassified' }
VectorTest >> testCollect [
	self assert: ((Vector empty, (1 to: 3)) collect: #squared) seq asArray equals: ((1 to: 3) collect: #squared) asArray.
	self assert: ((Vector empty, (1 to: 50)) collect: #squared) seq asArray equals: ((1 to: 50) collect: #squared) asArray.
	self assert: ((Vector empty, (1 to: 3000)) collect: #squared) seq asArray equals: ((1 to: 3000) collect: #squared) asArray.

]

{ #category : #'as yet unclassified' }
VectorTest >> testConcat [
	self assert: (Vector empty, (1 to: 3) seq) seq asArray equals: (1 to: 3) asArray.
	self assert: (Vector empty, (1 to: 3000) seq) seq asArray equals: (1 to: 3000) asArray.

]

{ #category : #'as yet unclassified' }
VectorTest >> testInserting [
	| v v12 v35 |
	v := Vector containing: (1 to: 40) seq.
	v12 := v with: 12 as: 'twelve'.
	v35 := v with: 35 as: 'thirty-five'.

	self assert: v12 seq asArray equals: ((1 to: 40) collect: [ :n | n = 12 ifFalse: [n] ifTrue: ['twelve'] ]) asArray.
	self assert: v35 seq asArray equals: ((1 to: 40) collect: [ :n | n = 35 ifFalse: [n] ifTrue: ['thirty-five'] ]) asArray.

]

{ #category : #'as yet unclassified' }
VectorTest >> testReducible [
	self assert: ((Vector containing: (1 to: 1000)) foldable inject: 0 into: [ :a :b | a + b ]) equals: 500500.
	self assert: ((Vector containing: (1 to: 1000)) foldable inject: List empty into: [ :list :elem | list cons: elem ]) asArray equals: (1 to: 1000) asArray reversed. "makes sure it goes in the right order"
]

{ #category : #'as yet unclassified' }
VectorTest >> testSimpleOne [
	| v v1 |
	v := Vector containing: {}.
	self assert: v seq isEmpty.
	v1 := v withLast: 'argle'.
	self assert: v1 seq asArray equals: { 'argle' }.

]

{ #category : #'as yet unclassified' }
VectorTest >> testWithoutLast [
	| hundred ninetyNine hundredMinusNinetyEight hundredMinusNinetyNine hundredMinusHundred twoK twoKMinusOneK |
	hundred := Vector containing: (1 to: 100) seq.
	ninetyNine := hundred withoutLast.
	self assert: ninetyNine seq asArray equals: (1 to: 99) asArray.
	
	hundredMinusNinetyEight := (1 to: 98) inject: hundred into: [ :v :i | v withoutLast ].
	self assert: hundredMinusNinetyEight seq asArray equals: { 1. 2 }.

	hundredMinusNinetyNine := hundredMinusNinetyEight withoutLast.
	self assert: hundredMinusNinetyNine seq asArray equals: { 1 }.

	hundredMinusHundred := hundredMinusNinetyNine withoutLast.
	self assert: hundredMinusHundred seq asArray equals: { }.

	twoK := Vector containing: (1 to: 2000).
	self assert: (twoK at: 2000) equals: 2000.
	twoKMinusOneK := (1 to: 1000) inject: twoK into: [ :v :i | v withoutLast ].
	self assert: twoKMinusOneK seq asArray equals: (1 to: 1000) asArray.
	self assert: (twoKMinusOneK at: 1000) equals: 1000.

]
