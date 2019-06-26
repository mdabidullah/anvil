Class {
	#name : #ImmutableQueueTest,
	#superclass : #TestCase,
	#category : #'Immutable-Tests'
}

{ #category : #'as yet unclassified' }
ImmutableQueueTest >> testBasics [
	| q q5 q59 q593 q594 q93 q3 qEmpty |
	q := ImmutableQueue empty.
	self assert: q isEmpty.
	self assert: q size equals: 0.
	q5 := q withLast: 5.
	self assert: q5 isEmpty not.
	self assert: q5 unsafeFirst equals: 5.
	self assert: q5 size equals: 1.
	q59 := q5 withLast: 9.
	self assert: q59 seq asArray equals: { 5. 9 }.
	q593 := q59 withLast: 3.
	self assert: q593 seq asArray equals: { 5. 9. 3 }.
	q594 := q59 withLast: 4.
	self assert: q594 seq asArray equals: { 5. 9. 4 }.
	q93 := q593 withoutFirst.
	self assert: q93 seq asArray equals: { 9. 3 }.
	q3 := q93 withoutFirst.
	self assert: q3 seq asArray equals: { 3 }.
	qEmpty := q3 withoutFirst.
	self assert: qEmpty seq asArray equals: { }.

]
