Class {
	#name : #SqWindow,
	#superclass : #BlSpace,
	#instVars : [
		'view',
		'game'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #anvil }
SqWindow >> addChild: aBlElement [
	super addChild: aBlElement.
	view := aBlElement.
]

{ #category : #anvil }
SqWindow >> close [
	super close.
	game quit.
]

{ #category : #anvil }
SqWindow >> game: aGame [
	game := aGame.
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
	Transcript show: 'Received announcement'.
	view update.
]
