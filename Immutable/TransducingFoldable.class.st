Class {
	#name : #TransducingFoldable,
	#superclass : #Foldable,
	#instVars : [
		'originalReducible',
		'transducer'
	],
	#category : #'Immutable-Private'
}

{ #category : #creating }
TransducingFoldable >> initializeForReducible: aReducible transducer: aTransducer [
	originalReducible := aReducible.
	transducer := aTransducer.
]

{ #category : #enumerating }
TransducingFoldable >> inject: initialValue into: injectBlock [
	^ originalReducible inject: initialValue into: (transducer value: injectBlock)
]
