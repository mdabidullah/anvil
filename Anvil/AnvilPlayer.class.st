"
I am responsible for directing the game
"
Class {
	#name : #AnvilPlayer,
	#superclass : #Object,
	#instVars : [
		'states',
		'model',
		'view',
		'context',
		'process'
	],
	#category : #'Anvil-Base'
}

{ #category : #accessing }
AnvilPlayer >> start [
]

{ #category : #accessing }
AnvilPlayer >> states: listOfStates [
	states := listOfStates.
]

{ #category : #accessing }
AnvilPlayer >> updateView [
]

{ #category : #accessing }
AnvilPlayer >> view: aView [
	"This would be a BlSpace view"
	view := aView.
]
