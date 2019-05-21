Class {
	#name : #PoCEventListener,
	#superclass : #BlElementEventListener,
	#instVars : [
		'game'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #'keyboard handlers' }
PoCEventListener >> game: aGame [
	game := aGame.
]

{ #category : #'keyboard handlers' }
PoCEventListener >> keystrokeEvent: aEvent [
	game event: aEvent.
]
