"
A Seq is pretty much just a lazy version of a linked list. So here we have a normal linked list, implemented as a non-lazy version of a lazy Seq.
"
Class {
	#name : #List,
	#superclass : #Seq,
	#classInstVars : [
		'cachedEmptyOne'
	],
	#category : #'Immutable-Collections'
}

{ #category : #creating }
List class >> containing: aSequenceableCollection [
	| r |
	r := self empty.
	aSequenceableCollection reverseDo: [ :e | r := r cons: e ].
	^ r
]

{ #category : #creating }
List class >> containingReversed: collection [
	^ collection inject: self empty into: [:r :e | r cons: e]
]

{ #category : #creating }
List class >> createWithFirst: f rest: r [
	^ List new initializeWithFirst: f rest: r
]

{ #category : #creating }
List class >> empty [
	^ cachedEmptyOne
]

{ #category : #creating }
List class >> initialize [
	cachedEmptyOne := self createWithFirst: nil rest: nil.
]

{ #category : #'as yet unclassified' }
List >> calculateFirstAndRest [
	self error: 'Should never be called.'.
]

{ #category : #'as yet unclassified' }
List >> initializeWithFirst: first rest: rest [
	cachedFirst := first.
	cachedRest := rest.
	hasCalculatedFirstAndRest := true.
]

{ #category : #'as yet unclassified' }
List >> unsafeFirst [
	"Necessary because otherwise we get into infinite loops when trying to, for example, inspect a not-yet-initialized List."
	^ cachedFirst
]

{ #category : #'as yet unclassified' }
List >> unsafeRest [
	"Necessary because otherwise we get into infinite loops when trying to, for example, inspect a not-yet-initialized List."
	^ cachedRest
]
