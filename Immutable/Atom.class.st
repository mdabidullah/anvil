"
An Atom is a simple kind of MutableReference. It doesn't do any kind of coordination with any other MutableReferences; it just holds a single value and makes sure that modifications to it are done atomically.

"
Class {
	#name : #Atom,
	#superclass : #MutableReference,
	#instVars : [
		'mutex'
	],
	#category : #'Immutable-Mutation'
}

{ #category : #modifying }
Atom >> initialize [
	mutex := Mutex new.
]

{ #category : #modifying }
Atom >> swap: aBlock [
	"Atomically sets my state to be the result of the block.
	 The block should take the old state as its argument, and return the desired new state.
	 The block should *not* have any side effects, as it may be executed multiple times."
	| needsToRetry |
	needsToRetry := true.
	[| oldState newState |
		oldState := state.
		newState := aBlock value: oldState.
		mutex critical: [
			state == oldState ifTrue: [
				state := newState.
				needsToRetry := false.
			].
		].
		needsToRetry
	] whileTrue.


]
