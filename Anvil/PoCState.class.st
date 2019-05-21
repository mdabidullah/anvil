Class {
	#name : #PoCState,
	#superclass : #Object,
	#instVars : [
		'location',
		'announcer'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #initialization }
PoCState >> announcer [ 
	^ announcer
]

{ #category : #initialization }
PoCState >> initialize [ 
	location := 100@100.
	announcer := Announcer new
]

{ #category : #initialization }
PoCState >> location [
	^ location
]

{ #category : #initialization }
PoCState >> location: aLocation [
	location := aLocation
]
