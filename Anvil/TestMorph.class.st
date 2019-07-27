Class {
	#name : #TestMorph,
	#superclass : #Morph,
	#category : #'Anvil-Testing'
}

{ #category : #'stepping and presenter' }
TestMorph >> step [
	self position: (self position) + (1@1).
]

{ #category : #'model - stepping' }
TestMorph >> stepTime [
	^ 26
]
