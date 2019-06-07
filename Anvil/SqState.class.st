"
#Time#
______

#time: a countdown until the shape must be dropped

#Shape Related#
_______________

#shapeLocations : an OrderedCollection containing Points, each point represents the location of a cell which makes up the shape

#shapeMatrix : a Matrix, the matrix representation of the shape 

#shapeRotation : a Number, representing the current rotation of the shape. 

#

#Level Related#
_______________

#levelSize : a Number, 

#level : an OrderedCollection containing Dictionarys:
	#point: a Point, each point contains the location of a cell in the level that has an active cell. 
	#

#levelOrientation : a Number that keeps track of the orientation of the cell. 

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
	Transcript show: 'Changing state '; cr.
	values add: (aKey -> aValue).
	self stateChanged.
]

{ #category : #anvil }
SqState >> initialize [ 
	self halt.
	values := Dictionary new.
	announcer := Announcer new.
]

{ #category : #anvil }
SqState >> stateChanged [
	announcer announce: PoCStateChangedAnnouncement new.
]
