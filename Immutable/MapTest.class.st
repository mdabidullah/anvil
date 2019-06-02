Class {
	#name : #MapTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
MapTest >> allMapClasses [
	^ { ArrayMap. HashMap }
]

{ #category : #'as yet unclassified' }
MapTest >> testAtPath [
	| nestedStructure nestedStructure2 |
	nestedStructure := HashMap from: {
		#sillyRecords -> (Vector containing: {
			SillyRecord fromValues: { 'one'. 'two'. 'three' }.
			SillyRecord fromValues: { 'un'. 'deux'. 'trois' }.
		}).
		'argle bargle' -> 'whatever'
	}.
	self assert: (nestedStructure atPath: { #sillyRecords. 1. #b }) equals: (Something withValue: 'two').
	self assert: (nestedStructure atPath: { #sillyRecords. 2. #b }) equals: (Something withValue: 'deux').
	self assert: (nestedStructure atPath: { #sillyRecords. 2. #c }) equals: (Something withValue: 'trois').
	self assert: (nestedStructure atPath: { #sillyRecords. 3. #a }) equals: nothing.
	self assert: (nestedStructure atPath: { #sillyRecords. 3 }) equals: nothing.
	self assert: (nestedStructure atPath: { 'argle bargle' }) equals: (Something withValue: 'whatever').
	self assert: (nestedStructure atPath: { #sillyRecords. 1 }) equals: (Something withValue: (SillyRecord fromValues: { 'one'. 'two'. 'three' })).
	self assert: (nestedStructure atPath: {}) equals: (Something withValue: nestedStructure).

	nestedStructure2 := ((((nestedStructure
		withPath: { #x } as: 111)
		withPath: { #y. 'hello' } as: 222)
		withPath: { #z.  } as: 333)
		withPath: { #y. #y2. #y3 } updatedBy: [:maybeOldValue | maybeOldValue ifPresent: [self error] ifAbsent: [444]])
		withPath: { #sillyRecords. 2. #a } updatedBy: [:maybeOldValue | maybeOldValue ifAbsent: [self error] ifPresent: [:v | v, 'o']].
	
	self assert: (nestedStructure2 atPath: { #x }) equals: (Something withValue: 111).
	self assert: (nestedStructure2 atPath: { #y }) equals: (Something withValue: (Map from: { 'hello' -> 222. #y2 -> (Map from: { #y3 -> 444 }) })).
	self assert: (nestedStructure2 atPath: { #z }) equals: (Something withValue: 333).
	self assert: (nestedStructure2 atPath: { #sillyRecords. 2. #a }) equals: (Something withValue: 'uno').

]

{ #category : #'as yet unclassified' }
MapTest >> testBiggerOne [
	self allMapClasses do: [ :mapClass |
		| squares |
		squares := mapClass from: ((1 to: 100000) seq collect: [ :n | n -> (n * n) ]).
		(1 to: 100000) do: [ :n | self assert: (squares at: n) equals: n * n ].
		self assert: squares size equals: 100000.
	].

]

{ #category : #'as yet unclassified' }
MapTest >> testCollisions [
	| h k1 k2 k3 |
	k1 := ObjectWithSpecifiableHash createWithHash: 42.
	k2 := ObjectWithSpecifiableHash createWithHash: 42.
	k3 := ObjectWithSpecifiableHash createWithHash: 111.
	h := ((HashMap empty with: k1 as: 'one') with: k2 as: 'two') with: k3 as: 'three'.
	self assert: h size equals: 3.
	self assert: (h at: k1) equals: 'one'.
	self assert: (h at: k2) equals: 'two'.
	self assert: (h at: k3) equals: 'three'.
	self assert: (h at: (ObjectWithSpecifiableHash createWithHash: 42) ifAbsent: nil) equals: nil.

]

{ #category : #'as yet unclassified' }
MapTest >> testConj [
	self allMapClasses do: [ :mapClass |
		| h |
		h := mapClass from: { 'one' -> 1. 'two' -> 2 }.
		self assert: h size equals: 2.
		self assert: (h at: 'one') equals: 1.
		self assert: (h at: 'two') equals: 2.
	].
]

{ #category : #'as yet unclassified' }
MapTest >> testEmpty [
	self allMapClasses do: [ :mapClass |
		| h h1 h2 h3 h3Again h4 associations2 |
		h := mapClass empty.
		self assert: (h at: 'blah' ifAbsent: nil) equals: nil.
		self assert: h associations size equals: 0.
	
		h1 := h with: 'one' as: 1.
		self assert: (h1 at: 'one') equals: 1.
		self assert: (h1 at: 'blah' ifAbsent: nil) equals: nil.
		self assert: h1 associations size equals: 1.
		self assert: (h1 associations asArray at: 1) key equals: 'one'.
		self assert: (h1 associations asArray at: 1) value equals: 1.
	
		h2 := h1 with: 'two' as: 'deux'.
		associations2 := h2 associations asArray sorted: [:a :b | a key < b key].
		self assert: (h2 at: 'one') equals: 1.
		self assert: (h2 at: 'two') equals: 'deux'.
		self assert: (h2 at: 'blah' ifAbsent: nil) equals: nil.
		self assert: associations2 size equals: 2.
		self assert: (associations2 at: 1) key equals: 'one'.
		self assert: (associations2 at: 1) value equals: 1.
		self assert: (associations2 at: 2) key equals: 'two'.
		self assert: (associations2 at: 2) value equals: 'deux'.

		h3 := h2 without: 'one'.
		self assert: (h3 at: 'one' ifAbsent: nil) equals: nil.
		self assert: (h3 at: 'two') equals: 'deux'.
		self assert: h3 associations size equals: 1.
		self assert: h3 associationsSeq first key equals: 'two'.
		self assert: h3 associationsSeq first value equals: 'deux'.

		h3Again := h2 without: 'one'.
		self assert: h3 equals: h3Again.
		
		h4 := h3 without: #notThere.
		self assert: h3 equals: h4.
	].
]

{ #category : #'as yet unclassified' }
MapTest >> testEquals [
	self allMapClasses do: [ :mapClass |
		self assert: (mapClass from: { 'one' -> 1. 'two' -> 2 }) = (mapClass from: { 'two' -> 2. 'one' -> 1 }).
	].
	self assert: (HashMap from: { 'one' -> 1. 'two' -> 2 }) = (ArrayMap from: { 'two' -> 2. 'one' -> 1 }).

]

{ #category : #'as yet unclassified' }
MapTest >> testIncludesKey [
	self allMapClasses do: [ :mapClass |
		| h |
		h := mapClass from: { 'one' -> 1. 'two' -> 2 }.
		self assert: (h includesKey: 'one').
		self assert: (h includesKey: 'two').
		self deny: (h includesKey: 'three').
		self deny: (h includesKey: 1).
	].
]

{ #category : #'as yet unclassified' }
MapTest >> testKeys [
	self allMapClasses do: [ :mapClass |
		self assert: (mapClass from: { 'z' -> 1. 'y' -> 2 }) keys asArray sorted equals: { 'y'. 'z' }.
	].
]

{ #category : #'as yet unclassified' }
MapTest >> testMapValues [
	self allMapClasses do: [ :mapClass |
		self assert: ((mapClass from: { 'a' -> 1. 'b' -> 2. 'c' -> 3 }) mapValues: [ :v | v * v ]) equals: (Map from: { 'a' -> 1. 'b' -> 4. 'c' -> 9 }).
		self assert: ((mapClass from: ((1 to: 10000) collect: [:i | i -> (i * i)])) mapValues: [ :v :k | v + k ]) equals: (Map from: ((1 to: 10000) collect: [:i | i -> (i * i + i)])).
	].
]

{ #category : #'as yet unclassified' }
MapTest >> testMaybeAt [
	self allMapClasses do: [ :mapClass |
		| h |
		h := mapClass from: { 'one' -> 1. 'two' -> 2 }.
		self assert: ((h maybeAt: 'one') ifPresent: [ :v | v ] ifAbsent: [ 'not there' ]) equals: 1.
		self assert: ((h maybeAt: 'two') ifPresent: [ :v | v ] ifAbsent: [ 'not there' ]) equals: 2.
		self assert: ((h maybeAt: 'three') ifPresent: [ :v | v ] ifAbsent: [ 'not there' ]) equals: 'not there'.
	].
]

{ #category : #'as yet unclassified' }
MapTest >> testMerge [
	self assert: ((Map from: { #a -> 1. #b -> 2 }) mergeWith: (Map from: { #b -> 100. #c -> 200 }) using: [ :v1 :v2 | v1 + v2 ]) equals: (Map from: { #a -> 1. #b -> 102. #c -> 200 }).
]

{ #category : #'as yet unclassified' }
MapTest >> testValues [
	self allMapClasses do: [ :mapClass |
		self assert: (mapClass from: { 'one' -> 1. 'two' -> 2 }) values asArray sorted = { 1. 2 }.
	].
]
