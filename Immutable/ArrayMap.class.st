"
An immutable map, implemented as a dead-simple array of Associations. Find things by linear search. For small maps, it's more efficient than a full-blown HashMap.

An ArrayMap and a HashMap with the same pairs will respond true if compared using the = method. And If you try to make an ArrayMap that's bigger than the thresholdForSwitchingToHashMap, you'll get a HashMap instead. That is, don't worry about which particular Map class you've got; all that matters is that it's a Map.

"
Class {
	#name : #ArrayMap,
	#superclass : #Map,
	#instVars : [
		'associationsArray'
	],
	#classInstVars : [
		'thresholdForSwitchingToHashMap',
		'cachedEmptyOne'
	],
	#category : #'Immutable-Collections'
}

{ #category : #'as yet unclassified' }
ArrayMap class >> empty [
	^ cachedEmptyOne
]

{ #category : #'as yet unclassified' }
ArrayMap class >> from: associations [
	^ associations foldable into: self empty
]

{ #category : #'as yet unclassified' }
ArrayMap class >> initialize [
	cachedEmptyOne := self new initializeWithAssociations: {}.
]

{ #category : #'as yet unclassified' }
ArrayMap class >> performanceExperiment1 [
	"I still haven't quite figured out how to use this information. But the idea is to figure out how high the thresholdForSwitchingToHashMap should be.

	ArrayMap performanceExperiment1
	"
	| oldThreshold arrayMapsOfIncreasingSizes timesToMakeAModifiedArrayMap timesToAccessTheArrayMap hashMapsOfIncreasingSizes timesToMakeAModifiedHashMap timesToAccessTheHashMap |
	oldThreshold := thresholdForSwitchingToHashMap.
	thresholdForSwitchingToHashMap := 1000000. "never switch"

	arrayMapsOfIncreasingSizes := (1 to: 100 by: 10) collect: [ :i | (1 to: i) inject: ArrayMap empty into: [ :d :n | d with: n as: n * n ] ].
	hashMapsOfIncreasingSizes := (1 to: 100 by: 10) collect: [ :i | (1 to: i) inject: HashMap empty into: [ :d :n | d with: n as: n * n ] ].
	timesToMakeAModifiedArrayMap := arrayMapsOfIncreasingSizes collect: [ :d | [ 100000 timesRepeat: [ d with: 'anotherKey' as: 'whatever' ] ] timeToRun].
	timesToMakeAModifiedHashMap := hashMapsOfIncreasingSizes collect: [ :d | [ 100000 timesRepeat: [ d with: 'anotherKey' as: 'whatever' ] ] timeToRun].
	timesToAccessTheArrayMap := arrayMapsOfIncreasingSizes collect: [ :d | [ 100000 timesRepeat: [ d at: (d size / 2) ceiling ] ] timeToRun].
	timesToAccessTheHashMap := hashMapsOfIncreasingSizes collect: [ :d | [ 100000 timesRepeat: [ d at: (d size / 2) ceiling ] ] timeToRun].
	
	thresholdForSwitchingToHashMap := oldThreshold.

	^ 'timesToMakeAModifiedArrayMap is ', timesToMakeAModifiedArrayMap printString, ', timesToAccessTheArrayMap is ', timesToAccessTheArrayMap printString,  ', timesToMakeAModifiedHashMap is ', timesToMakeAModifiedHashMap printString, ', timesToAccessTheHashMap is ', timesToAccessTheHashMap printString

]

{ #category : #'as yet unclassified' }
ArrayMap class >> thresholdForSwitchingToHashMap [
	^ thresholdForSwitchingToHashMap ifNil: [ thresholdForSwitchingToHashMap := 10 ]
]

{ #category : #iterating }
ArrayMap >> associationsInject: initialValue into: aBlock [
	^ associationsArray inject: initialValue into: aBlock
]

{ #category : #iterating }
ArrayMap >> associationsSeq [
	^ associationsArray seq
]

{ #category : #accessing }
ArrayMap >> at: key ifPresent: presentBlock ifAbsent: absentBlock [
	"This is here for compatibility with normal Smalltalk collections, but I recommend that you use #maybeAt: instead."
	^ associationsArray detect: [ :a | key = a key] ifFound: [ :a | presentBlock cull: a value ] ifNone: [ absentBlock value ]
]

{ #category : #initializing }
ArrayMap >> initializeWithAssociations: anArrayOfAssociations [
	associationsArray := anArrayOfAssociations.
]

{ #category : #transforming }
ArrayMap >> mapValues: aBlock [
	^ self class new initializeWithAssociations: (associationsArray collect: [:a | a key -> (aBlock cull: a value cull: a key) ])
]

{ #category : #accessing }
ArrayMap >> size [
	^ associationsArray size
]

{ #category : #'"modifying"' }
ArrayMap >> with: key as: value [
	^ (1 to: associationsArray size)
		detect: [ :i | key = (associationsArray at: i) key]
		ifFound: [ :i | self class new initializeWithAssociations: (associationsArray copyWith: i as: key -> value) ]
		ifNone: [ | newAssociationsArray |
			newAssociationsArray := associationsArray copyAndAppend: key -> value.
			self size >= self class thresholdForSwitchingToHashMap
				ifTrue: [ HashMap from: newAssociationsArray ]
				ifFalse: [ self class new initializeWithAssociations: newAssociationsArray ]
		]
]

{ #category : #'"modifying"' }
ArrayMap >> without: key [
	^ (1 to: associationsArray size)
		detect: [ :i | key = (associationsArray at: i) key]
		ifFound: [ :i | self class new initializeWithAssociations: (associationsArray copyAndRemoveIndex: i) ]
		ifNone: [ self ]
]
