Class {
	#name : #HashMapEmptyNode,
	#superclass : #HashMapNode,
	#category : #'Immutable-Private'
}

{ #category : #iterating }
HashMapEmptyNode >> associationsInject: initialValue into: aBlock [
	^ initialValue
]

{ #category : #iterating }
HashMapEmptyNode >> associationsSeq [
	^ List empty
]

{ #category : #accessing }
HashMapEmptyNode >> at: key level: l ifPresent: presentBlock ifAbsent: absentBlock [ 
	^ absentBlock value
]

{ #category : #iterating }
HashMapEmptyNode >> count [
	^ 0
]

{ #category : #'"modifying"' }
HashMapEmptyNode >> mapValues: aBlock [
	^ self
]

{ #category : #'"modifying"' }
HashMapEmptyNode >> with: key as: value level: l [
	^ key -> value
]

{ #category : #'"modifying"' }
HashMapEmptyNode >> without: key level: l [
	^ self
]
