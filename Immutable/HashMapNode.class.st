"
These nodes are used to implement HashMap.

All of them are immutable, of course.

There are various different kinds of node:
  - An Empty node holds nothing at all.
  - A Leaf node is actually a normal Association object; there's no HashMapLeafNode subclass. It just holds one key/value pair.
  - A Collision node holds a bunch of pairs that all have the same hash value.
  - A Full node holds a 32-element array. When looking for the child element for a particular hash number, it uses 5 bits of the hash as the index into the array. (That's why all the operations are passed a ""level"" number - for level 0 we use the first 5 bits of the hash, for level 5 we use the next 5 bits, etc.)
  - A BitmapIndexed node is a space-saving optimization for sparse nodes. It doesn't store an entire 32-word array (which would waste space because it's mostly empty); instead it keeps an array containing only the child nodes that actually exist, and also keeps a 32-bit integer where each bit represents whether we have an entry for that index.
"
Class {
	#name : #HashMapNode,
	#superclass : #Object,
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
HashMapNode class >> indexForHash: hash level: level [
	^ ((hash >> level) bitAnd: HashMapNode nodeSize - 1) + 1 "+1 because Smalltalk indices start at 1"
]

{ #category : #'as yet unclassified' }
HashMapNode class >> logOfNodeSize [
	^ 5
]

{ #category : #'as yet unclassified' }
HashMapNode class >> nodeSize [
	^ 32
]

{ #category : #'as yet unclassified' }
HashMapNode class >> shouldUseBitmapIndexedNodes [
	^ true
]

{ #category : #iterating }
HashMapNode >> associationsInject: initialValue into: aBlock [
	self subclassResponsibility.
]

{ #category : #iterating }
HashMapNode >> associationsSeq [
	self subclassResponsibility.
]

{ #category : #accessing }
HashMapNode >> at: key level: l ifPresent: presentBlock ifAbsent: absentBlock [
	self subclassResponsibility.
]

{ #category : #iterating }
HashMapNode >> count [
	self subclassResponsibility.
]

{ #category : #'"modifying"' }
HashMapNode >> mapValues: aBlock [
	self subclassResponsibility.
]

{ #category : #'"modifying"' }
HashMapNode >> with: k as: v level: l [
	self subclassResponsibility.
]

{ #category : #'"modifying"' }
HashMapNode >> without: k level: l [
	self subclassResponsibility.
]
