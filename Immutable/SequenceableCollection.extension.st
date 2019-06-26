Extension { #name : #SequenceableCollection }

{ #category : #'*Immutable-Collections' }
SequenceableCollection >> indexSatisfying: aBlock [
	^ (1 to: self size) detect: [ :i | aBlock value: (self at: i) ] ifNone: [0]
]

{ #category : #'*Immutable-Collections' }
SequenceableCollection >> maybeAt: index [
	^ (index < 1 or: [index > self size])
		ifTrue: [ nothing ]
		ifFalse: [ Something withValue: (self at: index) ]
]

{ #category : #'*Immutable-Collections' }
SequenceableCollection >> reverseSeq [
	^ self reverseSeqAt: self size
]

{ #category : #'*Immutable-Collections' }
SequenceableCollection >> reverseSeqAt: index [
	^ IndexedSeq new initializeWithCollection: self index: index delta: -1
]

{ #category : #'*Immutable-Collections' }
SequenceableCollection >> seq [
	^ self seqAt: 1
]

{ #category : #'*Immutable-Collections' }
SequenceableCollection >> seqAt: index [
	^ IndexedSeq new initializeWithCollection: self index: index delta: 1
]

{ #category : #'*Immutable-Collections' }
SequenceableCollection >> unsafeFirst [
	"I consider this unsafe because what if it's empty?"
	^ self first
]
