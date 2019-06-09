Class {
	#name : #SsEndTransition,
	#superclass : #SsTransition,
	#category : #'SState-Core'
}

{ #category : #actions }
SsEndTransition >> changeState [
	self stateMachine changeStateTo: SsEndState new id.
]
