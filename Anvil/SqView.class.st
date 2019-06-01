Class {
	#name : #SqView,
	#superclass : #BlElement,
	#instVars : [
		'state'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #drawing }
SqView >> drawOnSpartaCanvas: aCanvas [
	
	"draw background"
	
	"draw placed cells"
	
	"draw current shape"
]

{ #category : #initialization }
SqView >> initialize [
	super initialize.
	
	self enqueueTask: (BlRepeatedTaskAction new delay: 16 milliSeconds; action: [ self step] ).
]
