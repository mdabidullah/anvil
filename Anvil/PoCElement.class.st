Class {
	#name : #PoCElement,
	#superclass : #BlElement,
	#instVars : [
		'position'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #initialization }
PoCElement >> initialize [
	super initialize.
	
	self size: 20@20.
	
	self background: Color white
]
