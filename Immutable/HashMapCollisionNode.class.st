Class {
	#name : #HashMapCollisionNode,
	#superclass : #HashMapNode,
	#instVars : [
		'hash',
		'associations'
	],
	#category : #'Immutable-Private'
}

{ #category : #iterating }
HashMapCollisionNode >> associationsInject: initialValue into: aBlock [
	^ associations inject: initialValue into: aBlock
]

{ #category : #iterating }
HashMapCollisionNode >> associationsSeq [
	^ associations seq
]

{ #category : #accessing }
HashMapCollisionNode >> at: k level: l ifPresent: presentBlock ifAbsent: absentBlock [
	^ associations detect: [ :a | a key = k ] ifFound: [ :a | a value ] ifNone: absentBlock
]

{ #category : #accessing }
HashMapCollisionNode >> count [
	^ associations size
]

{ #category : #initializing }
HashMapCollisionNode >> initializeWithAssociations: as [
	associations := as.
	hash := as first key hash.
]

{ #category : #'"modifying"' }
HashMapCollisionNode >> mapValues: aBlock [
	^ HashMapCollisionNode new initializeWithAssociations: (associations collect: [:a | a key -> (aBlock cull: a value cull: a key) ])
]

{ #category : #'"modifying"' }
HashMapCollisionNode >> with: k as: v level: l [
	^ hash = k hash ifTrue: [| index |
		index := associations indexSatisfying: [ :a | a key = k ].
		HashMapCollisionNode new initializeWithAssociations: (index = 0 ifTrue: [associations copyAndAppend: k -> v] ifFalse: [associations copyWith: index as: k -> v])
	] ifFalse: [
		(HashMapBitmapIndexedNode new initializeWithExistingNode: self level: l hash: hash) with: k as: v level: l
	]
]

{ #category : #'"modifying"' }
HashMapCollisionNode >> without: k level: l [
	^ hash = k hash ifTrue: [| index |
		index := associations indexSatisfying: [ :a | a key = k ].
		index = 0 ifTrue: [
			self
		] ifFalse: [
			HashMapCollisionNode new initializeWithAssociations: (associations copyWithoutIndex: index)
		]
	] ifFalse: [
		self
	]
]
