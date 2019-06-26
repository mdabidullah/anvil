"
This is just a dead-simple implementation of Foldable that delegates the work to whatever collection you pass in (calling whatever selector you pass in, usually #inject:into:).

You can optionally also pass in a selector for parallel folding (usually #fold:), but if you don't then it'll just default to sequential folding.
"
Class {
	#name : #SimpleFoldable,
	#superclass : #Foldable,
	#instVars : [
		'originalReducible',
		'leftReductionSelector',
		'monoidalReductionSelector'
	],
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
SimpleFoldable >> fold: aMonoid [
	^ monoidalReductionSelector
		ifNil: [ self inject: aMonoid identityElement into: aMonoid combiningBlock ]
		ifNotNil: [
			"Sneakily using #value:value:value: so that we could use a block instead of a Symbol if we wanted to."
			monoidalReductionSelector value: originalReducible value: aMonoid
		]

]

{ #category : #'as yet unclassified' }
SimpleFoldable >> initializeForCollection: aCollection injectMethodName: aSymbol [
	self initializeForCollection: aCollection injectMethodName: aSymbol foldMethodName: nil.
]

{ #category : #'as yet unclassified' }
SimpleFoldable >> initializeForCollection: aCollection injectMethodName: symbol1 foldMethodName: symbol2 [
	originalReducible := aCollection.
	leftReductionSelector := symbol1.
	monoidalReductionSelector := symbol2.
]

{ #category : #'as yet unclassified' }
SimpleFoldable >> inject: initialValue into: aBlock [
	"Sneakily using #value:value:value: so that we could use a block instead of a Symbol if we wanted to."
	^ leftReductionSelector value: originalReducible value: initialValue value: aBlock
]
