"
shapeLocations : an OrderedCollection containing Points 
"
Class {
	#name : #SqState,
	#superclass : #Object,
	#instVars : [
		'values',
		'announcer'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #anvil }
SqState >> announcer [ 
	^ announcer
]

{ #category : #anvil }
SqState >> at: aKey [ 
	^ values at: aKey.
]

{ #category : #anvil }
SqState >> at: aKey put: aValue [
	values add: (aKey -> aValue).
	self stateChanged.
]

{ #category : #anvil }
SqState >> initialize [ 
	values := Dictionary new.
	announcer := Announcer new.
]

{ #category : #anvil }
SqState >> stateChanged [
	announcer announce: PoCStateChangedAnnouncement new.
]
