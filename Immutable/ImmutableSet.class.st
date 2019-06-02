"
An immutable Set.

Dead simple, just delegates all of its operations to an immutable Map.

"
Class {
	#name : #ImmutableSet,
	#superclass : #Object,
	#instVars : [
		'map'
	],
	#category : #'Immutable-Collections'
}

{ #category : #creating }
ImmutableSet class >> containing: elements [
	^ elements inject: self empty into: [ :s :e | s with: e ]
]

{ #category : #creating }
ImmutableSet class >> empty [
	^ self new initializeWithMap: Map empty
]

{ #category : #comparing }
ImmutableSet >> = other [
	^ (other respondsTo: #isImmutableSet) and: [other isImmutableSet and: [map = other privateMap]]
]

{ #category : #'"modifying"' }
ImmutableSet >> conj: e [ 
	"Short for 'conjoin'. It's a Clojure-ism. Note that it's polymorphic. Its most common use is #into:"
	^ self with: e
]

{ #category : #iterating }
ImmutableSet >> foldable [
	^ map valuesFoldable
]

{ #category : #comparing }
ImmutableSet >> hash [
	^ 'immutable set' hash bitXor: self seq hash
]

{ #category : #accessing }
ImmutableSet >> includes: e [
	^ map includesKey: e
]

{ #category : #initializing }
ImmutableSet >> initializeWithMap: m [ 
	map := m.
]

{ #category : #accessing }
ImmutableSet >> isEmpty [
	^ self size = 0
]

{ #category : #private }
ImmutableSet >> isImmutableSet [
	^ true
]

{ #category : #printing }
ImmutableSet >> printOn: aStream [
	| sep |
	sep := nil.
	aStream nextPutAll: '#{'.
	self seq do: [ :e |
		sep ifNil: [ sep := ' ' ] ifNotNil: [ aStream nextPutAll: sep ].
		aStream print: e.
	].
	aStream nextPutAll: '}'.
]

{ #category : #private }
ImmutableSet >> privateMap [
	^ map
]

{ #category : #iterating }
ImmutableSet >> seq [
	^ map values seq
]

{ #category : #accessing }
ImmutableSet >> size [
	^ map size
]

{ #category : #'"modifying"' }
ImmutableSet >> with: e [ 
	^ ImmutableSet new initializeWithMap: (map with: e as: e)
]

{ #category : #'"modifying"' }
ImmutableSet >> without: e [ 
	^ ImmutableSet new initializeWithMap: (map without: e)
]

{ #category : #'"modifying"' }
ImmutableSet >> without: e level: l [
	^ ImmutableSet new initializeWithMap: (map without: e)
]
