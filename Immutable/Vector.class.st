"
An immutable Array-like thing, similar to Clojure's.

The main thing is a tree of arrays. The idea is that to ""modify"" (i.e. return a slightly-different copy of) this vector, we don't need to copy the entire tree, we only need to copy the nodes on the path from the root down to the changed node; the new vector can share all the rest of its structure with the old vector.

Each node can hold up to 32 elements, so the trees are pretty shallow. The basic get/""set"" operations are O(log(n)), which of course isn't quite as fast as O(1) for a mutable array, but it's fine for most purposes.

Also, for efficient appending, there's a ""tail"" array. So pushing or popping at the end of the vector is very fast.

Like HashMaps, we'd be a lot better off if Smalltalk had a literal syntax for creating these. (It's not a bad idea to have mutable Arrays around in the system for the sake of performance when doing low-level programming, but it's kind of insane that they're the *default* thing you get when you write {1. 2. 3}.)

----

To iterate over one of these, call #reducible or #seq on it to convert it to a Reducible or a Seq.

There's also #collect:, because (assuming you want another Vector) saying
	v collect: aBlock
is a bit more efficient than saying
	(v reducible collect: aBlock) into: Vector empty
because it doesn't have to build the whole structure up again from nothing. (See performanceExperiment3.)

But there's no #select:, because there's no efficiency gain to be had - we don't know how many elements will be in the final structure, so we have to build it up from nothing anyway. So just convert to a Reducible or a Seq first and then use #select: on that.

"
Class {
	#name : #Vector,
	#superclass : #Object,
	#instVars : [
		'node',
		'tail',
		'depth',
		'count'
	],
	#category : #'Immutable-Collections'
}

{ #category : #creating }
Vector class >> containing: aCollection [ 
	^ self empty, aCollection seq
]

{ #category : #constants }
Vector class >> depthForCount: count [
	| depth |
	depth := count > 0 ifTrue: [1] ifFalse: [0].
	[ ((count - 1) >> (depth * self logOfNodeSize)) > 0 ] whileTrue: [ depth := depth + 1 ].
	^ depth
]

{ #category : #creating }
Vector class >> empty [
	"Could cache this if we wanted to - there's no reason to keep creating a new one."
	^ self new initializeWithNode: {} tail: {} countNotIncludingTail: 0
]

{ #category : #nodes }
Vector class >> forNode: node depth: depth inject: initialValue into: aBlock [
	depth = 0 ifTrue: [ ^ initialValue ].
	depth = 1 ifTrue: [ ^ node inject: initialValue into: aBlock ].
	^ node inject: initialValue into: [ :v :n | self forNode: n depth: depth - 1 inject: v into: aBlock ]
]

{ #category : #constants }
Vector class >> indexInNodeAtDepth: depth globalIndex: globalIndex [ 
	^ (((globalIndex - 1) >> (Vector logOfNodeSize * (depth - 1))) bitAnd: Vector nodeSize - 1) + 1
]

{ #category : #constants }
Vector class >> logOfNodeSize [
	^ 5
]

{ #category : #nodes }
Vector class >> mapNode: node atDepth: depth by: aBlock [
	^ depth = 0 ifTrue: [
		nil
	] ifFalse: [
		depth = 1 ifTrue: [
			node collect: aBlock
		] ifFalse: [
			node collect: [ :n | self mapNode: n atDepth: depth - 1 by: aBlock ]
		]
	]
]

{ #category : #nodes }
Vector class >> modifiedNode: node atDepth: depth withInternal: index as: element [
	^ depth = 0
		ifTrue: [ element ]
		ifFalse: [| localIndex |
			localIndex := Vector indexInNodeAtDepth: depth globalIndex: index.
			node copyWith: localIndex as: (Vector modifiedNode: (node at: localIndex) atDepth: depth - 1 withInternal: index as: element)
		]
]

{ #category : #nodes }
Vector class >> modifiedNode: originalNode withAddedRightmostNode: newRightmostNode depth: depth count: count [
	| localIndex originalNodeAtDepthDMinusOne newNodeAtDepthDMinusOne |
	[depth >= 2] assert. "the newRightmostNode wants to be at depth 1, so we must be somewhere above that"
	localIndex := Vector indexInNodeAtDepth: depth globalIndex: count + 1.
	[localIndex = originalNode size or: [localIndex = (originalNode size + 1)]] assert.
	depth = 2 ifTrue: [
		newNodeAtDepthDMinusOne := newRightmostNode.
	] ifFalse: [
		originalNodeAtDepthDMinusOne := localIndex = originalNode size ifTrue: [originalNode at: localIndex] ifFalse: [{}].
		newNodeAtDepthDMinusOne := Vector modifiedNode: originalNodeAtDepthDMinusOne withAddedRightmostNode: newRightmostNode depth: depth - 1 count: count.
	].
	^ localIndex = originalNode size
		ifTrue: [originalNode copyWith: localIndex as: newNodeAtDepthDMinusOne]
		ifFalse: [originalNode copyAndAppend: newNodeAtDepthDMinusOne]
]

{ #category : #nodes }
Vector class >> modifiedNode: originalNode withoutRightmostNodeAtGlobalIndex: globalIndex depth: depth [
	| localLastIndex |
	[depth >= 2] assert. "The rightmost node will be at depth 1, so we must be somewhere above that"
	localLastIndex := Vector indexInNodeAtDepth: depth globalIndex: globalIndex.
	[localLastIndex = originalNode size or: [localLastIndex = (originalNode size - 1)]] assert.
	^ localLastIndex = originalNode size
		ifTrue: [ originalNode copyWith: localLastIndex as: (Vector modifiedNode: (originalNode at: localLastIndex) withoutRightmostNodeAtGlobalIndex: globalIndex depth: depth - 1) ]
		ifFalse: [ originalNode copyFrom: 1 to: localLastIndex ]
]

{ #category : #constants }
Vector class >> nodeSize [
	^ 32
]

{ #category : #performance }
Vector class >> performanceExperiment1 [
	"On my machine, this gives me results like:  'OrderedCollection took 0:00:00:01.043, Vector took 0:00:00:01.416'. Surprisingly good!

	Vector performanceExperiment1
	"
	| N immutableTime mutableTime |
	N := 1000000.

	mutableTime := [| c | 
		c := OrderedCollection new.
		(1 to: N) do: [ :n | c add: n * n ].
		(1 to: N) do: [ :n | [(c at: n) = (n * n)] assert ].
	] timeToRun.
	
	immutableTime := [| c |
		c := (1 to: N) inject: Vector empty into: [ :v :n | v withLast: n * n ].
		(1 to: N) do: [ :n | [(c at: n) = (n * n)] assert ].
	] timeToRun.

	^ 'OrderedCollection took ', mutableTime printString, ', Vector took ', immutableTime printString
]

{ #category : #performance }
Vector class >> performanceExperiment2 [
	"On my machine, this gives me results like:   'Array took 0:00:00:02.203 to do 10000, Vector took 0:00:00:01.868 to do 1000000'.
	
	Vector performanceExperiment2
	"
	| N1 N2 immutableTime mutableTime |
	N1 := 10000. "When I bump this up to 100000, Pharo gives me the low-space warning."
	N2 := 1000000.
	
	mutableTime := [| c |
		c := { Array new } asOrderedCollection.
		(1 to: N1) do: [ :n | c add: (c last copyAndAppend: n * n) ].
		c
	] timeToRun.

	immutableTime := [| c |
		c := (1 to: N2) inject: (Vector containing: {Vector empty}) into: [ :v :n | v withLast: (v last withLast: n * n) ].
	] timeToRun.

	^ 'Array took ', mutableTime printString, ' to do ', N1 printString, ', Vector took ', immutableTime printString, ' to do ', N2 printString
]

{ #category : #performance }
Vector class >> performanceExperiment3 [
	"On my machine, this gives me results like:  'Vector #collect: took 0:00:00:01.128, Reducible #collect: took 0:00:00:01.749'.
	Not a huge difference, but enough to be worth having Vector #collect:.
	
	Vector performanceExperiment3
	"
	| N timeUsingVectorCollect timeUsingReducibleCollect |
	N := 1000000.
	
	timeUsingVectorCollect := [(Vector containing: (1 to: N)) collect: #squared] timeToRun.
	timeUsingReducibleCollect := [((Vector containing: (1 to: N)) foldable collect: #squared) into: Vector empty] timeToRun.

	^ 'Vector #collect: took ', timeUsingVectorCollect printString, ', Reducible #collect: took ', timeUsingReducibleCollect printString
]

{ #category : #performance }
Vector class >> performanceExperiment4 [
	"On my machine, this gives me results like:  'OrderedCollection took 0:00:00:00.012, Vector took 0:00:00:00.018'

	Vector performanceExperiment4
	"
	| N c v immutableTime mutableTime |
	N := 1000000.

	c := OrderedCollection new.
	(1 to: N) do: [ :n | c add: n ].
	
	v := Vector containing: c.

	mutableTime		:= [ c inject: 0 into: [ :total :unused | total ] ] timeToRun.
	immutableTime		:= [ v inject: 0 into: [ :total :unused | total ] ] timeToRun.

	^ 'OrderedCollection took ', mutableTime printString, ', Vector took ', immutableTime printString
]

{ #category : #nodes }
Vector class >> replacedOrModifiedNode: node withAddedRightmostNode: newRightmostNode depth: depth count: count [
	| newCount |
	newCount := count + newRightmostNode size.
	^ count = 0 ifTrue: [
		newRightmostNode
	] ifFalse: [| newDepth |
		newDepth := Vector depthForCount: newCount.
		newDepth > depth ifTrue: [
			"We need another level in the tree, so just reuse the old node and next to it put a path down to the newRightmostNode."
			{ node. (2 to: depth) inject: newRightmostNode into: [ :p :i | {p} ] }
		] ifFalse: [
			Vector modifiedNode: node withAddedRightmostNode: newRightmostNode depth: depth count: count
		]
	]
	
	
]

{ #category : #nodes }
Vector class >> rightmostNodeIn: node depth: depth [
	^ depth = 1
		ifTrue: [node]
		ifFalse: [Vector rightmostNodeIn: (node at: node size) depth: depth - 1]
]

{ #category : #accessing }
Vector >> , elements [
	"Batch up tail modifications for efficiency."
	| v batchedUpTail nodeSize |
	v := self.
	nodeSize := Vector nodeSize.
	batchedUpTail := tail asOrderedCollection.
	elements do: [ :e |
		batchedUpTail size = nodeSize ifTrue: [
			v := v withAddedRightmostNode: batchedUpTail asArray andTail: {}.
			batchedUpTail := OrderedCollection new: nodeSize.
		].
		batchedUpTail add: e.
	].
	v := v withTail: batchedUpTail asArray.
	^ v
]

{ #category : #comparing }
Vector >> = other [
	^ self == other or: [self seq = other seq]
]

{ #category : #accessing }
Vector >> at: index [
	"Note that you can use #maybeAt: instead."
	^ self at: index ifInBounds: [ :v | v ] ifOutOfBounds: [ self error: 'Vector index out of bounds' ]
]

{ #category : #accessing }
Vector >> at: index ifInBounds: presentBlock ifOutOfBounds: absentBlock [
	"Note that you can use #maybeAt: instead."
	^ (index < 1 or: [ index > self size]) ifTrue: [
		absentBlock value
	] ifFalse: [
		presentBlock value: (
			index > count ifTrue: [
				tail at: index - count
			] ifFalse: [| n d |
				n := node.
				d := depth.
				[d > 0] whileTrue: [
					n := n at: (Vector indexInNodeAtDepth: d globalIndex: index).
					d := d - 1.
				].
				n
			]
		)
	]
]

{ #category : #'accessing deeply' }
Vector >> atPath: keyPath [
	"Assumes that the receiver is the root of a nested structure (Maps containing Maps containing Vectors containing Maps, etc.).
	Treats keyPath as a sequence of keys: the first is the key into the root, the next is the key into the child, then the key into the grandchild, etc.
	Returns a Maybe containing the value at that path."
	^ Map in: self atPath: keyPath
]

{ #category : #'"modifying"' }
Vector >> collect: aBlock [
	"You could just use a Reducible or a Seq, but this is more efficient if you really do want a Vector as the result."
	^ Vector new initializeWithNode: (Vector mapNode: node atDepth: depth by: aBlock) tail: (tail collect: aBlock) countNotIncludingTail: count
]

{ #category : #'"modifying"' }
Vector >> conj: element [ 
	"Short for 'conjoin'. It's a Clojure-ism. Note that it's polymorphic. Its most common use is #into:"
	^ self withLast: element
]

{ #category : #iterating }
Vector >> fold: aMonoid [
	^ ParallelFolding arrayedCollection: self fold: aMonoid maxChunkSize: 20
]

{ #category : #iterating }
Vector >> foldable [
	^ SimpleFoldable new initializeForCollection: self injectMethodName: #inject:into: foldMethodName: #fold:
]

{ #category : #comparing }
Vector >> hash [
	^ self seq hash
]

{ #category : #initializing }
Vector >> initializeWithNode: n tail: t countNotIncludingTail: c [ 
	node := n.
	tail := t.
	count := c.
	depth := Vector depthForCount: c.
]

{ #category : #iterating }
Vector >> inject: initialValue into: aBlock [
	| valueFromNode |
	valueFromNode := Vector forNode: node depth: depth inject: initialValue into: aBlock.
	^ tail inject: valueFromNode into: aBlock
]

{ #category : #accessing }
Vector >> last [
	^ self at: self size
]

{ #category : #'"modifying"' }
Vector >> map: aBlock [
	^ self collect: aBlock
]

{ #category : #accessing }
Vector >> maybeAt: index [
	^ self at: index ifInBounds: [ :v | Something withValue: v ] ifOutOfBounds: nothing
]

{ #category : #printing }
Vector >> printOn: aStream [
	| sep |
	sep := nil.
	aStream nextPutAll: '['.
	self seq do: [ :e |
		sep ifNil: [ sep := ' ' ] ifNotNil: [ aStream nextPutAll: sep ].
		aStream print: e.
	].
	aStream nextPutAll: ']'.
]

{ #category : #iterating }
Vector >> reverseSeq [
	^ self reverseSeqAt: self size
]

{ #category : #iterating }
Vector >> reverseSeqAt: index [
	^ IndexedSeq new initializeWithCollection: self index: index delta: -1
]

{ #category : #iterating }
Vector >> seq [
	^ self seqAt: 1
]

{ #category : #iterating }
Vector >> seqAt: index [ 
	^ IndexedSeq new initializeWithCollection: self index: index delta: 1
]

{ #category : #accessing }
Vector >> size [
	^ count + tail size
]

{ #category : #'"modifying"' }
Vector >> with: index as: element [ 
	^ index > count ifTrue: [| indexInTail |
		indexInTail := index - count.
		indexInTail <= tail size ifTrue: [
			self withTail: (tail copyWith: indexInTail as: element)
		] ifFalse: [
			indexInTail = (tail size + 1) ifTrue: [
				tail size < Vector nodeSize ifTrue: [
					self withTail: (tail copyAndAppend: element)
				] ifFalse: [
					tail size = Vector nodeSize ifTrue: [
						self withDigestedTail with: index as: element
					] ifFalse: [
						self error: 'Assertion failure: tail is too big? How can that happen?'
					]
				]
			] ifFalse: [
				self error: 'Not implemented yet: inserting past the end of a vector.'
			]
		]
	] ifFalse: [
		self withInternal: index as: element
	]
]

{ #category : #'private-modifying' }
Vector >> withAddedRightmostNode: newRightmostNode andTail: newTail [
	^ Vector new
		initializeWithNode: (Vector replacedOrModifiedNode: node withAddedRightmostNode: newRightmostNode depth: depth count: count)
		tail: newTail
		countNotIncludingTail: count + newRightmostNode size
]

{ #category : #'private-modifying' }
Vector >> withDigestedTail [
	^ self withAddedRightmostNode: tail andTail: {}
]

{ #category : #'private-modifying' }
Vector >> withInternal: index as: element [
	^ Vector new
		initializeWithNode: (Vector modifiedNode: node atDepth: depth withInternal: index as: element)
		tail: tail
		countNotIncludingTail: count
]

{ #category : #'"modifying"' }
Vector >> withLast: element [ 
	^ self with: self size + 1 as: element
]

{ #category : #'accessing deeply' }
Vector >> withPath: keyPath as: value [
	"Assumes that the receiver is the root of a nested structure (Maps containing Maps containing Vectors containing Maps, etc.).
	Treats keyPath as a sequence of keys: the first is the key into the root, the next is the key into the child, then the key into the grandchild, etc.
	Returns a new structure with that path 'modified' to have the specified value.
	Will insert maps along the way if necessary."
	^ Map in: self withPath: keyPath as: value
]

{ #category : #'accessing deeply' }
Vector >> withPath: keyPath updatedBy: aBlock [
	"Assumes that the receiver is the root of a nested structure (Maps containing Maps containing Vectors containing Maps, etc.).
	Treats keyPath as a sequence of keys: the first is the key into the root, the next is the key into the child, then the key into the grandchild, etc.
	Returns a new structure with that path 'modified' to have the value returned by the block (which will be passed a Maybe containing the old value at that path).
	Will insert maps along the way if necessary."
	^ Map in: self withPath: keyPath updatedBy: aBlock
]

{ #category : #'private-modifying' }
Vector >> withRegurgitatedTail [
	| newCount newDepth oldRightmostNode newTopNode |
	oldRightmostNode := Vector rightmostNodeIn: node depth: depth.
	newCount := count - Vector nodeSize.
	newDepth := Vector depthForCount: newCount.
	newTopNode := depth > newDepth ifTrue: [node at: 1] ifFalse: [Vector modifiedNode: node withoutRightmostNodeAtGlobalIndex: newCount depth: depth].
	^ Vector new initializeWithNode: newTopNode tail: oldRightmostNode countNotIncludingTail: newCount
]

{ #category : #'private-modifying' }
Vector >> withTail: newTail [
	^ Vector new initializeWithNode: node tail: newTail countNotIncludingTail: count
]

{ #category : #'"modifying"' }
Vector >> withoutLast [
	^ tail size > 0 ifTrue: [
		self withTail: (tail copyFrom: 1 to: tail size - 1)
	] ifFalse: [
		[count > 0] assert. "Cannot do withoutLast on an empty vector."
		self withRegurgitatedTail withoutLast
	]
]
