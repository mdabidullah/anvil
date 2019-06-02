"
Immutable maps, like Clojure's.

Create them like this:
	Map empty
	Map from: { 1 -> 'one' . 2 -> 'two' }

There are a few subclasses, but they're semantically identical, you shouldn't need to care which kind you have. (ArrayMap is a bit faster than HashMap for small maps. Record is useful when you want to have a normal Smalltalk object with instance variables, but still be able to treat it as a Map.)

These are slower than a normal mutable Dictionary, of course, but good enough most of the time. (See performanceExperiment1.) And your life will be *so* much simpler if you use immutable things by default.

Performance-wise, these immutable HashMaps are actually much *more* space-efficient than a normal Dictionary if your application needs to hang on to old values for some reason. (See performanceExperiment2.) Because when you ""modify"" a HashMap (using the #with:as: method), the new HashMap shares most of its structure with the old HashMap. (Whereas if you wanted to hold on to an old value of a Dictionary, you'd need to copy the entire thing.)

And you'll be surprised at how often you'll come up with reasons to keep old values around, once you have data structures that make it efficient to do so. (e.g. Keeping all the old values around so your users can hit an ""undo"" button to go back to previous states. Letting your users see today's data side-by-side with yesterday's data. Giving your users a slider to browse back and forth through time. etc.)

But honestly, programming with immutable values is worth it just for the peace-of-mind you'll get from knowing that you can pass this thing to someone else and *not worry* that he'll change it out from under you.

"
Class {
	#name : #Map,
	#superclass : #Object,
	#category : #'Immutable-Collections'
}

{ #category : #creating }
Map class >> empty [
	^ ArrayMap empty
]

{ #category : #creating }
Map class >> from: associations [
	^ (associations size >= ArrayMap thresholdForSwitchingToHashMap ifTrue: [HashMap] ifFalse: [ArrayMap]) from: associations
]

{ #category : #'nested structures' }
Map class >> in: aMapOrVectorOrAnythingElseThatUnderstandsMaybeAt atPath: keyPath [
	"Don't call this directly, just call #atPath: on a Map or a Vector or whatever.
	I'm just putting this code here because it needs to be shared between all those classes and they really shouldn't have a common superclass."
	^ keyPath seq
		ifEmpty: [ Something withValue: aMapOrVectorOrAnythingElseThatUnderstandsMaybeAt ]
		ifNotEmpty: [ :k :restOfKeyPath |
			(aMapOrVectorOrAnythingElseThatUnderstandsMaybeAt maybeAt: k)
				ifPresent: [ :childData | Map in: childData atPath: restOfKeyPath ]
				ifAbsent: [ nothing ]
		]
]

{ #category : #'nested structures' }
Map class >> in: aMapOrVector withPath: keyPath as: value [
	"Don't call this directly, just call #atPath: on a Map or a Vector or whatever.
	I'm just putting this code here because it needs to be shared between all those classes and they really shouldn't have a common superclass."
	^ keyPath seq
		ifEmpty: [ value ]
		ifNotEmpty: [ :k :restOfKeyPath |
			aMapOrVector with: k as: (
				restOfKeyPath
					ifEmpty: [ value ]
					ifNotEmpty: [ Map in: ((aMapOrVector maybeAt: k) ifAbsent: [ Map empty ]) withPath: restOfKeyPath as: value ]
			)
		]
]

{ #category : #'nested structures' }
Map class >> in: aMapOrVector withPath: keyPath updatedBy: aBlock [
	"Don't call this directly, just call #atPath: on a Map or a Vector or whatever.
	I'm just putting this code here because it needs to be shared between all those classes and they really shouldn't have a common superclass."
	^ keyPath seq
		ifEmpty: [ aBlock cull: (Something withValue: aMapOrVector) ]
		ifNotEmpty: [ :k :restOfKeyPath |
			aMapOrVector with: k as: (
				restOfKeyPath
					ifEmpty: [ aBlock cull: (aMapOrVector maybeAt: k) ]
					ifNotEmpty: [ Map in: ((aMapOrVector maybeAt: k) ifAbsent: [ Map empty ]) withPath: restOfKeyPath updatedBy: aBlock ]
			)
		]
]

{ #category : #comparing }
Map >> = other [
	^ self == other or: [(other respondsTo: #isImmutableMap) and: [other isImmutableMap and: [self size = other size and: [self associationsFoldable allSatisfy: [ :a | (other at: a key) = a value ]]]]]
]

{ #category : #iterating }
Map >> associations [
	^ self associationsSeq
]

{ #category : #iterating }
Map >> associationsFoldable [
	^ SimpleFoldable new initializeForCollection: self injectMethodName: #associationsInject:into:
]

{ #category : #iterating }
Map >> associationsInject: initialValue into: aBlock [
	self subclassResponsibility.
]

{ #category : #iterating }
Map >> associationsSeq [
	self subclassResponsibility.
]

{ #category : #accessing }
Map >> at: key [
	"This is here for compatibility with normal Smalltalk collections, but I recommend that you use #maybeAt: instead."
	^ self at: key ifPresent: [ :v | v ] ifAbsent: [ self error: 'Key not found' ]
]

{ #category : #accessing }
Map >> at: key ifAbsent: absentBlock [
	"This is here for compatibility with normal Smalltalk collections, but I recommend that you use #maybeAt: instead."
	^ self at: key ifPresent: [ :v | v ] ifAbsent: absentBlock
]

{ #category : #accessing }
Map >> atPath: keyPath [
	"Assumes that the receiver is the root of a nested structure (Maps containing Maps containing Vectors containing Maps, etc.).
	Treats keyPath as a sequence of keys: the first is the key into the root, the next is the key into the child, then the key into the grandchild, etc.
	Returns a Maybe containing the value at that path."
	^ Map in: self atPath: keyPath
]

{ #category : #'"modifying"' }
Map >> conj: anAssociation [
	"Short for 'conjoin'. It's a Clojure-ism. Note that it's polymorphic. Its most common use is #into:"
	^ self withAssociation: anAssociation
]

{ #category : #iterating }
Map >> foldable [
	^ self associationsFoldable
]

{ #category : #comparing }
Map >> hash [
	^ 'immutable map' hash bitXor: (self associationsSeq collect: [ :a | a key hash bitXor: a value hash ]) hash
]

{ #category : #testing }
Map >> includesKey: k [
	^ self at: k ifPresent: [true] ifAbsent: [false]
]

{ #category : #testing }
Map >> isImmutableMap [
	^ true
]

{ #category : #iterating }
Map >> keys [
	^ self keysSeq
]

{ #category : #iterating }
Map >> keysFoldable [
	^ self associationsFoldable collect: [ :a | a key ]
]

{ #category : #iterating }
Map >> keysSeq [
	^ self associationsSeq collect: [ :a | a key ]
]

{ #category : #transforming }
Map >> mapValues: aBlock [
	"Return a map with the same keys, but with the values mapped by aBlock. The block will be passed the value and the key."
	"Subclasses can implement this more efficiently, but here's a default implementation."
	^ (self associationsFoldable collect: [:a | a key -> (aBlock cull: a value cull: a key)]) into: self class empty
]

{ #category : #accessing }
Map >> maybeAt: key [
	^ self at: key ifPresent: [ :v | Something withValue: v ] ifAbsent: nothing
]

{ #category : #transforming }
Map >> mergeWith: otherMap using: aBlockForMergingTheValues [
	^ otherMap associationsFoldable inject: self into: [ :combinedMap :a |
		combinedMap with: a key as: (self at: a key ifPresent: [ :v1 | aBlockForMergingTheValues value: v1 value: a value ] ifAbsent: [ a value ])
	]
]

{ #category : #printing }
Map >> printOn: aStream [
	aStream nextPutAll: '{'.
	((self associationsSeq collect: [ :a | a key printString, ' ', a value printString ]) interpose: ', ') do: [ :s | aStream nextPutAll: s ].
	aStream nextPutAll: '}'.

]

{ #category : #iterating }
Map >> seq [
	^ self associationsSeq
]

{ #category : #accessing }
Map >> size [
	self subclassResponsibility.
]

{ #category : #iterating }
Map >> values [
	^ self valuesSeq
]

{ #category : #iterating }
Map >> valuesFoldable [
	^ self associationsFoldable collect: [ :a | a value ]
]

{ #category : #iterating }
Map >> valuesSeq [
	^ self associationsSeq collect: [ :a | a value ]
]

{ #category : #'"modifying"' }
Map >> with: key as: value [
	self subclassResponsibility.
]

{ #category : #'"modifying"' }
Map >> withAssociation: anAssociation [
	^ self with: anAssociation key as: anAssociation value
]

{ #category : #'"modifying"' }
Map >> withPath: keyPath as: value [
	"Assumes that the receiver is the root of a nested structure (Maps containing Maps containing Vectors containing Maps, etc.).
	Treats keyPath as a sequence of keys: the first is the key into the root, the next is the key into the child, then the key into the grandchild, etc.
	Returns a new structure with that path 'modified' to have the specified value.
	Will insert maps along the way if necessary."
	^ Map in: self withPath: keyPath as: value
]

{ #category : #'"modifying"' }
Map >> withPath: keyPath updatedBy: aBlock [
	"Assumes that the receiver is the root of a nested structure (Maps containing Maps containing Vectors containing Maps, etc.).
	Treats keyPath as a sequence of keys: the first is the key into the root, the next is the key into the child, then the key into the grandchild, etc.
	Returns a new structure with that path 'modified' to have the value returned by the block (which will be passed a Maybe containing the old value at that path).
	Will insert maps along the way if necessary."
	^ Map in: self withPath: keyPath updatedBy: aBlock
]

{ #category : #'"modifying"' }
Map >> without: key [
	self subclassResponsibility.
]
