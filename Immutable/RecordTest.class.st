Class {
	#name : #RecordTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
RecordTest >> testAutoConversion [
	| r r2 |
	r := SillyRecord from: { #a -> 1. #b -> 2. #c -> 3 }.
	r2 := r with: #d as: 4.
	self assert: r2 equals: (Map from: { #a -> 1. #b -> 2. #c -> 3. #d -> 4 }).
	
]

{ #category : #'as yet unclassified' }
RecordTest >> testBasicStuff [
	| r r2 r3 |
	r := SillyRecord from: { #a -> 1. #b -> 2. #c -> 3 }.
	self assert: r size equals: 3.
	self assert: (r at: #a) = 1.
	self assert: (r at: #b) = 2.
	self assert: (r at: #c) = 3.
	self assert: (r maybeAt: #d) = nothing.
	self assert: r equals: (Map from: { #a -> 1. #b -> 2. #c -> 3 }).

	r2 := SillyRecord fromValues: { 4. 5. 6 }.
	self assert: r2 size equals: 3.
	self assert: (r2 at: #a) = 4.
	self assert: (r2 at: #b) = 5.
	self assert: (r2 at: #c) = 6.
	self assert: (r2 maybeAt: #d) = nothing.

	r3 := r mapValues: [ :n | n * n ].
	self assert: r3 equals: (Map from: { #a -> 1. #b -> 4. #c -> 9 }).
	
]
