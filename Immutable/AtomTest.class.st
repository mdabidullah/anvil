Class {
	#name : #AtomTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
AtomTest >> testSwap [
	| a1 a2 randomDelayDurations N |
	N := 5.
	randomDelayDurations := Vector containing: ((Random new seq take: N) collect: #seconds).
	
	"First try it with NonThreadSafeMutableReference to show that it doesn't work, then try it the proper Atom way."

	a1 := NonThreadSafeMutableReference containing: 0.
	(AsyncPromise all: ((1 to: N) collect: [ :i | [ a1 swap: [ :s | (randomDelayDurations at: i) wait. s + i ] ] go ])) await.
	self deny: a1 deref = (1 to: N) sum.

	a2 := Atom containing: 0.
	(AsyncPromise all: ((1 to: N) collect: [ :i | [ a2 swap: [ :s | (randomDelayDurations at: i) wait. s + i ] ] go ])) await.
	self assert: a2 deref = (1 to: N) sum.

]
