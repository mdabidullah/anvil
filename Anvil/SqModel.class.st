Class {
	#name : #SqModel,
	#superclass : #Object,
	#instVars : [
		'state'
	],
	#category : #'Anvil-SquareSquare'
}

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
	"state at: #key put: value". 
]
