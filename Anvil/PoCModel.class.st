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
	aEvent == #left ifTrue: [ self moveLeft ]
]

{ #category : #initialization }
PoCModel >> initialize [ 
	announcer := Announcer new
]

{ #category : #initialization }
PoCModel >> moveLeft [ 
	state location: (state location) + -50@0.
	state updated.
]

{ #category : #initialization }
PoCModel >> state: aState [
	state := aState
]

{ #category : #initialization }
PoCModel >> stateChanged [
	self announcer announce: PoCStateChangedAnnouncement new.
]
