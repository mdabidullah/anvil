Class {
	#name : #PoCWindow,
	#superclass : #BlSpace,
	#instVars : [
		'view'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #initialization }
PoCWindow >> addChild: aBlElement [
	super addChild: aBlElement.
	view := aBlElement.
]

{ #category : #initialization }
PoCWindow >> initialize [
	super initialize.
]

{ #category : #initialization }
PoCWindow >> state: aState [
	view state: aState.
]

{ #category : #initialization }
PoCWindow >> stateChanged [
	view update.
]

{ #category : #initialization }
PoCWindow >> view: aBlElement [
	view := aBlElement.
	self addChild: view.
]
