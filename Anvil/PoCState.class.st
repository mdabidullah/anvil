Class {
	#name : #PoCState,
	#superclass : #Object,
	#instVars : [
		'values',
		'announcer'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #initialization }
PoCState >> announcer [ 
	^ announcer
]

{ #category : #initialization }
PoCState >> at: aKey [ 
	^ values at: aKey.
]

{ #category : #initialization }
PoCState >> at: aKey put: aValue [
	values add: (aKey -> aValue).
	self stateChanged.
]

{ #category : #initialization }
PoCState >> initialize [ 
	values := Dictionary new.
	announcer := Announcer new
]

{ #category : #initialization }
PoCState >> stateChanged [
	announcer announce: PoCStateChangedAnnouncement new.
]
