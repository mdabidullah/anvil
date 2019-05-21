Class {
	#name : #DrawingTest,
	#superclass : #BlElement,
	#instVars : [
		'damageReported',
		'flip',
		'colour'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #drawing }
DrawingTest >> drawOnSpartaCanvas: aCanvas [
	aCanvas fill
		path: (self bounds inParent asRectangle );
		paint: colour;
		draw.
]

{ #category : #drawing }
DrawingTest >> fullDrawOnSpartaCanvas: aCanvas [
	aCanvas fill
		path: (self bounds inParent asRectangle );
		paint: colour;
		draw.
]

{ #category : #initialization }
DrawingTest >> initialize [
	super initialize.
	self size: 50@50.
	flip := false.
	self enqueueTask: (BlRepeatedTaskAction new delay: 500 milliSeconds; action: [ 
		flip ifTrue: [ colour := Color red. 
							flip := false. 
							self invalidate. ] 
			 ifFalse: [ colour := Color green. 
						   flip := true.
						   self invalidate. ]]).
	damageReported := false.
	self flag: 'Can I invalidate a rectangular subarea with invalidate:from: ?'
]
