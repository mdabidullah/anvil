Class {
	#name : #Something,
	#superclass : #Maybe,
	#instVars : [
		'theThing'
	],
	#category : #'Immutable-Monads'
}

{ #category : #creating }
Something class >> withValue: v [
	^ self new initializeWithThing: v
]

{ #category : #'pattern-matching' }
Something >> ifAbsent: nothingBlock ifPresent: somethingBlock [
	^ somethingBlock cull: theThing
]

{ #category : #'pattern-matching' }
Something >> ifPresent: somethingBlock ifAbsent: nothingBlock [
	^ somethingBlock cull: theThing
]

{ #category : #'private-initialization' }
Something >> initializeWithThing: aValue [
	theThing := aValue.
]
