Class {
	#name : #PoCState,
	#superclass : #Object,
	#instVars : [
		'values',
		'announcer',
		'stateHistory'
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
	self halt.
	values add: (aKey -> aValue).
	self stateChanged.
]

{ #category : #initialization }
PoCState >> initialize [ 
	values := Dictionary new.
	announcer := Announcer new.
	stateHistory := OrderedCollection new.
]

{ #category : #initialization }
PoCState >> saveState [
	"save the current state to state history"
	stateHistory add: self.
]

{ #category : #initialization }
PoCState >> stateChanged [
	Transcript show: 'State changed'; cr.
	announcer announce: PoCStateChangedAnnouncement new.
]
