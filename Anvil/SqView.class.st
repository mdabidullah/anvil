Class {
	#name : #SqView,
	#superclass : #BlElement,
	#instVars : [
		'state'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #initialization }
SqView >> initialize [
	super initialize.
	
	self enqueueTask: (BlRepeatedTaskAction new delay: 16 milliSeconds; action: [ self step] ).
]

{ #category : #'stepping and presenter' }
SqView >> step [
]
