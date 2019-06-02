Class {
	#name : #SeqTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
SeqTest >> testAllSatisfy [
	self assert: ({ 1. 3. 5. 7. 9 } seq allSatisfy: #odd).
	self deny: ({ 1. 3. 5. 7. 1000 } seq allSatisfy: #odd).

]

{ #category : #'as yet unclassified' }
SeqTest >> testAnySatisfy [
	self assert: ({ 1. 3. 5. 6. 7 } seq anySatisfy: #even).
	self deny: ({ 1. 3. 5. 7. 9 } seq anySatisfy: #even).

]

{ #category : #'as yet unclassified' }
SeqTest >> testArrays [
	| a s1 s2 s3 s4 s5 s6 s7 s8 |
	self assert: {} equals: {} seq asArray.
	a := { 1. 2. 3. 4. 5. 6. 7 }.
	s1 := a seq.
	self assert: { 1. 2. 3. 4. 5. 6. 7 } equals: s1 asArray.
	s2 := s1 unsafeRest.
	self assert: { 2. 3. 4. 5. 6. 7 } equals: s2 asArray.
	self assert: { 1. 2. 3. 4. 5. 6. 7 } equals: s1 asArray. "hasn't changed"
	s3 := s2 unsafeRest.
	s4 := s3 unsafeRest.
	s5 := s4 unsafeRest.
	s6 := s5 unsafeRest.
	s7 := s6 unsafeRest.
	self assert: { 7 } equals: s7 asArray.
	s8 := s7 unsafeRest.
	self assert: { } equals: s8 asArray.
	self assert: s8 isEmpty.

]

{ #category : #'as yet unclassified' }
SeqTest >> testArraysInReverse [
	self assert: {} equals: {} reverseSeq asArray.
	self assert: { 7. 6. 5. 4. 3. 2. 1 } equals: { 1. 2. 3. 4. 5. 6. 7 } reverseSeq asArray.
]

{ #category : #'as yet unclassified' }
SeqTest >> testCollect [
	self assert: ({ 1. 3. 5. 7. 9} seq collect: [:n | n * n]) asArray equals: {1. 9. 25. 49. 81}.

]

{ #category : #'as yet unclassified' }
SeqTest >> testConcatenation [
	self assert: { 1. 2. 3. 4. 5 } equals: ({ 1. 2. 3 } seq, { 4. 5 } seq) asArray.
	self assert: {} equals: ({} seq, {} seq) asArray.
	
]

{ #category : #'as yet unclassified' }
SeqTest >> testCons [
	self assert: ({1. 2. 3} seq cons: 0) asArray equals: { 0. 1. 2. 3 }.
]

{ #category : #'as yet unclassified' }
SeqTest >> testCycle [
	self assert: { 1. 2. 3. 1. 2. 3. 1 } equals: ({ 1. 2. 3 } seq cycle take: 7) asArray.
	self assert: { 1. 1. 1. 1. 1 } equals: ({ 1 } seq cycle take: 5) asArray.
	
]

{ #category : #'as yet unclassified' }
SeqTest >> testDo [
	| blecch |
	blecch := 0.
	{ 1. 2. 3. 4. 5 } seq do: [ :n | blecch := blecch + n ].
	self assert: blecch equals: 15.
	
]

{ #category : #'as yet unclassified' }
SeqTest >> testFind [
	self assert: (({ 1. 2. 3 } seq find: #even) ifPresent: [:v | v] ifAbsent: nil) equals: 2.
	self assert: (({ 1. 2. 3 } seq find: #isZero) ifPresent: [:v | v] ifAbsent: nil) equals: nil.
	
]

{ #category : #'as yet unclassified' }
SeqTest >> testFlatCollect [
	self assert: { 9. 1. 4. 16. 81 } equals: ({{ 3. 1. 2 }. { 4. 9 }} seq flatCollect: [:n | n * n]) asArray.

]

{ #category : #'as yet unclassified' }
SeqTest >> testIncludes [
	self assert: ({ 1. 3. 5. 7. 9 } seq includes: 3).
]

{ #category : #'as yet unclassified' }
SeqTest >> testInjectInto [
	self assert: ({ 1. 2. 3 } seq inject: 0 into: [ :sum :n | sum + n ]) equals: 6.
	
]

{ #category : #'as yet unclassified' }
SeqTest >> testInterpose [
	self assert: ({} seq interpose: 0) asArray equals: {}.
	self assert: ({1} seq interpose: 0) asArray equals: { 1 }.
	self assert: ({1. 2. 3} seq interpose: 0) asArray equals: { 1. 0. 2. 0. 3 }.

]

{ #category : #'as yet unclassified' }
SeqTest >> testInto [
	self assert: ({1. 2. 3} seq into: List empty) asArray equals: { 3. 2. 1 }.

]

{ #category : #'as yet unclassified' }
SeqTest >> testIsEmpty [
	self assert: {} seq isEmpty.
	self deny: {1} seq isEmpty.
	self assert: List empty isEmpty.
	self deny: (List empty cons: 'whatever') isEmpty.

]

{ #category : #'as yet unclassified' }
SeqTest >> testLaziness [
	"This is a terrible idea and you should never write code like this, but it serves to demonstrate that #collect: and #select: are lazy."
	| blocks thisWillNeverChange |
	thisWillNeverChange := 'original string'.
	blocks := {
		[ 1 ].
		[ 2 ].
		[ 3 ].
		[ thisWillNeverChange := 'changed string'. 4 ].
	}.
	self assert: ((blocks seq collect: [ :b | b value * b value ]) select: [:sq | sq >= 4]) unsafeFirst equals: 4.
	self assert: thisWillNeverChange equals: 'original string'.

]

{ #category : #'as yet unclassified' }
SeqTest >> testNoneSatisfy [
	self assert: ({ 1. 3. 5. 7. 9 } seq noneSatisfy: #even).
	self deny: ({ 1. 3. 5000. 7. 9 } seq noneSatisfy: #odd).

]

{ #category : #'as yet unclassified' }
SeqTest >> testReversed [
	self assert: {1. 2. 3} seq reversed asArray equals: { 3. 2. 1 }.

]

{ #category : #'as yet unclassified' }
SeqTest >> testSelect [
	self assert: ({ 1. 3. 5. 7. 9} seq select: [:n | n > 4]) asArray equals: {5. 7. 9}.

]

{ #category : #'as yet unclassified' }
SeqTest >> testTake [
	self assert: { 1. 2. 3 } equals: ({ 1. 2. 3. 4. 5. 6. 7. 8 } seq take: 3) asArray.
	self assert: { 1. 2. 3. 4 } equals: ({ 1. 2. 3. 4 } seq take: 19) asArray.
	
]
