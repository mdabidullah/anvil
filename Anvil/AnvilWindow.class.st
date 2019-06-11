Class {
	#name : #AnvilWindow,
	#superclass : #BlSpace,
	#instVars : [
		'view',
		'game'
	],
	#category : #'Anvil-Prototype'
}

{ #category : #initialization }
AnvilWindow >> addChild: aBlElement [
	super addChild: aBlElement.
	view := aBlElement.
]

{ #category : #initialization }
AnvilWindow >> close [
	super close.
	game quit.
]

{ #category : #initialization }
AnvilWindow >> game: aAnvilGame [
	game := aAnvilGame.
]

{ #category : #initialization }
AnvilWindow >> initialize [
	super initialize.
]

{ #category : #initialization }
AnvilWindow >> state: aState [
	view state: aState.
]

{ #category : #initialization }
AnvilWindow >> stateChanged [
	Transcript show: 'Received announcement'.
	view update.
]
