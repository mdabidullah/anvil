"
So that the HashMap tests can reliably create different objects that have hash collisions.
"
Class {
	#name : #ObjectWithSpecifiableHash,
	#superclass : #Object,
	#instVars : [
		'hash'
	],
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
ObjectWithSpecifiableHash class >> createWithHash: h [
	^ self new initializeWithHash: h
]

{ #category : #'as yet unclassified' }
ObjectWithSpecifiableHash >> = other [
	^ self == other
]

{ #category : #'as yet unclassified' }
ObjectWithSpecifiableHash >> hash [
	^ hash
]

{ #category : #'as yet unclassified' }
ObjectWithSpecifiableHash >> initializeWithHash: h [
	hash := h.
]
