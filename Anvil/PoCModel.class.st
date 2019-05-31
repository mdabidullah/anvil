Class {
	#name : #PoCModel,
	#superclass : #Object,
	#instVars : [
		'state',
		'announcer'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #initialization }
PoCModel >> announcer [ 
	^ announcer
]

{ #category : #initialization }
PoCModel >> event: aEvent [
	aEvent == #Left ifTrue: [ self moveLeft ].
	aEvent == #Right ifTrue: [ self moveRight ].
	aEvent == #Up ifTrue: [ self moveUp ].
	aEvent == #Down ifTrue: [ self moveDown ].
]

{ #category : #initialization }
PoCModel >> initialize [ 
	announcer := Announcer new.           
]

{ #category : #initialization }
PoCModel >> moveDown [
	state at: #location put: (state at: #location) + (0@(-10)).
	self stateChanged.
]

{ #category : #initialization }
PoCModel >> moveLeft [ 
	state at: #location put: (state at: #location) + (10@0).
	self stateChanged.
]

{ #category : #initialization }
PoCModel >> moveRight [ 
	state at: #location put: (state at: #location) + (-10@0).
	self stateChanged.
]

{ #category : #initialization }
PoCModel >> moveUp [
	state at: #location put: (state at: #location) + (0@(10)).
	self stateChanged.
]

{ #category : #initialization }
PoCModel >> state: aState [
	state := aState.
	state at: #location put: (11@11). 
]

{ #category : #initialization }
PoCModel >> stateChanged [
	self announcer announce: PoCStateChangedAnnouncement new.
]
