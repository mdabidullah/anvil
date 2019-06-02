Extension { #name : #BlockClosure }

{ #category : #'*Immutable-Collections' }
BlockClosure >> compose: otherBlock [
	^ [ :arg | self value: (otherBlock value: arg) ]
]

{ #category : #'*Immutable-Collections' }
BlockClosure >> curry [
	numArgs = 1 ifTrue: [ ^ self ].
	numArgs = 2 ifTrue: [ ^ [ :a | [ :b | self value: a value: b ] ] ].
	numArgs = 3 ifTrue: [ ^ [ :a | [ :b | [ :c | self value: a value: b value: c ] ] ] ].
	numArgs = 4 ifTrue: [ ^ [ :a | [ :b | [ :c | [ :d | self value: a value: b value: c value: d ] ] ] ] ].
	numArgs = 0 ifTrue: [ ^ self error: 'Cannot curry a block that takes no arguments.' ].
	self error: 'This block takes a lot of arguments. Go add more lines to the #curry method.'
]

{ #category : #'*Immutable-Async' }
BlockClosure >> go [
	| promise |
	promise := AsyncPromise new.
	[ promise fulfill: self value ] fork.
	^ promise
]

{ #category : #'*Immutable-Collections' }
BlockClosure >> repeatedly [
	"Assumes that this block takes no args and is called for its side effects. Returns an infinite Seq of calls to it."
	^ SeqWithABlock block: [ :firstAndRestBlock | firstAndRestBlock value: self value value: self repeatedly ]
]
