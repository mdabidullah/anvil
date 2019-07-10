"
State values:

#Time#
______

#time: a countdown until the shape must be dropped

#Shape Related#
_______________

#shapeLocations : an OrderedCollection containing Points, each point represents the location of a cell which makes up the shape

#shapeMatrix : a Matrix, the matrix representation of the shape 

#matrixLocation : a Point, representing where the matrix is positioned. 

#shapeRotation : a Number, representing the current rotation of the shape. 

#Level Related#
_______________

#levelSize : a Number, 

#offset : a Number, which is the drawing point of the level.

#levelOrientation : a Number that keeps track of the orientation of the cell. 

#level : an Array2D, containing the level state, the placed cells. 

#Visual Related#
________________

#cellSize: a Number, representing the size of a cell in pixels
"
Class {
	#name : #SqModel,
	#superclass : #AnvilModel,
	#instVars : [
		'stateMachine'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #'as yet unclassified' }
SqModel class >> IShape [
	^ { 1@1. 2@1. 3@1. 4@1 }
]

{ #category : #'as yet unclassified' }
SqModel class >> OShape [
	^ { 1@1. 2@1. 1@2. 2@2 }
]

{ #category : #shape }
SqModel >> acceptShape [
	"Check if the shape collides with board cells, if so game over"
]

{ #category : #shape }
SqModel >> addShape [
	self flag: 'TODO'.
	"From the #shapeBag get a random piece, if the bag is empty then make a new 
	bag"
	(state at: #shapeBag) 
	
	"Set stateMachine to #ChooseQuadrant"
]

{ #category : #'change quadrant' }
SqModel >> changeQuadrant: aQuadrant [
]

{ #category : #ring }
SqModel >> checkForRing [
]

{ #category : #ring }
SqModel >> checkForRings [
]

{ #category : #move }
SqModel >> drop [
]

{ #category : #diagonal }
SqModel >> enterDiagonal: aDirection [
]

{ #category : #anvil }
SqModel >> event: aEvent [
	aEvent == #Left ifTrue: [ self move: #Left ].
	aEvent == #Right ifTrue: [ self move: #Right ].
	aEvent == #Up ifTrue: [ self move: #Up ].
	aEvent == #Down ifTrue: [ self move: #Down ].
]

{ #category : #diagonal }
SqModel >> exitDiagonal: aDirection [
]

{ #category : #anvil }
SqModel >> gameOver [
]

{ #category : #anvil }
SqModel >> initialize [	
	
]

{ #category : #anvil }
SqModel >> initializeState [
	"Time"
	state at: #time put: 1.0.
	
	"Shape"
	state at: #shape put: { 2@1. 3@1. 4@1. 5@1 }. 
	state at: #shapeBag put: (self makeShapeBag).
	"Level"
	state at: #levelSize put: 31. 
	state at: #offset put: 20@10.
	state at: #levelOrientation put: 0.
	state at: #level put: (Array2D rows: (state at: #levelSize)
										   columns: (state at: #levelSize)).
										
	"Visual"
	state at: #cellSize put: 15.
	
	self startGame.
]

{ #category : #initialization }
SqModel >> initializeStateMachine [
	"The State machine is responsible for handling input in different states"
	stateMachine := SsStateMachine new.
	
	stateMachine addStateNamed: #Start.
	stateMachine setStartStateTo: #Start.
	
	stateMachine addStateNamed: #ChooseQuadrant. 
	
	stateMachine addStateNamed: #InQuadrant.
	
	stateMachine addStateNamed: #InDiagonal. 
	
	stateMachine addStateNamed: #Landed.
]

{ #category : #move }
SqModel >> land [
]

{ #category : #shape }
SqModel >> makeShapeBag [
	self flag: 'TODO'.
]

{ #category : #ring }
SqModel >> manageCascade [
]

{ #category : #move }
SqModel >> move: aDirection [
]

{ #category : #diagonal }
SqModel >> moveDownDiagonal [
]

{ #category : #diagonal }
SqModel >> moveInDiagonal: aDirection [
]

{ #category : #move }
SqModel >> movePossible: aDirection [
]

{ #category : #move }
SqModel >> moveValid: aDirection [
]

{ #category : #ring }
SqModel >> removeRing [
]

{ #category : #anvil }
SqModel >> restartGame [
]

{ #category : #rotate }
SqModel >> rotate [
]

{ #category : #rotate }
SqModel >> rotationPossible [
]

{ #category : #initialization }
SqModel >> startGame [
	self initializeStateMachine.
	state at: #shape put: (self addShape).
]

{ #category : #anvil }
SqModel >> step [
	
]
