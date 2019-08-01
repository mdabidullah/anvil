"
State values:

#Time#
______

#time: a countdown until the shape must be dropped

#Shape Related#
_______________

#shape : an OrderedCollection containing Points, each point represents the location of a cell which makes up the shape in relation to the #shapeLocation

#shapeType : a Symbol, representing the kind of shape.

#shapeBag : an OrderedCollection containing Symbols representing #shapeTypes, used for random shape picking

#shapeLocation : a Point, representing the origin of the shape. 

#Level Related#
_______________

#levelSize : a Number, 

#offset : a Number, which is the drawing point of the level.

#levelOrientation : a Symbol, that keeps track of the orientation of the cell.

#levelRotation : a Number that keeps track of the rotation of the cell. 

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

{ #category : #'add shape' }
SqModel >> addNewShape [
	| shapeSymbol |
	self flag: 'Check which quadrant the shape is being added to and rotate for that quadrant'.
	shapeSymbol := self getShapeFromBag.
	"shape := #I."
	state at: #shape put: (self rotateShape: shapeSymbol 
										forQuadrant: (state at: #levelOrientation)).
	state at: #shapeType put: shapeSymbol.
	state at: #shapeLocation put: 
		(self getShapeStartingLocation: shapeSymbol forQuadrant: (state at: #levelOrientation)).
]

{ #category : #'add shape' }
SqModel >> canAcceptShape [
	"Check if the shape collides with board cells, if so game over. Return either true or false"
	self flag: 'TODO'.
	^ true.
]

{ #category : #utility }
SqModel >> centralToGlobal: aPoint [
	| o origin |
	o := (((state at: #levelSize) / 2.0) floor) + 1.
	origin := o@o.
	
	^ (origin x + aPoint x) @ (origin y - aPoint y).
	
]

{ #category : #'add shape' }
SqModel >> changeQuadrant: aQuadrant [
	"state at: #levelOrientation put: aQuadrant."
	Transcript show: 'changeQuadrant: ' , aQuadrant asString; cr. 
	
	"
	1. Find what the rotated shape should be in new quadrant.
	2. Find the location of the shape in new quadrant.
	"
	state at: #shape put: (self rotateShape: (state at: #shapeType) forQuadrant: aQuadrant).
	
	"find the location of the shape in new quadrant"
	state at: #shapeLocation put: (self rotatePointToQuadrant: aQuadrant).
	state stateChanged.
	
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

{ #category : #'add shape' }
SqModel >> getShape: aSymbol [
	aSymbol = #I ifTrue: [ ^ self class IShape ].
	aSymbol = #J ifTrue: [ ^ self class JShape ].
	aSymbol = #L ifTrue: [ ^ self class LShape ].
	aSymbol = #O ifTrue: [ ^ self class OShape ].
	aSymbol = #S ifTrue: [ ^ self class SShape ].
	aSymbol = #T ifTrue: [ ^ self class TShape ].
	aSymbol = #Z ifTrue: [ ^ self class ZShape ].
]

{ #category : #'add shape' }
SqModel >> getShapeBag [
	"A shape bag is just a Dictionary. When we take a shape from it we mark that shape unusable. The shape bag consists of 28 elements"
	"^ Dictionary new
		at: 1 put: #IShape;
		at: 2 put: #"
	^ OrderedCollection newFrom: #(#I #J #L #O #S #T #Z #I #J #L #O #S #T #Z #I #J #L #O #S #T #Z #I #J #L #O #S #T #Z).
]

{ #category : #'add shape' }
SqModel >> getShapeFromBag [
	"From the #shapeBag get a random piece, if the bag is empty then make a new 
	bag"
	
	| shape rand generator |
	generator := Random new seed: 1.
	(state at: #shapeBag) size = 1 ifTrue: [ state at: #shapeBag put: self getShapeBag ].
	rand := (state at: #shapeBag) size atRandom: generator.
	shape := (state at: #shapeBag) at: rand.
	state at: #shapeBag put: ((state at: #shapeBag) removeAt: rand).
	^ shape.
]

{ #category : #'add shape' }
SqModel >> getShapeStartingLocation: aShapeSymbol forQuadrant: aQuadrant [
	"Provides the starting location in global coordinates"
	| point |
	(aShapeSymbol = #I or: aShapeSymbol = #O) ifTrue: [ point := 0.5@15.5 ] ifFalse: [ point := 0@15 ].
	
	aQuadrant = #Up ifTrue: [ ^ self centralToGlobal: point ].
	aQuadrant = #Right ifTrue: [ ^ self centralToGlobal: (self rotate: 90 point: point) ].
	aQuadrant = #Down ifTrue: [ ^ self centralToGlobal: (self rotate: 180 point: point) ].
	aQuadrant = #Left ifTrue: [ ^ self centralToGlobal: (self rotate: 270 point: point) ].
]

{ #category : #utility }
SqModel >> globalToCentral: aPoint [
	| o origin |
	o := (((state at: #levelSize) / 2.0) floor) + 1.
	origin := o@o.
	^ (o - aPoint x) negated @ (o - aPoint y)
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
	state at: #shapeBag put: (self getShapeBag).
	state at: #shapeLocation put: nil.
	"Level"
	state at: #levelSize put: 31. 
	state at: #offset put: 20@10.
	state at: #levelOrientation put: #Up.
	state at: #levelRotation put: 0.
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

{ #category : #level }
SqModel >> orientationRotation: aQuadrant [
	"Return the degree of the orientation"
	((Dictionary new
		at: #Up put: 0;
		at: #Down put: 90;
		at: #Right put: 180;
		at: #Left put: 270;
								
		yourself) at: (state at: #levelOrientation)) at: aQuadrant.
]

{ #category : #utility }
SqModel >> pixelToPoint: aPoint [
]

{ #category : #utility }
SqModel >> pointToPixel: aPoint [
]

{ #category : #utility }
SqModel >> quadrant: aQuadrant toCentral: aQuadrantPoint [ 
	"Convert a quadrant coordinate to global coordinates. Quadrant coordinates divide the quadrant into positive and negative on the horizontal axis and the ring number count is used vertically"
	aQuadrant = #Up ifTrue: [ ^ aQuadrantPoint ].
	aQuadrant = #Down ifTrue: [  ].
	aQuadrant = #Right ifTrue: [  ].
	aQuadrant = #Left ifTrue: [  ].
	
]

{ #category : #utility }
SqModel >> quadrant: aQuadrant toGlobal: aPoint [ 
	"Convert a quadrant coordinate to global coordinates. Quadrant coordinates divide the quadrant into positive and negative on the horizontal axis and the ring number count is used vertically"
	aQuadrant = #Up ifTrue: [  ].
	aQuadrant = #Down ifTrue: [  ].
	aQuadrant = #Right ifTrue: [  ].
	aQuadrant = #Left ifTrue: [  ].
	
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
SqModel >> rotate: aDegree [ ": Integer, multiples of  90"
	"rotate the shape by aDegree, do this by removing 90 from aDegree until 0 degree is reached."
	| shape degree |
	degree := aDegree.
	shape := (state at: #shape) copy.
	[ degree >= 90 ] whileTrue: [ 
		1 to: 4 do: [ :i |
			| point newPoint |
			point := (state at: #shape) atWrap: i.
			newPoint := point y negate @ point x.
			shape atWrap: i put: newPoint.
			].
		degree := aDegree - 90.
		].
	^ shape
]

{ #category : #utility }
SqModel >> rotate: aDegree point: aPoint [
	"point must be in central coordinates"
	| point degree |
	degree := aDegree.
	point := aPoint copy.
	[ degree >= 90 ] whileTrue: [ 
		point := point y @ point x negated.
		degree := degree - 90.
		].
	^ point
]

{ #category : #rotate }
SqModel >> rotate: aDegree ": Integer, multiples of  90" shape: aShape [ ": the shape to be rotated"
	"rotate the shape by aDegree, do this by removing 90 from aDegree until 0 degree is reached."
	| shape degree |
	degree := aDegree.
	shape := aShape copy.
	[ degree >= 90 ] whileTrue: [ 
		1 to: 4 do: [ :i |
			| point newPoint |
			point := shape atWrap: i.
			newPoint := point y negated @ point x.
			shape atWrap: i put: newPoint.
			].
		degree := degree - 90.
		].
	^ shape
]

{ #category : #level }
SqModel >> rotateLevel: aQuadrant [
	"rotate the level so that aQuadrant is top"
]

{ #category : #'add shape' }
SqModel >> rotatePoint: aPoint toQuadrant: aQuadrant [
	
	| point degree |
	
	point := state at: #shapeLocation.
	^ (point y negated)@(point x).
	
	
]

{ #category : #'add shape' }
SqModel >> rotatePointToQuadrant: aQuadrant [
	
	| point orientation |
	
	point := self globalToCentral: (self getShapeStartingLocation: (state at: #shapeType) forQuadrant: aQuadrant).
	
	orientation := state at: #levelOrientation.
	
	orientation == #Up ifTrue: [ ^ self centralToGlobal: point  ].
	
	orientation == #Right ifTrue: [ ^ self centralToGlobal: (self rotate: 90 point: point) ].
	
	orientation == #Down ifTrue: [ ^ self centralToGlobal: (self rotate: 180 point: point) ].
	
	orientation == #Left ifTrue: [ ^ self centralToGlobal: (self rotate: 270 point: point) ].
	
	
]

{ #category : #'add shape' }
SqModel >> rotateShape: aShapeSymbol forQuadrant: aQuadrant [
	| shape |
	
	shape := self getShape: aShapeSymbol.
	
	"aQuadrant == #Up ifTrue: [  ]."

	aQuadrant == #Right ifTrue: [ 
		shape := self rotate: 90 shape: shape ].
	
	aQuadrant == #Down ifTrue: [ 
		shape := self rotate: 180 shape: shape ].
	
	aQuadrant == #Left ifTrue: [ 
		shape := self rotate: 270 shape: shape ].
	
	^ shape
	
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

{ #category : #level }
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
