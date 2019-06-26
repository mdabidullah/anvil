Extension { #name : #Association }

{ #category : #'*Immutable-Collections' }
Association >> associationsInject: initialValue into: aBlock [
	^ aBlock value: initialValue value: self
]

{ #category : #'*Immutable-Collections' }
Association >> associationsSeq [
	^ { self } seq
]

{ #category : #'*Immutable-Collections' }
Association >> at: k level: l ifPresent: presentBlock ifAbsent: absentBlock [ 
	^ key = k ifTrue: [ presentBlock cull: value ] ifFalse: absentBlock
]

{ #category : #'*Immutable-Collections' }
Association >> count [
	^ 1
]

{ #category : #'*Immutable-Collections' }
Association >> mapValues: aBlock [
	^ key -> (aBlock cull: value cull: key)
]

{ #category : #'*Immutable-Collections' }
Association >> with: k as: v level: l [
	| myHash |
	key = k ifTrue: [ ^ key -> v ].
	myHash := key hash.
	myHash = k hash ifTrue: [ ^ HashMapCollisionNode new initializeWithAssociations: { key -> value. k -> v } ].
	^ (HashMapBitmapIndexedNode new initializeWithExistingNode: self level: l hash: myHash) with: k as: v level: l
]

{ #category : #'*Immutable-Collections' }
Association >> without: k level: l [
	^ key = k ifTrue: [HashMapEmptyNode new] ifFalse: [self]
]
