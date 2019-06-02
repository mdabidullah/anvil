"
Keeps two linked lists, each containing some of the elements of the queue: frontList (in forward order) and backList (in reverse order). So a queue looks like this:

	F1 F2 F3 F4 B7 B6 B5 B4 B3 B2 B1

That way, taking from the front and adding to the back are both O(1).

Of course this means that every so often (when the frontList becomes empty), we need to transfer all the items from the backList over to the frontList. Which is an O(n) cost, but it only has to happen once every O(n) calls.
"
Class {
	#name : #ImmutableQueue,
	#superclass : #Object,
	#instVars : [
		'frontList',
		'backList'
	],
	#category : #'Immutable-Collections'
}

{ #category : #creating }
ImmutableQueue class >> containing: aCollection [
	^ self basicNew initializeWithFrontList: (List containingReversed: aCollection) backList: List new
]

{ #category : #creating }
ImmutableQueue class >> empty [
	^ self basicNew initializeWithFrontList: List new backList: List new
]

{ #category : #comparing }
ImmutableQueue >> = other [
	^ self seq = other seq
]

{ #category : #'"modifying"' }
ImmutableQueue >> conj: e [
	"Short for 'conjoin'. It's a Clojure-ism. Note that it's polymorphic. Its most common use is #into:"
	^ self withLast: e
]

{ #category : #comparing }
ImmutableQueue >> hash [
	^ self seq hash
]

{ #category : #initializing }
ImmutableQueue >> initializeWithFrontList: f backList: b [
	f isEmpty ifTrue: [
		"Maintain the invariant that the front list is only empty if the whole queue is empty."
		frontList := b reversed.
		backList := List empty.
	] ifFalse: [
		frontList := f.
		backList := b.
	].
]

{ #category : #testing }
ImmutableQueue >> isEmpty [
	^ frontList isEmpty
]

{ #category : #accessing }
ImmutableQueue >> maybeFirst [
	^ frontList maybeFirst
]

{ #category : #printing }
ImmutableQueue >> printOn: aStream [
	self seq printOn: aStream.
]

{ #category : #iterating }
ImmutableQueue >> seq [
	^ frontList seq, backList reversed seq
]

{ #category : #accessing }
ImmutableQueue >> size [
	^ frontList size + backList size
]

{ #category : #accessing }
ImmutableQueue >> unsafeFirst [
	^ frontList unsafeFirst
]

{ #category : #'"modifying"' }
ImmutableQueue >> withFirst: e [
	^ ImmutableQueue basicNew initializeWithFrontList: (frontList cons: e) backList: backList
]

{ #category : #'"modifying"' }
ImmutableQueue >> withLast: e [
	^ ImmutableQueue basicNew initializeWithFrontList: frontList backList: (backList cons: e)
]

{ #category : #'"modifying"' }
ImmutableQueue >> withoutFirst [
	^ ImmutableQueue basicNew initializeWithFrontList: frontList unsafeRest backList: backList
]

{ #category : #'"modifying"' }
ImmutableQueue >> withoutLast [
	^ ImmutableQueue basicNew initializeWithFrontList: frontList backList: backList unsafeRest
]
