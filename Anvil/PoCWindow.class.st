Class {
	#name : #PoCWindow,
	#superclass : #BlSpace,
	#instVars : [
		'view'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #initialization }
PoCWindow >> initialize [
	view := PoCView new.
]

{ #category : #initialization }
PoCWindow >> state: aState [
	view state: aState.
]

{ #category : #initialization }
PoCWindow >> stateChanged [
	view update.
]
