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
	#category : #'Anvil-SquareSquare'
}

{ #category : #'as yet unclassified' }
SqModel class >> IMatrix [
	^ Array2D new rows: 4 columns: 4 contents: #( 0 0 0 0
														 	   1 1 1 1
														 	   0 0 0 0
															   0 0 0 0 )
]

{ #category : #anvil }
SqModel >> checkForRing [
]

{ #category : #anvil }
SqModel >> checkForRings [
]

{ #category : #anvil }
SqModel >> drop [
]

{ #category : #anvil }
SqModel >> dropToBottom [
	"Drop all the way to bottom"
]

{ #category : #anvil }
SqModel >> enterDiagonal: aDirection [
]

{ #category : #anvil }
SqModel >> event: aEvent [
	aEvent == #Left ifTrue: [ self move: #Left ].
	aEvent == #Right ifTrue: [ self move: #Right ].
	aEvent == #Up ifTrue: [ self move: #Up ].
	aEvent == #Down ifTrue: [ self move: #Down ].
]

{ #category : #anvil }
SqModel >> exitDiagonal: aDirection [
]

{ #category : #anvil }
SqModel >> initializeState [
	"Time"
	state at: #time put: 1.0.
	
	"Shape"
	state at: #shapeLocations put: #(0@0 0@0 0@0 0@0). 
	state at: #shapeMatrix put: SqModel IMatrix.
	state at: #matrixLocation: put: 15@1.
	state at: #shapeRotation put: 0.
	
	"Level"
	state at: #levelSize put: 31. 
	state at: #offset put: 20@10.
	state at: #levelOrientation put: 0.
	state at: #level put: (Array2D rows: (state at: #levelSize)
										   columns: (state at: #levelSize)).
										
	"Visual"
	state at: #cellSize put: 15.
]

{ #category : #anvil }
SqModel >> manageCascade [
]

{ #category : #anvil }
SqModel >> move: aDirection [
]

{ #category : #anvil }
SqModel >> moveDownDiagonal [
]

{ #category : #anvil }
SqModel >> moveInDiagonal: aDirection [
]

{ #category : #anvil }
SqModel >> movePossible: aDirection [
]

{ #category : #anvil }
SqModel >> moveValid: aDirection [
]

{ #category : #anvil }
SqModel >> removeDirection [
]

{ #category : #anvil }
SqModel >> removeRing [
]

{ #category : #anvil }
SqModel >> rotate [
]

{ #category : #anvil }
SqModel >> rotationPossible [
]
