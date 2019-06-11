Class {
	#name : #AnvilModel,
	#superclass : #Object,
	#instVars : [
		'state'
	],
	#category : #'Anvil-Prototype'
}

{ #category : #initialization }
AnvilModel >> event: aEvent [
	aEvent == #Left ifTrue: [ self moveLeft ].
	aEvent == #Right ifTrue: [ self moveRight ].
	aEvent == #Up ifTrue: [ self moveUp ].
	aEvent == #Down ifTrue: [ self moveDown ].
]

{ #category : #initialization }
AnvilModel >> initialize [         
]

{ #category : #initialization }
AnvilModel >> moveDown [
	state at: #location put: (state at: #location) + (0@(-10)).
]

{ #category : #initialization }
AnvilModel >> moveLeft [ 
	state at: #location put: (state at: #location) + (10@0).
]

{ #category : #initialization }
AnvilModel >> moveRight [ 
	state at: #location put: (state at: #location) + (-10@0).
]

{ #category : #initialization }
AnvilModel >> moveUp [
	state at: #location put: (state at: #location) + (0@(10)).
]

{ #category : #initialization }
AnvilModel >> state: aState [
	state := aState.
	state at: #location put: (10@10). 
	state at: #rotation put: 1.
]

{ #category : #'stepping and presenter' }
AnvilModel >> step [
	state at: #rotation put: ((state at: #rotation) + 10)
]
