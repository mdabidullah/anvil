"
All those immutable data structures are great, but sometimes you really do need to *change* something.

(But when I say ""need"", I mean that you may need it because something actually happened or needs to happen in real time in the real world. A user pressed a button, or you need to display the next step of an animation on the screen, or something. Try *not* to use mutation when you're just doing ordinary data manipulation.)

Anyway, that's what MutableReferences are for. Each MutableReference holds *one* mutable pointer, intended to point to an immutable data structure.

Clojure has several different types, each with different concurrency semantics; so far I've only implemented Atom.

----

You may want to try to avoid shared mutable state altogether, though, and use mechanisms like Channels and Promises instead.
"
Class {
	#name : #MutableReference,
	#superclass : #Object,
	#instVars : [
		'state'
	],
	#category : #'Immutable-Mutation'
}

{ #category : #creating }
MutableReference class >> containing: initialState [
	^ self new reset: initialState; yourself
]

{ #category : #accessing }
MutableReference >> deref [
	^ state
]

{ #category : #printing }
MutableReference >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('; print: self deref; nextPutAll: ')'.
]

{ #category : #modifying }
MutableReference >> reset: newState [
	"Dangerous! You may want to use #swap: instead."
	state := newState
]
