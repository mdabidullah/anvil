"
The rules of this game are simple. Move a square around based on player input.
"
Class {
	#name : #PModel,
	#superclass : #AnvilModel,
	#category : #'Anvil-Prototype'
}

{ #category : #initialization }
PModel >> event: aEvent [
	aEvent == #Left ifTrue: [ self moveLeft ].
	aEvent == #Right ifTrue: [ self moveRight ].
	aEvent == #Up ifTrue: [ self moveUp ].
	aEvent == #Down ifTrue: [ self moveDown ].
]

{ #category : #initialization }
PModel >> initializeState [
	state at: #location put: (10@10).
]

{ #category : #initialization }
PModel >> moveDown [
	state at: #location put: (state at: #location) + (0@(10)).
]

{ #category : #initialization }
PModel >> moveLeft [
	state at: #location put: (state at: #location) + ((-10)@0).
]

{ #category : #initialization }
PModel >> moveRight [
	state at: #location put: (state at: #location) + ((10)@0).
]

{ #category : #initialization }
PModel >> moveUp [
	state at: #location put: (state at: #location) + (0@(-10)).
]
