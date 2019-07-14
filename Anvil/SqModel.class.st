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

{ #category : #shapes }
SqModel class >> IShape [
	^ { (-1.5)@(-0.5). (-0.5)@(-0.5). (0.5)@(-0.5). (1.5)@(-0.5) }
]

{ #category : #shapes }
SqModel class >> JShape [
	^ { (-1)@1.     
		 (-1)@0.  0@0. 1@0 }
]

{ #category : #shapes }
SqModel class >> LShape [
	^ { 				    1@1.     
		 (-1)@0.  0@0.  1@0. }
]

{ #category : #shapes }
SqModel class >> OShape [
	^ { (-0.5)@0.5.     0.5@0.5.
		 (-0.5)@(-0.5).  0.5@(-0.5). }
]

{ #category : #shapes }
SqModel class >> SShape [
	^ { 			 0@1. 1@1.     
		 (-1)@0.  0@0       }
]

{ #category : #shapes }
SqModel class >> TShape [
	^ { 			 0@1. 
		 (-1)@0.  0@0. 1@0 }
]

{ #category : #shapes }
SqModel class >> ZShape [
	^ { (-1)@1. 0@1. 
		         0@0. 1@0 }
]

{ #category : #utility }
SqModel class >> pixelToPoint: aPoint [
]

{ #category : #utility }
SqModel class >> pointToPixel: aPoint [
]

{ #category : #utility }
SqModel class >> quadrant: aQuadrant ToGlobal: aPoint [ 
	"Convert a quadrant coordinate to global coordinates"
]

{ #category : #shape }
SqModel >> addNewShape [
	| shape |
	
	shape := self getShapeFromBag.
	state at: #shape put: (self getShape: shape).
	state at: #shapeType put: shape.
	state at: #shapeLocation put: (self getShapeStartingLocation: shape)
]

{ #category : #shape }
SqModel >> canAcceptShape [
	"Check if the shape collides with board cells, if so game over. Return either true or false"
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

	stateMachine handleEvent: aEvent.
]

{ #category : #diagonal }
SqModel >> exitDiagonal: aDirection [
]

{ #category : #anvil }
SqModel >> gameOver [
]

{ #category : #shape }
SqModel >> getShape: aSymbol [
	aSymbol = #I ifTrue: [ ^ self class IShape ].
	aSymbol = #J ifTrue: [ ^ self class JShape ].
	aSymbol = #L ifTrue: [ ^ self class LShape ].
	aSymbol = #O ifTrue: [ ^ self class OShape ].
	aSymbol = #S ifTrue: [ ^ self class SShape ].
	aSymbol = #T ifTrue: [ ^ self class TShape ].
	aSymbol = #Z ifTrue: [ ^ self class ZShape ].
]

{ #category : #shape }
SqModel >> getShapeFromBag [
	"From the #shapeBag get a random piece, if the bag is empty then make a new 
	bag"
	
	| shape rand|
	(state at: #shapeBag) size = 1 ifTrue: [ self makeShapeBag ].
	rand := (state at: #shapeBag) size atRandom.
	shape := (state at: #shapeBag) at: rand.
	state at: #shapeBag put: ((state at: #shapeBag) removeAt: rand).
	^ shape.
]

{ #category : #shape }
SqModel >> getShapeStartingLocation: aShapeSymbol [
]

{ #category : #anvil }
SqModel >> initialize [	
	
]

{ #category : #anvil }
SqModel >> initializeState [
	"Time"
	state at: #time put: 1.0.
	
	"Shape"
	state at: #shape put: nil. 
	state at: #shapeType put: nil.
	state at: #shapeBag put: nil.
	state at: #shapeLocation put: nil.
	"Level"
	state at: #levelSize put: 31. 
	state at: #offset put: 20@10.
	state at: #levelOrientation put: #Up.
	state at: #level put: (Array2D rows: (state at: #levelSize)
										   columns: (state at: #levelSize)).
										
	"Visual"
	state at: #cellSize put: 15.
	
	self startGame.
]

{ #category : #'state machine' }
SqModel >> initializeStateMachine [
	"The State machine is responsible for handling input in different states"
	stateMachine := SsStateMachine new.
	
	stateMachine addStateNamed: #ChooseQuadrant. 
	stateMachine addStateNamed: #AcceptShape. 
	stateMachine addStateNamed: #InQuadrant.
	stateMachine addStateNamed: #InDiagonal. 
	stateMachine addStateNamed: #Landed.
	stateMachine addStateNamed: #GameOver.

	stateMachine 
		setDecisionFrom: #AcceptShape 
		if: [ self canAcceptShape ] 
		trueTo: #InQuadrant
		falseTo: #GameOver.

	(stateMachine stateAt: #ChooseQuadrant) 
		when: #Space to: #AcceptShape;
		when: #Up do: [ self changeQuadrant: #Up ] to: #ChooseQuadrant;
		when: #Down do: [ self changeQuadrant: #Down ] to: #ChooseQuadrant;
		when: #Left do: [ self changeQuadrant: #Left ] to: #ChooseQuadrant;
		when: #Right do: [ self changeQuadrant: #Right ] to: #ChooseQuadrant.

	stateMachine setStartStateTo: #ChooseQuadrant.
]

{ #category : #move }
SqModel >> land [
]

{ #category : #shape }
SqModel >> makeShapeBag [
	self flag: 'TODO'.
	"A shape bag is just a Dictionary. When we take a shape from it we mark that shape unusable. The shape bag consists of 28 elements"
	"^ Dictionary new
		at: 1 put: #IShape;
		at: 2 put: #"
	state at: #shapeBag put: (OrderedCollection newFrom: #(#I #J #L #O #S #T #Z #I #J #L #O #S #T #Z #I #J #L #O #S #T #Z #I #J #L #O #S #T #Z))
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
	
	self addNewShape.
	
	stateMachine changeStateTo: #ChooseQuadrant.
]

{ #category : #anvil }
SqModel >> step [
	
]

{ #category : #'change quadrant' }
SqModel >> translateOrientation: aDirection [
	"This message translates the direction in relation to the current orientation"
	((Dictionary new
		at: #Up put: (Dictionary new 
								at: #Up put: #Up;
								at: #Down put: #Down;
								at: #Right put: #Right;
								at: #Left put: #Left;
								yourself);
		at: #Down put: (Dictionary new 
								at: #Up put: #Down;
								at: #Down put: #Up;
								at: #Right put: #Left;
								at: #Left put: #Right;
								yourself);
		at: #Right put: (Dictionary new 
								at: #Up put: #Right;
								at: #Down put: #Left;
								at: #Right put: #Down;
								at: #Left put: #Up;
								yourself);
		at: #Left put: (Dictionary new 
								at: #Up put: #Left;
								at: #Down put: #Right;
								at: #Right put: #up;
								at: #Left put: #Down;
								yourself);
								
		yourself) at: (state at: #levelOrientation)) at: aDirection.
]
