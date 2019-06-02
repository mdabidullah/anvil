"
A Seq (short for ""sequence"") is an immutable sequential collection.

You may have noticed that Vector and HashMap and HashSet don't inherit from Collection and don't have any iteration methods. That's because the recommended way to use them is to ask them for a #seq. (When you're working with immutable things, you stop caring so much about whether you're using ""the original"" or not.)

Seqs understand lots of the usual Smalltalk collection operations - #collect:, #select:, #inject:into:, etc. (Also #do:, but since that's always executed for its side effects, I recommend only using it in the parts of your code that need to do mutation - try to stick to non-mutaty operations wherever possible.)

Seqs are immutable, so it's always safe to hang on to old seqs (e.g. if you want to compare a new value with an old value), to use seqs as keys in a HashMap, etc.

Note that most Seq operations (like #collect: and #select:) are *lazy*. They're intended to be used with immutable values. You can call #forceRealization if you want to make sure that every element is actually calculated (because their creation will involve side effects that you want), but... seriously, just try to avoid side effects. You'll be happier for it, I promise.

Because Seqs are lazy, it's possible to have infinite sequences:
	Random new seq take: 5
	{ 1. 2. 3. 4. 5 } seq cycle take: 17

Also it's safe to call methods like #collect: and #select: on very large or infinite sequences (as long as you don't *actually* iterate all the way through the giant sequence):
	(((1 to: 100000000) seq collect: [ :n | n * n ]) select: [ :square | square > 200 ]) first
	(Random new seq select: [ :n | n > 0.7 ]) take: 5
	Random new seq detect: [ :n | n < 0.001 ]

For compatibility with normal Smalltalk code, you can call #seq on any SequenceableCollection (like OrderedCollection or Array or Interval or whatever). Of course, Smalltalk collections are mutable, but when you first iterate through a Seq it'll cache its elements, so a particular Seq will never change.

Fundamentally, a seq is a thing that understands #first and #rest. (#rest will be nil if this seq is empty, otherwise it'll point to another seq.) You probably won't need to do this very often (because the standard already-implemented operations are usually all you need), but to make your own new kind of seq, you can subclass Seq and implement #calculateFirstAndRest (which will be called lazily; it's expected to set the cachedFirst and cachedRest instance variables). Or you can call SeqWithBlocks first: [] rest: [], which will be a bit less efficient than making a subclass (see performanceExperiment2), but it's convenient.

Since there's a separate Seq object for each element of the collection, iterating through a seq will be slower than iterating through a simple Array. (See performanceExperiment1.) I haven't put any time into optimizing this library, though - there are probably some clever tricks that can be done to speed things up.

Note that Seq does *not* inherit from the standard Smalltalk Collection class. That's because the semantics are subtly different in a couple of ways. First, various operations are lazy (as mentioned above). Second, we don't go through any of the hoops that Smalltalk collections go through to try to return collections of the same ""type"" as the receiver. Instead, you can just explicitly convert between types using the #into: method:
	
	({ 1. 2. 3. 4. 5 } seq collect: [ :n |       n * n    ]) into: Vector empty
	({ 1. 2. 3. 4. 5 } seq collect: [ :n |       n * n    ]) into: HashSet empty
	({ 1. 2. 3. 4. 5 } seq collect: [ :n | { n. n * n } ]) into: HashMap empty

"
Class {
	#name : #Seq,
	#superclass : #Foldable,
	#instVars : [
		'cachedFirst',
		'cachedRest',
		'hasCalculatedFirstAndRest'
	],
	#category : #'Immutable-Collections'
}

{ #category : #performance }
Seq class >> for: aSeq collectWithBlocks: aBlock [
	"Don't use this, it's just a performance experiment."
	^ SeqWithABlock block: [ :firstAndRestBlock |
		aSeq rest
			ifNil: [firstAndRestBlock value: nil value: nil]
			ifNotNil: [:r | firstAndRestBlock value: aSeq first value: (Seq for: r collectWithBlocks: aBlock) ] ]
]

{ #category : #performance }
Seq class >> performanceExperiment1 [
	"On my machine, this gives me results like:
		'For 100000 elements, OrderedCollection took 0:00:00:00.001, Seq took 0:00:00:00.012, and the second time using the Seq took 0:00:00:00.002'
		'For 1000000 elements, OrderedCollection took 0:00:00:00.012, Seq took 0:00:00:00.248, and the second time using the Seq took 0:00:00:00.025'
		
	So iteration is 10-20 times slower the *first* time you go through the Seq (because it has to create each link). The second time you go through the same Seq, it's only 2 times slower.
	
	(But remember that this is *just* the overhead of iteration, and even the first time it's less than a microsecond per element. If you're doing any significant work on each element, that's going to dwarf the iteration overhead.)
	
	Still, better to use a Reducible if you know you're going to be going through an entire collection. Seq is best reserved for situations where you want laziness.

	Seq performanceExperiment1
	"
	| N c cSeq mutableTime immutableTime immutableTime2 |
	N := 1000000.
	
	c := OrderedCollection new.
	(1 to: N) do: [ :n | c add: n * n ].
	
	cSeq := c seq.

	mutableTime		:= [ c       inject: 0 into: [ :total :unused | total ] ] timeToRun.
	immutableTime		:= [ cSeq inject: 0 into: [ :total :unused | total ] ] timeToRun.
	immutableTime2	:= [ cSeq inject: 0 into: [ :total :unused | total ] ] timeToRun.

	^ 'For ', N printString, ' elements, OrderedCollection took ', mutableTime printString, ', Seq took ', immutableTime printString, ', and the second time using the Seq took ', immutableTime2 printString
]

{ #category : #performance }
Seq class >> performanceExperiment2 [
	"On my machine I get results like: 'For 1000000 elements, Seq took 0:00:00:01.301, SeqWithABlock took 0:00:00:00.837'.
	
	I have no idea why SeqWithABlock is faster than the dedicated subclass. Weird.

	Seq performanceExperiment2
	"
	| N c seqTime seqWithBlocksTime |
	N := 1000000.
	
	c := OrderedCollection new.
	(1 to: N) do: [ :n | c add: n * n ].

	seqTime := [
		(c seq collect: [ :n | n * n ]) forceRealization.
	] timeToRun.

	seqWithBlocksTime := [ 
		(Seq for: c seq collectWithBlocks: [ :n | n * n ]) forceRealization.
	] timeToRun.

	^ 'For ', N printString, ' elements, Seq took ', seqTime printString, ', SeqWithABlock took ', seqWithBlocksTime printString
]

{ #category : #performance }
Seq class >> performanceExperiment3 [
	"On my machine, running the first line makes the memory usage go way up on my Mac's Activity Monitor, and eventually either crashes or hangs Pharo. Whereas running the second line works fine and doesn't make the memory usage go up significantly and returns with the answer after a few seconds."

	"This one has the seq as the receiver, meaning it'll be held onto by the method activation, so the whole sequence has to stay non-garbage until the method returns."
	(1 to: 100000000) seq inject: 0 into: [ :max :n | max max: n ].

	"This one doesn't hold on to the seq head, so they can be garbage-collected as we go."
	(1 to: 100000000) seq destructivelyInject: 0 into: [ :max :n | max max: n ].

]

{ #category : #transforming }
Seq >> , other [
	^ self ifEmpty: [other] ifNotEmpty: [ :first :rest | rest, other cons: first]
]

{ #category : #comparing }
Seq >> = other [
	self == other ifTrue: [ ^ true ].
	(other isKindOf: Seq) ifTrue: [
		self isEmpty ifTrue: [ ^ other isEmpty ].
		other isEmpty ifTrue: [ ^ false ].
		^ self unsafeFirst = other unsafeFirst and: [self unsafeRest = other unsafeRest]
	] ifFalse: [
		^ false
	]
]

{ #category : #enumerating }
Seq >> collect: aBlock [
	"Note that this is lazy: it returns a new seq, but doesn't actually do any iteration yet."
	^ MappingSeq new initializeWithOriginalSeq: self mappingBlock: aBlock
]

{ #category : #transforming }
Seq >> concat [
	"Assumes that this is a sequence of collections. Returns a (lazy, naturally) seq containing the elements of those collections."
	^ ConcatenatingSeq new initializeWithSeqs: self
]

{ #category : #'"modifying"' }
Seq >> conj: element [
	"Short for 'conjoin'. It's a Clojure-ism. Note that it's polymorphic. Its most common use is #into:"
	^ self cons: element
]

{ #category : #'"modifying"' }
Seq >> cons: e [
	"For people who speak with a lisp."
	^ self withFirst: e
]

{ #category : #transforming }
Seq >> cycle [
	"Returns an infinite sequence containing my elements repeated over and over."
	^ CyclingSeq new initializeWithCurrentSeq: self startingSeq: self
]

{ #category : #enumerating }
Seq >> destroyLinks [
	"DO NOT CALL THIS."
	cachedFirst := #destroyed.
	cachedRest := #destroyed.
]

{ #category : #enumerating }
Seq >> destructivelyInject: initialValue into: aBlock [
	"DO NOT CALL THIS UNLESS YOU KNOW WHAT YOU'RE DOING.
	This is the exception to the 'Seqs are immutable' rule. It's only here because sometimes you need to do a reduction (just like #inject:into: does) on a gigantic Seq without using O(n) space.

That is, if you have a gigantic seq and you want to do some big reduction on it, you might expect to be able to write something like this (DO NOT evaluate the next line, on my machine is makes Pharo balloon up to take several hundred MB memory and either freeze or crash):

	(1 to: 100000000) seq inject: 0 into: [ :r :each | r max: each ]

The problem is that the gigantic Seq is the receiver of the #inject:into: method, so it's referenced from the method activation, so the garbage collector can't reclaim it until the method is finished running. So you end up actually having every single one of those individual seqs in memory at the same time.

So instead, you can write this:

	(1 to: 100000000) seq destructivelyInject: 0 into: [ :r :each | r max: each ]

The reason this runs in constant space is because it DESTROYS THE STRUCTURE AS IT GOES. Which is bad. It breaks the whole notion that seqs are immutable. But it does allow the garbage collector to reclaim the already-used links, so it can be useful sometimes.

Please don't use this method with small sequences - just call #inject:into:. But for huge ones, it's good to have this handy.
	"

	| v s |
	v := initialValue.
	s := self.
	[s isEmpty] whileFalse: [| r |
		v := aBlock value: v value: s unsafeFirst.
		r := s unsafeRest.
		s destroyLinks.
		s := r.
	].
	^ v
]

{ #category : #'private-caching' }
Seq >> ensureCalculated [
	hasCalculatedFirstAndRest ifNil: [
		self calculateFirstAndRest.
		hasCalculatedFirstAndRest := true.
	].
]

{ #category : #enumerating }
Seq >> find: aBlock [
	"Returns a Maybe for the first element of the sequence satisfying the block.
	Honestly, I'd just call #select: and then #maybeFirst directly.
	Note that these are lazy seqs, so you don't need to worry about #select wasting time going over the whole thing."
	^ (self select: aBlock) maybeFirst
]

{ #category : #accessing }
Seq >> first [
	"I'm including this method against my better judgment, because when demoing I don't want to have to explain about Maybes."
	^ self unsafeFirst
]

{ #category : #enumerating }
Seq >> firstSeqSatisfying: aBlock [
	| s |
	s := self.
	[s isEmpty] whileFalse: [
		(aBlock value: s unsafeFirst) ifTrue: [ ^ s ].
		s := s unsafeRest.
	].
	^ nil
]

{ #category : #enumerating }
Seq >> foldable [
	^ SimpleFoldable new initializeForCollection: self injectMethodName: #inject:into:
]

{ #category : #comparing }
Seq >> hash [
	^ (self take: 10) inject: 0 into: [ :h :each | h bitXor: each hash ]
]

{ #category : #testing }
Seq >> ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock [
	"Blecch, this has slightly different semantics from the one on Collection. But I really want an easy, safe way to get the first and rest."
	^ self isEmpty ifTrue: [ emptyBlock value ] ifFalse: [ notEmptyBlock cull: self unsafeFirst cull: self unsafeRest ]
]

{ #category : #testing }
Seq >> ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock [
	"Blecch, this has slightly different semantics from the one on Collection. But I really want an easy, safe way to get the first and rest."
	^ self isEmpty ifTrue: [ emptyBlock value ] ifFalse: [ notEmptyBlock cull: self unsafeFirst cull: self unsafeRest ]
]

{ #category : #enumerating }
Seq >> inject: initialValue into: aBlock [
	| v s |
	v := initialValue.
	s := self.
	[s isEmpty] whileFalse: [
		v := aBlock value: v value: s unsafeFirst.
		s := s unsafeRest.
	].
	^ v
]

{ #category : #transforming }
Seq >> interpose: separatorBlockOrValue [
	"Returns a seq with the separator in between each of my elements."
	^ self isEmpty
		ifTrue: [List empty]
		ifFalse: [(self unsafeRest flatCollect: [ :e | { separatorBlockOrValue value. e } seq ]) cons: self unsafeFirst]
]

{ #category : #testing }
Seq >> isEmpty [
	^ self unsafeRest isNil
]

{ #category : #accessing }
Seq >> maybeFirst [
	^ self isEmpty
		ifTrue: [nothing]
		ifFalse: [Something withValue: self unsafeFirst]
]

{ #category : #accessing }
Seq >> maybeRest [
	^ self isEmpty
		ifTrue: [nothing]
		ifFalse: [Something withValue: self unsafeRest]
]

{ #category : #accessing }
Seq >> rest [
	"I'm including this method against my better judgment, because when demoing I don't want to have to explain about Maybes."
	^ self unsafeRest
]

{ #category : #enumerating }
Seq >> select: aBlock [
	"Note that this is lazy: it returns a new seq, but doesn't actually do any iteration yet."
	^ FilteringSeq new initializeWithOriginalSeq: self filteringBlock: aBlock
]

{ #category : #enumerating }
Seq >> seq [
	^ self
]

{ #category : #transforming }
Seq >> take: numberOfElementsToTake [
	"Returns a lazy seq containing that number of elements (or the entire seq, if the number is bigger than my entire size). Very useful in combination with infinite seqs (see #cycle and #repeatedly)."
	^ TakingSeq new initializeWithOriginalSeq: self number: numberOfElementsToTake
]

{ #category : #accessing }
Seq >> unsafeFirst [
	"You might prefer to call #maybeFirst instead. It's safer. If you call #unsafeFirst directly, you'd better check #isEmpty beforehand."

	self ensureCalculated.
	^ cachedFirst
]

{ #category : #accessing }
Seq >> unsafeRest [
	self ensureCalculated.
	^ cachedRest
]

{ #category : #'"modifying"' }
Seq >> withFirst: e [
	^ List createWithFirst: e rest: self
]
