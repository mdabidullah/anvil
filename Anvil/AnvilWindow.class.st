Class {
	#name : #AnvilWindow,
	#superclass : #BlSpace,
	#instVars : [
		'view'
	],
	#category : #'Anvil-Base'
}

{ #category : #anvil }
AnvilWindow >> addChild: aBlElement [
	super addChild: aBlElement.
	view := aBlElement.
]

{ #category : #anvil }
AnvilWindow >> close [
	view unsubscribe.
	super close.
]

{ #category : #anvil }
AnvilWindow >> initialize [
	super initialize.
]

{ #category : #anvil }
AnvilWindow >> state: aState [
	view state: aState.
]

{ #category : #anvil }
AnvilWindow >> stateChanged [
	view update.
]
