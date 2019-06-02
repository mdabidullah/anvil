Class {
	#name : #HashMapBitmapIndexedNode,
	#superclass : #HashMapNode,
	#instVars : [
		'bitmap',
		'childNodes'
	],
	#category : #'Immutable-Private'
}

{ #category : #'bit twiddling' }
HashMapBitmapIndexedNode class >> bitCount: n [
	"Count the number of 1 bits in the number n.
	I don't know whether this dialect of Smalltalk has access to CTPOP; that'd be much faster. But hopefully this won't be too slow."
	
	| count remaining |
	count := 0.
	remaining := n.
	0 to: 31 do: [ :i |
		(remaining bitAnd: 1) = 1 ifTrue: [ count := count + 1 ].
		remaining := remaining >> 1.
	].
	^ count
]

{ #category : #'bit twiddling' }
HashMapBitmapIndexedNode class >> bitposForHash: hash level: level [
	^ 1 << ((hash >> level) bitAnd: (HashMapNode nodeSize - 1))
]

{ #category : #'bit twiddling' }
HashMapBitmapIndexedNode class >> fullArrayForChildNodes: childNodes bitmap: bitmap [
	"This is for converting from a bitmap-indexed node to a full node. So we need to put the elements of childNodes array into
	the appropriate places in the full array. (We determine the appropriate places by walking through the bitmap to see which
	bits are set.)"
	| fullArray numberOfChildrenAdded numberOfChildrenToAdd indexOfCurrentBit maskForCurrentBit |
	fullArray := Array new: HashMapNode nodeSize.
	numberOfChildrenAdded := 0.
	numberOfChildrenToAdd := childNodes size.
	indexOfCurrentBit := 1.
	maskForCurrentBit := 1.
	[ numberOfChildrenAdded < numberOfChildrenToAdd ] whileTrue: [
		(bitmap bitAnd: maskForCurrentBit) = 0 ifFalse: [
			numberOfChildrenAdded := numberOfChildrenAdded + 1.
			fullArray at: indexOfCurrentBit put: (childNodes at: numberOfChildrenAdded).
		].
		maskForCurrentBit := maskForCurrentBit << 1.
		indexOfCurrentBit := indexOfCurrentBit + 1.
	].
	^ fullArray

]

{ #category : #'bit twiddling' }
HashMapBitmapIndexedNode class >> indexForBitpos: bitpos bitmap: bitmap [
	^ (self bitCount: (bitmap bitAnd: bitpos - 1)) + 1   "+1 because Smalltalk indices start at 1"
]

{ #category : #'bit twiddling' }
HashMapBitmapIndexedNode class >> thresholdForSwitchingToAFullNode [
	"Could experiment with this, see how big it's worth letting this thing get before we just give up on the bitmap and spend the extra space on a full node."
	^ HashMapNode nodeSize / 2
]

{ #category : #iterating }
HashMapBitmapIndexedNode >> associationsInject: initialValue into: aBlock [
	^ childNodes inject: initialValue into: [ :valueSoFar :n | n associationsInject: valueSoFar into: aBlock ]
]

{ #category : #iterating }
HashMapBitmapIndexedNode >> associationsSeq [
	^ childNodes seq flatCollect: [ :n | n associationsSeq ]
]

{ #category : #accessing }
HashMapBitmapIndexedNode >> at: key level: l ifPresent: presentBlock ifAbsent: absentBlock [
	| desiredBitpos |
	desiredBitpos := HashMapBitmapIndexedNode bitposForHash: key hash level: l.
	^ (bitmap bitAnd: desiredBitpos) = 0
		ifTrue: [ absentBlock value ]
		ifFalse: [ (childNodes at: (HashMapBitmapIndexedNode indexForBitpos: desiredBitpos bitmap: bitmap)) at: key level: l + HashMapNode logOfNodeSize ifPresent: presentBlock ifAbsent: absentBlock ]
]

{ #category : #accessing }
HashMapBitmapIndexedNode >> count [
	^ childNodes inject: 0 into: [ :sum :n | sum + n count ]
]

{ #category : #initializing }
HashMapBitmapIndexedNode >> initializeWithChildNodes: nodes bitmap: b [
	childNodes := nodes.
	bitmap := b.
]

{ #category : #initializing }
HashMapBitmapIndexedNode >> initializeWithExistingNode: n level: lvl hash: hash [
	self
		initializeWithChildNodes: { n }
		bitmap: (HashMapBitmapIndexedNode bitposForHash: hash level: lvl).
]

{ #category : #'"modifying"' }
HashMapBitmapIndexedNode >> mapValues: aBlock [
	^ HashMapBitmapIndexedNode new initializeWithChildNodes: (childNodes collect: [:n | n mapValues: aBlock]) bitmap: bitmap
]

{ #category : #'"modifying"' }
HashMapBitmapIndexedNode >> with: key as: value level: l [
	| desiredBitpos childIndex |
	desiredBitpos := HashMapBitmapIndexedNode bitposForHash: key hash level: l.
	childIndex := HashMapBitmapIndexedNode indexForBitpos: desiredBitpos bitmap: bitmap.
	^ (bitmap bitAnd: desiredBitpos) = 0 ifTrue: [
		childNodes size >= HashMapBitmapIndexedNode thresholdForSwitchingToAFullNode ifTrue: [| fullArray |
			fullArray := HashMapBitmapIndexedNode fullArrayForChildNodes: childNodes bitmap: bitmap.
			fullArray at: (HashMapNode indexForHash: key hash level: l) put: key -> value.
			HashMapFullNode new initializeWithArray: fullArray
		] ifFalse: [
			HashMapBitmapIndexedNode new
				initializeWithChildNodes: (childNodes copyAndInsert: (key -> value) atIndex: childIndex)
				bitmap: (bitmap bitOr: desiredBitpos)
		]
	] ifFalse: [
		HashMapBitmapIndexedNode new
			initializeWithChildNodes: (childNodes copyWith: childIndex as: ((childNodes at: childIndex) with: key as: value level: l + HashMapNode logOfNodeSize))
			bitmap: bitmap
	]
]

{ #category : #'"modifying"' }
HashMapBitmapIndexedNode >> without: key level: l [
	| desiredBitpos |
	desiredBitpos := HashMapBitmapIndexedNode bitposForHash: key hash level: l.
	^ (bitmap bitAnd: desiredBitpos) = 0 ifTrue: [self] ifFalse: [| childIndex oldChild newChild |
		childIndex := HashMapBitmapIndexedNode indexForBitpos: desiredBitpos bitmap: bitmap.
		oldChild := childNodes at: childIndex.
		newChild := oldChild without: key level: l + HashMapNode logOfNodeSize.
		newChild == oldChild ifTrue: [self] ifFalse: [
			HashMapBitmapIndexedNode new
				initializeWithChildNodes: (childNodes copyWith: childIndex as: newChild)
				bitmap: bitmap
		]
	]
]
