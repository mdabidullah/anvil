Class {
	#name : #SqWindow,
	#superclass : #BlSpace,
	#instVars : [
		'view'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #anvil }
SqWindow >> addChild: aBlElement [
	super addChild: aBlElement.
	view := aBlElement.
]

{ #category : #anvil }
SqWindow >> initialize [
	super initialize.
]

{ #category : #anvil }
SqWindow >> state: aState [
	view state: aState.
]

{ #category : #anvil }
SqWindow >> stateChanged [
	view update.
]
