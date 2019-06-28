"
I am responsible for the rules of the game, and I change the state as appropriate.
"
Class {
	#name : #AnvilModel,
	#superclass : #Object,
	#instVars : [
		'state'
	],
	#category : #'Anvil-Base'
}

{ #category : #anvil }
AnvilModel >> event: aEvent [
	"events are #Left, #Right, #Up, #Down, #Space, #Enter"
	self subclassResponsibility.
]

{ #category : #anvil }
AnvilModel >> initialize [         
]

{ #category : #anvil }
AnvilModel >> initializeState [
	self subclassResponsibility.
]

{ #category : #anvil }
AnvilModel >> state: aState [
	state := aState.
	self initializeState.
]
