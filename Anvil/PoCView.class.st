Class {
	#name : #PoCView,
	#superclass : #BlElement,
	#instVars : [
		'state',
		'damaged'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #initialization }
PoCView >> initialize [
	super initialize.

	self size: 800 @ 800.
	
	self background: Color lightGray.
	
	"self addChild: (PoCElement new relocate: (1 * 21) @ (1 * 21))."
	
	1 to: 31 do: [ :x |
		1 to: 31 do: [ :y | 
			|element |
			element := PoCElement new.
			element relocate: (x * 21) @ (y * 21).
			self addChild: element.
		] 
	]
	"((31 * 31) timesCollect: [ :pos | PoCElement new position: pos ]) do: [ :element |
		]"
]

{ #category : #accessing }
PoCView >> state: aState [
	state := aState.
]

{ #category : #accessing }
PoCView >> update [
	 self invalidate
]
