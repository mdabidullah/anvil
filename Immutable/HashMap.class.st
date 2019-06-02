"
An immutable hash table, implemented as a tree of 32-element arrays. Imagine splitting the key's hash (which is just a number) into 5-bit chunks. The first five bits are used as the index into the root node's array, the next five bits are used as the index into the root's children's arrays, etc.

"
Class {
	#name : #HashMap,
	#superclass : #Map,
	#instVars : [
		'node'
	],
	#classInstVars : [
		'cachedEmptyOne'
	],
	#category : #'Immutable-Collections'
}

{ #category : #creating }
HashMap class >> empty [
	^ cachedEmptyOne
]

{ #category : #creating }
HashMap class >> from: associations [
	^ associations foldable into: self empty
]

{ #category : #creating }
HashMap class >> initialize [
	cachedEmptyOne := self new initializeWithNode: HashMapEmptyNode new.
]

{ #category : #performance }
HashMap class >> performanceExperiment1 [
	"On my machine, this gives me results like:   'Dictionary took 0:00:00:02.37, HashMap took 0:00:00:04.345'

	HashMap performanceExperiment1
	"
	| N immutableTime mutableTime |
	N := 1000000.

	mutableTime := [| d | 
		d := Dictionary new.
		(1 to: N) do: [ :n | d at: n put: n * n ].
		(1 to: N) do: [ :n | [(d at: n) = (n * n)] assert ].
	] timeToRun.
	
	immutableTime := [| d |
		d := (1 to: N) inject: HashMap empty into: [ :h :n | h with: n as: n * n ].
		(1 to: N) do: [ :n | [(d at: n) = (n * n)] assert ].
	] timeToRun.

	^ 'Dictionary took ', mutableTime printString, ', HashMap took ', immutableTime printString
]

{ #category : #performance }
HashMap class >> performanceExperiment2 [
	"On my machine, this gives me results like:  'Dictionary took 0:00:00:00.125 to do 1000, HashMap took 0:00:00:00.505 to do 100000'
	
	(I can't even *do* more than 1000 with regular Dictionary - when I try to bump N1 up to 10000, Pharo crashes.)
	
	HashMap performanceExperiment2
	"
	| N1 N2 immutableTime mutableTime |
	N1 := 1000. "I don't understand why, but when I bump this up to 10000, Pharo crashes."
	N2 := 100000.
	
	mutableTime := [| c |
		c := { Dictionary new } asOrderedCollection.
		(1 to: N1) do: [ :n | c add: (c last copy at: n put: n * n; yourself) ].
		c
	] timeToRun.

	immutableTime := [| ds |
		ds := (1 to: N2) inject: (Vector containing: {HashMap empty}) into: [ :v :n | v withLast: (v last with: n as: n * n) ].
	] timeToRun.

	^ 'Dictionary took ', mutableTime printString, ' to do ', N1 printString, ', HashMap took ', immutableTime printString, ' to do ', N2 printString
]

{ #category : #performance }
HashMap class >> performanceExperiment3 [
	"On my machine, this gives me results like:  'Dictionary took 0:00:00:00.016, HashMap took 0:00:00:02.364 to iterate through #associationsSeq, 0:00:00:00.065 using #associationsReducible'
	
	HashMap performanceExperiment3
	"
	| N d1 d2 mutableTime immutableTimeUsingSeq immutableTimeUsingReducible |
	N := 1000000.

	d1 := Dictionary new.
	(1 to: N) do: [ :n | d1 at: n put: n * n ].

	d2 := (1 to: N) inject: HashMap empty into: [ :h :n | h with: n as: n * n ].
	
	mutableTime					:= [ d1 associationsDo:				[ :a | nil ] ] timeToRun.
	immutableTimeUsingSeq		:= [ d2 associationsSeq do:		[ :a | nil ] ] timeToRun.
	immutableTimeUsingReducible	:= [ d2 associationsFoldable do:	[ :a | nil ] ] timeToRun.
	

	^ 'Dictionary took ', mutableTime printString, ', HashMap took ', immutableTimeUsingSeq printString, ' to iterate through #associationsSeq, ', immutableTimeUsingReducible printString, ' using #associationsReducible'
]

{ #category : #performance }
HashMap class >> performanceExperiment4 [
	"On my machine, this gives me results like:  'Copying a 1-element array took 0:00:00:00.283, copying a 32-element array took 0:00:00:00.509'
	
	
	
	HashMap performanceExperiment4
	"
	| a1 a32 time1 time32 |
	a1 := (1 to: 1) asArray.
	a32 := (1 to: 32) asArray.
	time1 := [ 10000000 timesRepeat: [ a1 shallowCopy ] ] timeToRun.
	time32 := [ 10000000 timesRepeat: [ a32 shallowCopy ] ] timeToRun.
	
	^ 'Copying a 1-element array took ', time1 printString, ', copying a 32-element array took ', time32 printString

]

{ #category : #iterating }
HashMap >> associationsInject: initialValue into: aBlock [
	^ node associationsInject: initialValue into: aBlock
]

{ #category : #iterating }
HashMap >> associationsSeq [
	^ node associationsSeq
]

{ #category : #accessing }
HashMap >> at: key ifPresent: presentBlock ifAbsent: absentBlock [
	"This is here for compatibility with normal Smalltalk collections, but I recommend that you use #maybeAt: instead."
	^ node at: key level: 0 ifPresent: presentBlock ifAbsent: absentBlock
]

{ #category : #initializing }
HashMap >> initializeWithNode: n [
	node := n.
]

{ #category : #transforming }
HashMap >> mapValues: aBlock [
	^ HashMap new initializeWithNode: (node mapValues: aBlock)
]

{ #category : #accessing }
HashMap >> size [
	^ node count
]

{ #category : #'"modifying"' }
HashMap >> with: key as: value [
	^ HashMap new initializeWithNode: (node with: key as: value level: 0)
]

{ #category : #'"modifying"' }
HashMap >> without: key [
	^ HashMap new initializeWithNode: (node without: key level: 0)
]
