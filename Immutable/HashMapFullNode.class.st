Class {
	#name : #HashMapFullNode,
	#superclass : #HashMapNode,
	#instVars : [
		'array'
	],
	#category : #'Immutable-Private'
}

{ #category : #iterating }
HashMapFullNode >> associationsInject: initialValue into: aBlock [
	^ array inject: initialValue into: [ :valueSoFar :n | n ifNil: [valueSoFar] ifNotNil: [n associationsInject: valueSoFar into: aBlock]]
]

{ #category : #iterating }
HashMapFullNode >> associationsSeq [
	^ array seq flatCollect: [ :n | n ifNil: [ List empty ] ifNotNil: [ n associationsSeq ] ]
]

{ #category : #accessing }
HashMapFullNode >> at: key level: l ifPresent: presentBlock ifAbsent: absentBlock [
	| index |
	index := HashMapNode indexForHash: key hash level: l.
	^ (array at: index) ifNil: [ absentBlock value ] ifNotNil: [ :existingNode | existingNode at: key level: l + HashMapNode logOfNodeSize ifPresent: presentBlock ifAbsent: absentBlock ]
]

{ #category : #accessing }
HashMapFullNode >> count [
	^ array inject: 0 into: [ :sum :n | sum + (n ifNil: [0] ifNotNil: [n count]) ]
]

{ #category : #initializing }
HashMapFullNode >> initializeWithArray: a [ 
	array := a.
]

{ #category : #initializing }
HashMapFullNode >> initializeWithExistingNode: n level: lvl hash: hash [
	self initializeWithArray: ((Array new: 32)
								at: (HashMapNode indexForHash: hash level: lvl) put: n;
								yourself).
]

{ #category : #'"modifying"' }
HashMapFullNode >> mapValues: aBlock [
	^ HashMapFullNode new initializeWithArray: (array collect: [:n | n ifNotNil: [n mapValues: aBlock]])
]

{ #category : #'"modifying"' }
HashMapFullNode >> with: k as: v level: l [
	| index |
	index := HashMapNode indexForHash: k hash level: l.
	^ HashMapFullNode new initializeWithArray: (array copyWith: index as: ((array at: index) ifNil: [k -> v] ifNotNil: [:n | n with: k as: v level: l + HashMapNode logOfNodeSize]))
]

{ #category : #'"modifying"' }
HashMapFullNode >> without: k level: l [
	| index |
	index := HashMapNode indexForHash: k hash level: l.
	^ (array at: index)
		ifNil: [ self ]
		ifNotNil: [ :n | HashMapFullNode new initializeWithArray: (array copyWith: index as: (n without: k level: l + HashMapNode logOfNodeSize)) ]
]
