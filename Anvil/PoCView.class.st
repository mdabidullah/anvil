Class {
	#name : #PoCView,
	#superclass : #BlElement,
	#instVars : [
		'state',
		'damaged',
		'element'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #initialization }
PoCView >> initialize [
	super initialize.

	self size: PoCGame resolution.
	
	self background: Color lightGray.
	element := PoCElement new size: 10@10; relocate: 11@11.
	self addChild: (element).
	
	"1 to: 31 do: [ :x |
		1 to: 31 do: [ :y | 
			|element |
			element := PoCElement new.
			element relocate: (x * 21) @ (y * 21).
			self addChild: element.
		] 
	]"
	"((31 * 31) timesCollect: [ :pos | PoCElement new position: pos ]) do: [ :element |
		]"
]

{ #category : #accessing }
PoCView >> state: aState [
	state := aState.
]

{ #category : #accessing }
PoCView >> update [
	 element relocate: state location.
]
