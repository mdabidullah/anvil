"
I hold the current state. I also keep track of history.
"
Class {
	#name : #AnvilState,
	#superclass : #Object,
	#instVars : [
		'values',
		'announcer',
		'stateHistory'
	],
	#category : #'Anvil-Base'
}

{ #category : #anvil }
AnvilState >> announcer [ 
	^ announcer
]

{ #category : #anvil }
AnvilState >> at: aKey [ 
	^ values at: aKey.
]

{ #category : #anvil }
AnvilState >> at: aKey put: aValue [
	values add: (aKey -> aValue).
]

{ #category : #anvil }
AnvilState >> initialize [ 
	values := Dictionary new.
	announcer := Announcer new.
	stateHistory := OrderedCollection new.
]

{ #category : #anvil }
AnvilState >> stateChanged [
	announcer announce: AnvilStateChangedAnnouncement new.
]

{ #category : #anvil }
AnvilState >> updateAt: aKey put: aValue [
	values add: (aKey -> aValue).
	self stateChanged.
]
