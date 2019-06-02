Class {
	#name : #ChannelTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
ChannelTest >> testBasics [
	| c highestNumberWrittenSoFar |
	c := Channel ofSize: 3.
	highestNumberWrittenSoFar := 0.
	[ 1 to: 7 do: [ :i | c put: i. highestNumberWrittenSoFar := i ] ] go.
	(AsyncPromise delay: 200 milliSeconds) await.
	self assert: highestNumberWrittenSoFar equals: 3.
	self assert: c take equals: 1.
	(AsyncPromise delay: 50 milliSeconds) await.
	self assert: highestNumberWrittenSoFar equals: 4.
	self assert: c take equals: 2.
	self assert: c take equals: 3.
	(AsyncPromise delay: 50 milliSeconds) await.
	self assert: highestNumberWrittenSoFar equals: 6.
	self assert: c take equals: 4.
	self assert: c take equals: 5.
	self assert: c take equals: 6.
	self assert: c take equals: 7.
	self assert: highestNumberWrittenSoFar equals: 7.

]

{ #category : #'as yet unclassified' }
ChannelTest >> testDropping [
	| c highestNumberWrittenSoFar |
	c := Channel droppingOfSize: 3.
	highestNumberWrittenSoFar := 0.
	[ 1 to: 7 do: [ :i | c put: i. highestNumberWrittenSoFar := i ] ] go.
	(AsyncPromise delay: 200 milliSeconds) await.
	self assert: highestNumberWrittenSoFar equals: 7.
	self assert: c take equals: 1.
	self assert: c take equals: 2.
	self assert: c take equals: 3.

]

{ #category : #'as yet unclassified' }
ChannelTest >> testSliding [
	| c highestNumberWrittenSoFar |
	c := Channel slidingOfSize: 3.
	highestNumberWrittenSoFar := 0.
	[ 1 to: 7 do: [ :i | c put: i. highestNumberWrittenSoFar := i ] ] go.
	(AsyncPromise delay: 200 milliSeconds) await.
	self assert: highestNumberWrittenSoFar equals: 7.
	self assert: c take equals: 5.
	self assert: c take equals: 6.
	self assert: c take equals: 7.

]
