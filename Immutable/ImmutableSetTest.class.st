Class {
	#name : #ImmutableSetTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
ImmutableSetTest >> testConj [
	| s s1 |
	s := ImmutableSet empty conj: #argle.
	self assert: s seq asArray sorted equals: { #argle }.
	s1 := { #bargle. #noodle } foldable into: s.
	self assert: s1 equals: (ImmutableSet containing: { #argle. #bargle. #noodle }).
	
]

{ #category : #'as yet unclassified' }
ImmutableSetTest >> testEmpty [
	| s |
	s := ImmutableSet empty.
	self assert: s size equals: 0.
	self assert: s seq asArray equals: { }.
]

{ #category : #'as yet unclassified' }
ImmutableSetTest >> testEquals [
	self assert: (ImmutableSet containing: {}) = (ImmutableSet containing: {}).
	self assert: (ImmutableSet containing: {1. 2. 3}) = (ImmutableSet containing: {3. 1. 2. 2. 3}).
	self deny: (ImmutableSet containing: {}) = HashMap empty.
	self deny: (ImmutableSet containing: {}) = {}.
	self deny: (ImmutableSet containing: {}) = {} seq.
	self deny: (ImmutableSet containing: {'one'}) = {'one'}.

]

{ #category : #'as yet unclassified' }
ImmutableSetTest >> testSeq [
	| s |
	s := ImmutableSet containing: { 1. 4. 3. 5. 2. 1. 4. 4. 4 }.
	self assert: s size equals: 5. "no duplicates"
	self assert: s seq asArray sorted equals: { 1. 2. 3. 4. 5 }. 
]

{ #category : #'as yet unclassified' }
ImmutableSetTest >> testWith [
	| s s1 s2 |
	s := ImmutableSet containing: { 1. 4. 3. 5. 2. 1. 4. 4. 4 }.
	self assert: s size equals: 5. "no duplicates"
	s1 := s with: 6.
	self assert: s1 size equals: 6.
	self assert: s1 seq asArray sorted equals: { 1. 2. 3. 4. 5. 6 }.
	s2 := s1 with: 2.
	self assert: s2 size equals: 6.
	self assert: s2 seq asArray sorted equals: { 1. 2. 3. 4. 5. 6 }.

]

{ #category : #'as yet unclassified' }
ImmutableSetTest >> testWithout [
	| s s1 s2 |
	s := ImmutableSet containing: { 1. 4. 3. 5. 2. 1. 4. 4. 4 }.
	self assert: s seq asArray sorted equals: { 1. 2. 3. 4. 5. }.
	s1 := s without: 1.
	self assert: s1 seq asArray sorted equals: { 2. 3. 4. 5 }.
	s2 := s1 without: 7.
	self assert: s2 seq asArray sorted equals: { 2. 3. 4. 5 }.

]
