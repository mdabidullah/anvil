"
A monoid is a binary operation that is associative and has an identity element.

You already know lots of examples:
	+
	*
	or:
	and:
	min:
	max:
	, (concatenation)
	and lots more (see the class side of the Monoid class)

You can also combine monoids in various ways to form fancier monoids. For example, see #record: and #vector:.

Monoids are very useful for combining a big collection of values into a single value (see #fold:), because the associativity means that you can do the work in parallel - ""You do the right half, I'll do the left half, and we'll combine our results at the end.""

Avi Bryant has a great talk about practical uses of monoids:
http://www.infoq.com/presentations/abstract-algebra-analytics

"
Class {
	#name : #Monoid,
	#superclass : #Object,
	#instVars : [
		'identityElement',
		'combiningBlock'
	],
	#category : #'Immutable-Monads'
}

{ #category : #'common ones' }
Monoid class >> addition [
	^ self identity: 0 op: [ :a :b | a + b ]
]

{ #category : #'common ones' }
Monoid class >> average [
	"The elements aren't supposed to actually be averages, they're supposed to be a map with #sum and #count.
	So to average up a bunch of numbers, you can do something like this:
	
	| numbers sumAndCount average |
	numbers := { 102. 43. 97. 12. 22. 45. 154 }.
	sumAndCount := (numbers map: [ :n | Map from: { #sum -> n. #count -> 1 } ]) reducible fold: Monoid average.
	average := (sumAndCount at: #sum) / (sumAndCount at: #count).
	"

	^ self record: (Map from: { #sum -> Monoid addition. #count -> Monoid addition })
]

{ #category : #'common ones' }
Monoid class >> booleanAnd [
	^ self identity: true op: [ :a :b | a and: b ]
]

{ #category : #'common ones' }
Monoid class >> booleanOr [
	^ self identity: false op: [ :a :b | a or: b ]
]

{ #category : #'common ones' }
Monoid class >> booleanXor [
	^ self identity: false op: [ :a :b | a xor: b ]
]

{ #category : #'common ones' }
Monoid class >> endofunction [
	"An endofunction is just a function whose argument type is the same as its return type. So if you compose two of them, you get another one."
	^ self identity: [:v | v] op: [ :f1 :f2 | [:v | f1 value: (f2 value: v)] ]
]

{ #category : #creating }
Monoid class >> identity: identityElement op: combiningBlock [
	^ self new initializeIdentity: identityElement op: combiningBlock
]

{ #category : #'common ones' }
Monoid class >> listConcatenation [
	^ self identity: List empty op: [ :a :b | a, b ]
]

{ #category : #'common ones' }
Monoid class >> max [
	^ self identity: Float infinity negated op: [ :a :b | a max: b ]
]

{ #category : #'common ones' }
Monoid class >> maybeLeftmost [
	^ self identity: nothing op: [ :a :b | a ifPresent: [a] ifAbsent: [b] ]
]

{ #category : #'common ones' }
Monoid class >> maybeRightmost [
	^ self identity: nothing op: [ :a :b | b ifPresent: [b] ifAbsent: [a] ]
]

{ #category : #'common ones' }
Monoid class >> mergeMaps: monoidForValues [
	^ self identity: Map empty op: [ :m1 :m2 | m1 mergeWith: m2 using: monoidForValues combiningBlock ]
]

{ #category : #'common ones' }
Monoid class >> min [
	^ self identity: Float infinity op: [ :a :b | a min: b ]
]

{ #category : #'common ones' }
Monoid class >> multiplication [
	^ self identity: 1 op: [ :a :b | a * b ]
]

{ #category : #'common ones' }
Monoid class >> record: aRecordWhereEachKeyMapsToADifferentMonoid [
	^ self identity: (aRecordWhereEachKeyMapsToADifferentMonoid mapValues: [:m | m identityElement]) op: [ :a :b |
		aRecordWhereEachKeyMapsToADifferentMonoid mapValues: [ :m :k | m combiningBlock value: (a at: k) value: (b at: k)]
	]

]

{ #category : #'common ones' }
Monoid class >> stringConcatenation [
	^ self identity: '' op: [ :a :b | a, b ]
]

{ #category : #'common ones' }
Monoid class >> top: k [
	^ self top: k sortedBy: [ :a :b | a < b ]
]

{ #category : #'common ones' }
Monoid class >> top: k sortedBy: sortBlock [
	^ self identity: List empty op: [ :a :b | Vector containing: (((a, b) asArray sorted: [:x :y | (sortBlock value: x value: y) not]) seq take: k) ]
]

{ #category : #'common ones' }
Monoid class >> vector: aVectorOfMonoids [
	^ self identity: (aVectorOfMonoids collect: [:m | m identityElement]) op: [ :a :b |
		(Vector containing: (1 to: aVectorOfMonoids size)) collect: [ :i | (aVectorOfMonoids at: i) combiningBlock value: (a at: i) value: (b at: i) ]
	]
]

{ #category : #'private-initialization' }
Monoid >> combiningBlock [
	^ combiningBlock
]

{ #category : #'private-initialization' }
Monoid >> identityElement [
	^ identityElement
]

{ #category : #'private-initialization' }
Monoid >> initializeIdentity: idElem op: aBlock [
	identityElement := idElem.
	combiningBlock := aBlock.
]
