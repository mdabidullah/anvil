"
A Foldable is a collection that understands #inject:into:. (That is, any collection. Having an #inject:into: method is basically what it *means* to be a collection - you can build #collect: and #select: and all the other collection methods on top of that. It's a much better ""base"" than #do:, because it doesn't rely on side effects.)

You can get a Foldable on any ordinary Smalltalk Collection by calling #foldable on it.

Calling #collect: or #select: or #flatCollect: on a Foldable doesn't actually cause any iteration to happen immediately; it just gives you another Foldable that knows how to do it. So you can say things like: 

  ((1 to: 1000) foldable select: #even) collect: [ :n | n * n ]

and no intermediate collections will be created. In fact, no iteration will happen at all yet. (But if you hit Cmd-p on the above line, of course iteration will happen once, as the printOn: method iterates through the collection in order to print the elements.)

Unlike Seq, though, the results won't be cached the first time through. Each time you iterate through it has to do the work all over again. Also, Foldable doesn't support #first and #rest (so it doesn't support #= either, because there's no way to walk through two Foldables at the same time and compare each pair of elements). So use a Seq instead, when you need something more like that.

----

There's also a #fold: method, which has a default implementation that uses #inject:into:, but subclasses are allowed to override to provide a parallel implementation.

The difference between #inject:into: and #fold: is that #inject:into: guarantees that the elements will be folded sequentially. (Specifically, in a left-associative way. Basically, #inject:into: is what Haskell people call a ""left fold"".) Whereas #fold: explicitly does *not* guarantee sequential folding - #fold: is allowed to bracket the elements any way it wants to, and allowed to . That's why #fold: takes a Monoid (i.e. an associative operation) as an argument.

For example, when you do
	{ 1. 2. 3. 4. 5 } inject: 0 into: [ :sum :each | sum + each ]
Smalltalk will end up doing the computation
	((((0 + 1) + 2) + 3) + 4) + 5
Whereas when you do
	{ 1. 2. 3. 4. 5 } fold: Monoid addition
The bracketing will probably end up being more like
	((0 + 1) + 2) + (((0 + 3) + 4) + 5)

"
Class {
	#name : #Foldable,
	#superclass : #Monad,
	#category : #'Immutable-Collections'
}

{ #category : #enumerating }
Foldable >> allSatisfy: aBlock [
	^  self detect: [:e | (aBlock value: e) not] ifFound: [false] ifNone: [true]
]

{ #category : #enumerating }
Foldable >> anySatisfy: aBlock [
	^  self detect: aBlock ifFound: [true] ifNone: [false]
]

{ #category : #converting }
Foldable >> asArray [
	^ self asOrderedCollection asArray
]

{ #category : #converting }
Foldable >> asOrderedCollection [
	^ OrderedCollection new addAll: self; yourself
]

{ #category : #enumerating }
Foldable >> collect: aBlock [
	"Note that this doesn't actually do any iteration right away, it just returns a new Reducible that knows how to do it."
	^ TransducingFoldable new initializeForReducible: self transducer: (Transducer mapping: aBlock)
]

{ #category : #enumerating }
Foldable >> concat [
	"Note that this doesn't actually do any iteration right away, it just returns a new Reducible that knows how to do it."
	^ TransducingFoldable new initializeForReducible: self transducer: Transducer concatenating
]

{ #category : #destructuring }
Foldable >> destructure: aBlock [
	"Ugh. This is ugly. I *really* wish Smalltalk had a destructuring syntax. But I think this is still better than nothing."
	^ aBlock valueWithArguments: self asArray
]

{ #category : #enumerating }
Foldable >> detect: aBlock [
	"This is here for compatibility with normal Smalltalk collections, but I recommend just using #find: or even #select: directly."
	^ self detect: aBlock ifFound: [:e | e] ifNone: [self error: 'not found']
]

{ #category : #enumerating }
Foldable >> detect: aBlock ifFound: foundBlock ifNone: noneBlock [
	"This is here for compatibility with normal Smalltalk collections, but I recommend just using #find: or even #select: directly."
	^ (self find: aBlock) ifPresent: foundBlock ifAbsent: noneBlock
]

{ #category : #enumerating }
Foldable >> detect: aBlock ifNone: noneBlock [
	"This is here for compatibility with normal Smalltalk collections, but I recommend just using #find: or even #select: directly."
	^ self detect: aBlock ifFound: [:e | e] ifNone: noneBlock
]

{ #category : #enumerating }
Foldable >> do: aBlock [
	"Providing do: since Smalltalk uses it a lot, but you should really be trying to use non-side-effecty methods like #inject:into: whenever you can."
	self inject: nil into: [ :ignore :each | aBlock value: each ].
]

{ #category : #enumerating }
Foldable >> find: aBlock [
	"Returns a Maybe for the first element of the sequence satisfying the block.
	I hate to use a nonlocal-return, but whatever, Smalltalk has them, might as well make use of it."
	self do: [ :each | (aBlock value: each) ifTrue: [ ^ Something withValue: each ] ].
	^ nothing
]

{ #category : #enumerating }
Foldable >> flatCollect: aBlock [
	"Note that this doesn't actually do any iteration right away, it just returns a new Reducible that knows how to do it."
	^ (self collect: aBlock) concat
]

{ #category : #enumerating }
Foldable >> flatMap: aBlock [
	"For compatibility with Maybe and IO. The word 'collect' doesn't really make sense for those."
	^ self flatCollect: aBlock
]

{ #category : #enumerating }
Foldable >> fold: aMonoid [
	"This may be overridden by subclasses to provide a parallel implementation, but using the sequential #inject:into: is a useful default."
	^ self inject: aMonoid identityElement into: aMonoid combiningBlock
]

{ #category : #enumerating }
Foldable >> foldable [
	^ self
]

{ #category : #'side effects' }
Foldable >> forceRealization [
	self do: [ :ignore | nil ].
]

{ #category : #converting }
Foldable >> groupBy: keyBlock [
	^ self inject: Map empty into: [ :elementsByKey :element |
		elementsByKey with: (keyBlock value: element) modifiedBy: [ :elementsForThisKey |
			(elementsForThisKey ifNil: [Vector empty]) withLast: element
		]
	]
]

{ #category : #testing }
Foldable >> includes: v [ 
	^ self anySatisfy: [:e | e = v]
]

{ #category : #converting }
Foldable >> into: initialCollection [
	"Very useful for converting sequences into Vectors or HashMaps or whatever. Note that (of course) it doesn't *modify* the initial collection, it just keeps 'conj'ing onto it. And since different kinds of collections implement #conj: differently, you'll get different results: with a List you'll get the elements in reverse order, with a Vector in forward order, with a Map the elements need to be Associations, etc."
	^ self inject: initialCollection into: [ :soFar :e | soFar conj: e ]
]

{ #category : #enumerating }
Foldable >> map: aBlock [
	"For compatibility with Maybe and IO. The word 'collect' doesn't really make sense for those."
	^ self collect: aBlock
]

{ #category : #enumerating }
Foldable >> noneSatisfy: aBlock [
	^  self detect: aBlock ifFound: [false] ifNone: [true]
]

{ #category : #printing }
Foldable >> printOn: aStream [
	| sep |
	sep := nil.
	aStream nextPutAll: '( '.
	self do: [ :e |
		sep ifNil: [ sep := ' ' ] ifNotNil: [ aStream nextPutAll: sep ].
		aStream print: e.
	].
	aStream nextPutAll: ')'.

]

{ #category : #enumerating }
Foldable >> reject: aBlock [
	"Note that this is lazy: it returns a new seq, but doesn't actually do any iteration yet."
	^self select: [ :e | (aBlock value: e) == false ]
]

{ #category : #converting }
Foldable >> reversed [
	^ List containingReversed: self
]

{ #category : #enumerating }
Foldable >> select: aBlock [
	"Note that this doesn't actually do any iteration right away, it just returns a new Reducible that knows how to do it."
	^ TransducingFoldable new initializeForReducible: self transducer: (Transducer filtering: aBlock)
]

{ #category : #enumerating }
Foldable >> size [
	^ self inject: 0 into: [ :count :each | count + 1 ]
]
