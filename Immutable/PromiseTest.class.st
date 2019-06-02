Class {
	#name : #PromiseTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
PromiseTest >> testAll [
	| p |
	p := AsyncPromise all: {
		[ 3 + 4 ] go.
		[ 11 + 17 ] go.
	}.
	self assert: p await equals: { 7. 28 }.

]

{ #category : #'as yet unclassified' }
PromiseTest >> testAny [
	| allIndices rand |
	rand := Random seed: 42. "using a fixed seed makes the results repeatable"
	allIndices := (1 to: 20) collect: [:i | | promises expectedAnswers overallPromise result indexOfFirstCompletedPromise |
		promises := {
			[ (AsyncPromise delay: (rand next * 500) milliSeconds) await. 3 + 4 ] go.
			[ (AsyncPromise delay: (rand next * 500) milliSeconds) await. 11 + 17 ] go.
		}.
		expectedAnswers := { 7. 28 }.
		overallPromise := AsyncPromise any: promises.
		result := overallPromise await.
		indexOfFirstCompletedPromise := promises indexOf: (result at: 1).
		self assert: (result at: 2) = (expectedAnswers at: indexOfFirstCompletedPromise).
		indexOfFirstCompletedPromise
	].
	self assert: allIndices equals: #(1 2 2 2 2 1 2 1 1 1 1 2 2 2 2 2 1 2 1 2).

]

{ #category : #'as yet unclassified' }
PromiseTest >> testAwait [
	| p |
	p := [ 3 + 4 ] go.
	self assert: p await equals: 7.
	self assert: p isFulfilled.

]

{ #category : #'as yet unclassified' }
PromiseTest >> testIsFulfilled [
	| p |
	p := AsyncPromise new.
	self assert: p isFulfilled not.
	p fulfill: 17.
	self assert: p isFulfilled.
	self assert: p await equals: 17.
	
]
