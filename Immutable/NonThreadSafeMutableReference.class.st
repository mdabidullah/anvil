"
I don't really recommend using this, but it's good for communicating the idea of what a MutableReference is.

And I guess it's fine as long as you know you won't be using this in a multithreaded situation.
"
Class {
	#name : #NonThreadSafeMutableReference,
	#superclass : #MutableReference,
	#category : #'Immutable-Mutation'
}

{ #category : #'as yet unclassified' }
NonThreadSafeMutableReference >> swap: aBlock [
	"Sets my state to be the result of the block. Note that this is not thread-safe."
	state := aBlock value: state.
]
