"
Here I'll discuss the plan for how the game will work. 
"
Class {
	#name : #SqModel,
	#superclass : #Object,
	#instVars : [
		'state'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #'shape matrices' }
SqModel class >> IMatrix [
	^ Array2D new rows: 4 columns: 4 contents: #( 0 0 0 0
														 	   1 1 1 1
														 	   0 0 0 0
															   0 0 0 0 )
]

{ #category : #'shape matrices' }
SqModel class >> JMatrix [
	^ Array2D new rows: 3 columns: 3 contents: #( 1 0 0 
															   1 1 1 
															   0 0 0 )
]

{ #category : #'shape matrices' }
SqModel class >> LMatrix [
	^ Array2D new rows: 3 columns: 3 contents: #( 0 0 1 
															   1 1 1 
															   0 0 0 )
]

{ #category : #'shape matrices' }
SqModel class >> OMatrix [
	^ Array2D new rows: 2 columns: 2 contents: #( 1 1 
															   1 1 )
]

{ #category : #'shape matrices' }
SqModel class >> SMatrix [
	^ Array2D new rows: 3 columns: 3 contents: #( 0 1 1 
															   1 1 0 
															   0 0 0 )
]

{ #category : #'shape matrices' }
SqModel class >> TMatrix [
	^ Array2D new rows: 3 columns: 3 contents: #( 0 1 0 
															   1 1 1 
															   0 0 0 )
]

{ #category : #'shape matrices' }
SqModel class >> ZMatrix [
	^ Array2D new rows: 3 columns: 3 contents: #( 1 1 0 
															   0 1 1 
															   0 0 0 )
]

{ #category : #accessing }
SqModel class >> fallingDirection: aPoint [
]

{ #category : #accessing }
SqModel class >> quadrant: aQuadrant [
]

{ #category : #ring }
SqModel >> checkForRing [
]

{ #category : #ring }
SqModel >> checkForRings [
]

{ #category : #moving }
SqModel >> downDiagonal: aDirection [
]

{ #category : #moving }
SqModel >> drop [
]

{ #category : #'event handling' }
SqModel >> dropDown [
]

{ #category : #moving }
SqModel >> enterDiagonal: aDirection [
]

{ #category : #event }
SqModel >> event: aEvent [
	aEvent == #Left ifTrue: [ self moveLeft ].
	aEvent == #Right ifTrue: [ self moveRight ].
	aEvent == #Up ifTrue: [ self moveUp ].
	aEvent == #Down ifTrue: [ self moveDown ].
]

{ #category : #moving }
SqModel >> exitDiagonal: aDirection [
]

{ #category : #anvil }
SqModel >> initialize [ 
]

{ #category : #ring }
SqModel >> manageCascade [
]

{ #category : #moving }
SqModel >> move: aDirection [
]

{ #category : #'event handling' }
SqModel >> moveDown [
]

{ #category : #moving }
SqModel >> moveInDiagonal: aDirection [
]

{ #category : #'event handling' }
SqModel >> moveLeft [
]

{ #category : #moving }
SqModel >> movePossible: aDirection [
]

{ #category : #'event handling' }
SqModel >> moveRight [
]

{ #category : #'event handling' }
SqModel >> moveUp [
]

{ #category : #moving }
SqModel >> moveValid: aDirection [
]

{ #category : #ring }
SqModel >> removeRing [
]

{ #category : #'event handling' }
SqModel >> rotate [
]

{ #category : #rotating }
SqModel >> rotateClockWise [
]

{ #category : #rotating }
SqModel >> rotationPossible [

]

{ #category : #anvil }
SqModel >> state: aState [
	state := aState.
	self flag: 'initialize state'.
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

{ #category : #'stepping and presenter' }
SqModel >> step [
	| current |
	current := state at: #time.
	
	current := current - 0.5.
	
	(current < 0 or: (current == 0))
		ifTrue: [ Transcript show: 'Drop'; cr. state at: #time put: 1.0 ] 
	   ifFalse: [ state at: #time put: current ].
]
