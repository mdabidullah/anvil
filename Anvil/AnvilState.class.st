Class {
	#name : #AnvilState,
	#superclass : #Object,
	#instVars : [
		'values',
		'announcer',
		'stateHistory'
	],
	#category : #'Anvil-Prototype'
}

{ #category : #initialization }
AnvilState >> announcer [ 
	^ announcer
]

{ #category : #initialization }
AnvilState >> at: aKey [ 
	^ values at: aKey.
]

{ #category : #initialization }
AnvilState >> at: aKey put: aValue [
	values add: (aKey -> aValue).
	self stateChanged.
]

{ #category : #initialization }
AnvilState >> initialize [ 
	values := Dictionary new.
	announcer := Announcer new.
	stateHistory := OrderedCollection new.
]

{ #category : #initialization }
AnvilState >> saveState [
	"save the current state to state history"
	stateHistory add: self.
]

{ #category : #initialization }
AnvilState >> stateChanged [
	Transcript show: 'State changed'; cr.
	announcer announce: AnvilStateChangedAnnouncement new.
]
