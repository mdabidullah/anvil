Class {
	#name : #SsSwitch,
	#superclass : #SsTransition,
	#category : #'SState-Core'
}

{ #category : #'as yet unclassified' }
SsSwitch class >> switch: aBlock [
	^ self new action: aBlock.
	
]

{ #category : #actions }
SsSwitch >> perform [
	| evalResult |
	evalResult := super perform.
	self nextStateId: evalResult
]
