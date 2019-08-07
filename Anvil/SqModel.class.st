"
State values:

#Time#
______

#time: a countdown until the shape must be dropped

#Shape Related#
_______________

#shape : an Array containing Points, each point represents the location of a cell which makes up the shape in relation to the #shapeLocation

#shapeType : a Symbol, representing the kind of shape.

#shapeBag : an OrderedCollection containing Symbols representing #shapeTypes, used for random shape picking

#shapeLocation : a Point, representing the origin of the shape. 

#shapeCoordinates : an Array, containing the cell coordinates the shape is occupying in the level, is zero-indexed.

#inDiagonal: a Boolean, states whether the shape is in Diagonal.

#diagonalEntryDirection : a Symbol, representing the direction the shape entered the diagonal.

#diagonalLocation: a Point, representing the location of the diagonal cell.

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
SqModel >> acceptShape [
	Transcript show: 'Accepted Shape'; cr.
	
	"Check if the shape collides with placed cells, if so game over. Return either true or false."
	1 to: 4 do: [ :i |
		| point |
		point := (state at: #shapeCoordinates) atWrap: i.
		"#shapeCoordinates is zero-indexed, #level is one-indexed"
		point := point + (1@1).
		((state at: #level) includes: point) ifTrue: [ ^ false ]
	].
	
	self rotateLevel: (self quadrant: (state at: #shapeLocation)). 
	^ true.
	
]

{ #category : #'add shape' }
SqModel >> addNewShape [
	| shapeSymbol |
	"shapeSymbol := self getShapeFromBag."
	shapeSymbol := #Z.
	state at: #shape put: (self rotateShape: shapeSymbol 
										forQuadrant: (state at: #levelOrientation)).
	state at: #shapeType put: shapeSymbol.
	state at: #shapeLocation put: 
		(self getShapeStartingLocation: shapeSymbol forQuadrant: (state at: #levelOrientation)).
		
	state at: #shapeCoordinates put: (self getActiveShapeCellCoordinates).
]

{ #category : #utility }
SqModel >> centralToGlobal: aPoint [
	| o origin |
	o := (((state at: #levelSize) / 2.0) floor).
	origin := o@o.
	
	^ (origin x + aPoint x) @ (origin y - aPoint y).
	
]

{ #category : #'add shape' }
SqModel >> changeQuadrant: aQuadrant [
	state at: #shape put: (self rotateShape: (state at: #shapeType) forQuadrant: aQuadrant).
	
	"find the location of the shape in new quadrant"
	state at: #shapeLocation put: (self rotatePointToQuadrant: aQuadrant).
	state at: #shapeCoordinates put: (self getActiveShapeCellCoordinates).
	state stateChanged.
	
]

{ #category : #rotate }
SqModel >> changeShape: aShape withLocation: aPoint [
	state at: #shape put: aShape.
	
	state at: #shapeLocation put: aPoint.
		
	state at: #shapeCoordinates put: (self getActiveShapeCellCoordinates).
	
	state stateChanged.
]

{ #category : #move }
SqModel >> changeShapeLocation: aPoint [ 
	state at: #shapeLocation put: aPoint.
		
	state at: #shapeCoordinates put: (self getActiveShapeCellCoordinates).
	
	state stateChanged.
]

{ #category : #move }
SqModel >> changeShapeLocation: aPoint withCoordinates: aCoordinateArray [
	state at: #shapeLocation put: aPoint.
		
	state at: #shapeCoordinates put: aCoordinateArray.
	
	state stateChanged.
]

{ #category : #ring }
SqModel >> checkForRing [
]

{ #category : #ring }
SqModel >> checkForRings [
]

{ #category : #utility }
SqModel >> diagonal: aPoint [
	| centralPoint |
	centralPoint := self globalToCentral: aPoint.
	
	(centralPoint x > 0 and: [ centralPoint y > 0 ]) ifTrue: [ ^ #Up_Right ].
	
	(centralPoint x < 0 and: [ centralPoint y > 0 ]) ifTrue: [ ^ #Up_Left ].
	
	(centralPoint x > 0 and: [ centralPoint y < 0 ]) ifTrue: [ ^ #Down_Right ].
	
	(centralPoint x < 0 and: [ centralPoint y < 0 ]) ifTrue: [ ^ #Down_Left ].
]

{ #category : #diagonal }
SqModel >> enterDiagonal: aDirection withCoordinates: aCoordinateArray [
	"Change state to InDiagonal and user the aCoordinateArray to find the lowest cell"
	| point index |
	
	1 to: 4 do: [ :i |
		| absPoint |
		absPoint := (self globalToCentral: (aCoordinateArray atWrap: i)) abs. 
		absPoint x = absPoint y ifTrue: [ 
			point isNil ifTrue: [ 
				point := absPoint.
				index := i.
			] ifFalse: [ 
				absPoint < point ifTrue: [ 
					point := absPoint.
					index := i.
				]
			]
		]
	].
	
	point := aCoordinateArray atWrap: index.
	
	state at: #diagonalEntryDirection put: aDirection.
	state at: #diagonalLocation put: point.
	state at: #inDiagonal put: true.
	self rotateLevel: (self diagonal: point).
	
	stateMachine changeStateTo: #InDiagonal.
	
	
	
]

{ #category : #anvil }
SqModel >> event: aEvent [

	stateMachine handleEvent: aEvent.
]

{ #category : #diagonal }
SqModel >> exitDiagonal: aDirection [
	(state at: #diagonalEntryDirection) = aDirection ifTrue: [ 
		"Diagonal is trying to reflect"	
		| previousQuadrant currentDiagonal |
		self flag: 'TODO'.
		self halt.
		previousQuadrant := self quadrant: (state at: #shapeLocation).
		currentDiagonal := self diagonal: (state at: #diagonalLocation).
		((currentDiagonal = #Up_Right and: [ 
			previousQuadrant = #Up or: [ previousQuadrant = #Right ] ]) or: [ 
			currentDiagonal = #Down_Left and: [ 
				previousQuadrant = #Down or: previousQuadrant = #Left ] ]) ifTrue: [ 
			"reflect over y = x"
			| newCoordinates mX mY newShapeLocation |
			newCoordinates := { 0@0. 0@0. 0@0. 0@0 }. 
			
			1 to: 4 do: [ :i |
				| |
				newCoordinates atWrap: i put: 
					(((state at: #levelSize) - 1) - ((state at: #shapeCoordinates) at: i) y)
					@
					(((state at: #levelSize) - 1) - ((state at: #shapeCoordinates) at: i) x)
			].
			
			"mX := 31.
			mY := 31.
			
			1 to: 4 do: [ :i |
				mX := (newCoordinates atWrap: i) x min: mX.
				mY := (newCoordinates atWrap: i) y min: mY.
			].
			
			newShapeLocation := mX@mY."
			newShapeLocation := 
				(((state at: #levelSize) - 1) - (state at: #shapeLocation) y)
				@
				(((state at: #levelSize) - 1) - (state at: #shapeLocation) x). 
			
			state
			
		]
	]
]

{ #category : #utility }
SqModel >> fallingDirection: aQuadrant [
	aQuadrant = #Up ifTrue: [ ^ #Down ].
	aQuadrant = #Down ifTrue: [ ^ #Up ].
	aQuadrant = #Left ifTrue: [ ^ #Right ].
	aQuadrant = #Right ifTrue: [ ^ #Left ].
]

{ #category : #anvil }
SqModel >> gameOver [
]

{ #category : #level }
SqModel >> getActiveShapeCellCoordinates [
	"Returns the coordinates of the cells the shape is currently occupying in global coordinates"
	| array |
	array := { 0@0. 0@0. 0@0. 0@0 }.
	1 to: 4 do: [ :i |
		| |
		array at: i put: (state at: #shapeLocation) + ((state at: #shape) atWrap: i).
		 ].
	
	^ array.
]

{ #category : #utility }
SqModel >> getDirectionVector: aDirectionSymbol [
	aDirectionSymbol == #Up ifTrue: [ ^ 0@(-1)  ].
	aDirectionSymbol == #Right ifTrue: [ ^ 1@0 ].
	aDirectionSymbol == #Down ifTrue: [ ^ 0@1 ].
	aDirectionSymbol == #Left ifTrue: [ ^ (-1)@0 ].
				
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

{ #category : #level }
SqModel >> getShapeGlobalCoordinates: aShape location: aPoint [
	"Returns the coordinates of the cells the shape is currently occupying in global coordinates"
	| array |
	array := { 0@0. 0@0. 0@0. 0@0 }.
	1 to: 4 do: [ :i |
		| |
		array at: i put: aPoint + (aShape atWrap: i).
		 ].
	
	^ array.
]

{ #category : #'add shape' }
SqModel >> getShapeStartingLocation: aShapeSymbol forQuadrant: aQuadrant [
	"Provides the starting location in global coordinates"
	| point |
	(aShapeSymbol = #I or: aShapeSymbol = #O) ifTrue: [ point := 0.5@14.5 ] ifFalse: [ point := 0@15 ].
	
	aQuadrant = #Up ifTrue: [ ^ self centralToGlobal: point ].
	aQuadrant = #Right ifTrue: [ ^ self centralToGlobal: (self rotate: 90 point: point) ].
	aQuadrant = #Down ifTrue: [ ^ self centralToGlobal: (self rotate: 180 point: point) ].
	aQuadrant = #Left ifTrue: [ ^ self centralToGlobal: (self rotate: 270 point: point) ].
]

{ #category : #utility }
SqModel >> globalToCentral: aPoint [
	| o origin |
	o := (((state at: #levelSize) / 2.0) floor).
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
	state at: #shapeCoordinates put: nil.
	state at: #inDiagonal put: false.
	state at: #diagonalLocation put: nil.
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
	stateMachine addStateNamed: #Moving.
	stateMachine addStateNamed: #InDiagonal. 
	stateMachine addStateNamed: #Landed.
	stateMachine addStateNamed: #GameOver.

	stateMachine 
		setDecisionFrom: #AcceptShape 
		if: [ self acceptShape ] 
		trueTo: #InQuadrant
		falseTo: #GameOver.

	(stateMachine stateAt: #ChooseQuadrant) 
		when: #Space to: #AcceptShape;
		when: #Up do: [ self changeQuadrant: #Up ] to: #ChooseQuadrant;
		when: #Down do: [ self changeQuadrant: #Down ] to: #ChooseQuadrant;
		when: #Left do: [ self changeQuadrant: #Left ] to: #ChooseQuadrant;
		when: #Right do: [ self changeQuadrant: #Right ] to: #ChooseQuadrant.
		
	(stateMachine stateAt: #InQuadrant)
		when: #Up do: [ self move: #Up ] to: #Moving;
		when: #Down do: [ self move: #Down ] to: #Moving;
		when: #Right do: [ self move: #Right ] to: #Moving;
		when: #Left do: [ self move: #Left ] to: #Moving;
		when: #Space do: [ self rotate ] to: #InQuadrant.

	stateMachine 
		setDecisionFrom: #Moving 
		if: [ self isInDiagonal ] 
		trueTo: #InDiagonal
		falseTo: #InQuadrant.

	(stateMachine stateAt: #InDiagonal)
		when: #Down do: [ self moveDownDiagonal  ] to: #InDiagonal;
		when: #Right do: [ self exitDiagonal: #Right ] to: #InQuadrant;
		when: #Left do: [ self exitDiagonal: #Left ] to: #InQuadrant.
		
	stateMachine setStartStateTo: #ChooseQuadrant.
]

{ #category : #shape }
SqModel >> isInDiagonal [
	^ state at: #inDiagonal
]

{ #category : #level }
SqModel >> isOccupied: aPoint [
	"Answer if this point is occupied in the level"
	self flag: 'TODO'.
	^ false.
]

{ #category : #ring }
SqModel >> manageCascade [
]

{ #category : #move }
SqModel >> move: aDirection [
	| newCoordinates translatedDirection fallingDirection newLocation movePossible directionVector 
	  currentQuadrant |
	Transcript show: 'move: '; show: aDirection; cr.
	
	"Check if this move is valid, the shape should not move up a ring or move out of the level"
	(aDirection == #Up) ifTrue: [ ^ self ].
	newCoordinates := { 0@0. 0@0. 0@0. 0@0. }.
	translatedDirection := self translateAction: aDirection.
	directionVector := self getDirectionVector: translatedDirection.
	"Check if move is valid"
	1 to: 4 do: [ :i |
		| newPoint|
		newPoint := ((state at: #shapeCoordinates) atWrap: i) + directionVector.
		(newPoint x >= 0 and: [newPoint y >= 0 and: [newPoint x <= (state at: #levelSize) and: [newPoint y <= (state at: #levelSize)]]])
			ifFalse: [ ^ self ]. 
		newCoordinates atWrap: i put: newPoint
		].
	
	movePossible := true.
	currentQuadrant := self quadrant: ((state at: #shapeCoordinates) atWrap: 1). 
	newLocation := (state at: #shapeLocation) + directionVector.
	fallingDirection := self fallingDirection: currentQuadrant.
	
	1 to: 4 do: [ :i |
		| newQuadrant |
		newQuadrant := self quadrant: (newCoordinates atWrap: i).
		
		newQuadrant = #Diagonal ifTrue: [ 
			translatedDirection = fallingDirection 
				ifFalse: [ 
					Transcript show: 'Trying to move into a diagonal'; cr.
					self enterDiagonal: translatedDirection withCoordinates: newCoordinates. ]
				ifTrue: [ 
					Transcript show: 'Dropping onto a diagonal'.
					self stopShape.
					].
			^ self. 
		].
		(self isOccupied: (newCoordinates atWrap: i)) ifTrue: [
			translatedDirection = fallingDirection ifTrue: [ 
				Transcript show: 'Moving in dropping direction'; cr.
				self stopShape.
				^ self.
			].
		].
		
		"It must be possible to move"
		self changeShapeLocation: newLocation withCoordinates: newCoordinates.
	].
	
	
]

{ #category : #diagonal }
SqModel >> moveDownDiagonal [
	| diagonal |
	self flag: 'Deal with landing when at the bottom'.
	diagonal := self diagonal: (state at: #diagonalLocation).
	
	diagonal = #Up_Right ifTrue: [ 
		| newPoint |
		
		newPoint := (state at: #diagonalLocation) + ((-1)@1).
		(self quadrant: newPoint) = #Center ifFalse: [ 
			state at: #diagonalLocation put: newPoint.
			state stateChanged.
		].
		^ self.
	].

	diagonal = #Up_Left ifTrue: [ 
		| newPoint |
		
		newPoint := (state at: #diagonalLocation) + (1@1).
		(self quadrant: newPoint) = #Center ifFalse: [ 
			state at: #diagonalLocation put: newPoint.
			state stateChanged.
		].
		^ self.
	].

	diagonal = #Down_Right ifTrue: [ 
		| newPoint |
		
		newPoint := (state at: #diagonalLocation) + ((-1)@(-1)).
		(self quadrant: newPoint) = #Center ifFalse: [ 
			state at: #diagonalLocation put: newPoint.
			state stateChanged.
		].
		^ self.
	].

	diagonal = #Down_Left ifTrue: [ 
		| newPoint |
		
		newPoint := (state at: #diagonalLocation) + (1@(-1)).
		(self quadrant: newPoint) = #Center ifFalse: [ 
			state at: #diagonalLocation put: newPoint.
			state stateChanged.
		].
		^ self.
	].
]

{ #category : #level }
SqModel >> orientationRotation: aQuadrant [
	"Return the degree of the orientation"
	^ (Dictionary new
		at: #Up put: 0;
		at: #Right put: -90;
		at: #Down put: -180;
		at: #Left put: -270;
		at: #Up_Right put: -45;
		at: #Up_Left put: -315;
		at: #Down_Right put: -135;
		at: #Down_Left put: -225;
		yourself) at: aQuadrant.
]

{ #category : #utility }
SqModel >> pixelToPoint: aPoint [
]

{ #category : #utility }
SqModel >> pointToPixel: aPoint [
]

{ #category : #utility }
SqModel >> quadrant: aGlobalPoint [
	| point levelSize centerPoints |
	point := self globalToCentral: aGlobalPoint.
	levelSize := ((state at: #levelSize) / 2.0) floor.
	(point x > levelSize or: [ 
		point y > levelSize or: [ 
		point x < (levelSize negated) or: [ 
		point y < (levelSize negated) ] ] ])
		ifTrue: [ Transcript show: 'Point out of bounds. Point is: '; show: point; cr.
			self halt. 
			^ self ].
	centerPoints := OrderedCollection newFrom: 
								  { (-1)@1.    0@1.    1@1.
									 (-1)@0.    0@0.    1@0.
									 (-1)@(-1). 0@(-1). 1@(-1). }.

									
	(centerPoints contains: [ :aPoint | aPoint = point]) ifTrue: [ ^ #Center ].
	
	point y abs = point x abs ifTrue: [ ^ #Diagonal ].
	
	(point y > 0 and: [ point x >= (point y - 1) negated and: [ 
		point x <= (point y - 1) ] ]) ifTrue: [ ^ #Up ].
	
	(point y < 0 and: [ point x >= (point y abs - 1) negated and: [ 
		point x <= (point y abs - 1) ] ]) ifTrue: [ ^ #Down ]. 

	(point x > 0 and: [ point y >= (point x - 1) negated and: [ 
		point y <= (point x - 1) ] ]) ifTrue: [ ^ #Right ].
	
	(point x < 0 and: [ point y >= (point x abs - 1) negated and: [  
		 point y <= (point x abs - 1)] ]) ifTrue: [ ^ #Left ].
	
	Transcript show: 'Some kind of error. Point was: '; show: point; cr.
	
	self halt.
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
	| newShape |
	self flag: 'TODO'.
	newShape := self rotationPossible: (state at: #shapeLocation).
	
	newShape ifNotNil: [ :shape |
		self changeShape: shape withLocation: (state at: #shapeLocation).
		^ self.
	] ifNil: [ 
	
	]
	
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
	state at: #levelOrientation put: aQuadrant.
	state at: #levelRotation put: (self orientationRotation: aQuadrant).
	state stateChanged.
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

{ #category : #rotate }
SqModel >> rotationPossible: aPoint [
	| shape shapeCoordinates |
	
	shape := self rotate: 90.
	
	shapeCoordinates := self getShapeGlobalCoordinates: shape location: (state at: #shapeLocation).
	
	1 to: 4 do: [ :i |
		| point |
		point := shapeCoordinates atWrap: i.
		((self isOccupied: point) 
			or: [ (self quadrant: point) = #Quadrant 
			or: [ (self quadrant: point) = #Center] ]) ifTrue: [ 
			^ nil.
		]. 		
	].

	^ shape.
	
]

{ #category : #initialization }
SqModel >> startGame [
	self initializeStateMachine.
	
	self addNewShape.
	
]

{ #category : #anvil }
SqModel >> step [
	
]

{ #category : #shape }
SqModel >> stopShape [
	self flag: 'TODO'.
]

{ #category : #utility }
SqModel >> translateAction: aDirection [
	^ ((Dictionary new
		at: #Up put: (Dictionary new 
			at: #Up put: #Up;
			at: #Right put: #Right; 
			at: #Down put: #Down;
			at: #Left put: #Left;
			yourself);
		at: #Right put: (Dictionary new 
			at: #Up put: #Right;
			at: #Right put: #Down; 
			at: #Down put: #Left;
			at: #Left put: #Up;
			yourself);
		at: #Down put: (Dictionary new 
			at: #Up put: #Down;
			at: #Right put: #Left; 
			at: #Down put: #Up;
			at: #Left put: #Right;
			yourself);
		at: #Left put: (Dictionary new 
			at: #Up put: #Left;
			at: #Right put: #Up; 
			at: #Down put: #Right;
			at: #Left put: #Down;
			yourself);
		at: #Up_Right put: (Dictionary new 
			at: #Up put: #Up;
			at: #Right put: #Right; 
			at: #Down put: #Down;
			at: #Left put: #Left;
			yourself);
		at: #Up_Left put: (Dictionary new 
			at: #Up put: #Up;
			at: #Right put: #Right; 
			at: #Down put: #Down;
			at: #Left put: #Left;
			yourself);
		at: #Down_Right put: (Dictionary new 
			at: #Up put: #Up;
			at: #Right put: #Right; 
			at: #Down put: #Down;
			at: #Left put: #Left;
			yourself);
		at: #Down_Left put: (Dictionary new 
			at: #Up put: #Up;
			at: #Right put: #Right; 
			at: #Down put: #Down;
			at: #Left put: #Left;
			yourself);			
		yourself) at: (state at: #levelOrientation)) at: aDirection
]
