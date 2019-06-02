"
PoCView does not have a drawing loop. A drawing loop could be created with: 

	initialize
	super initialize.
	
	self enqueueTask: (BlRepeatedTaskAction new delay: 16 milliSeconds; 
															 action: [ self step ]).

The function step would be responsible for calling `self invalidate`. `invalidate` should only be called when necessary for performance. A variable to keep track of whether a redraw is necessary could be created. 
"
Class {
	#name : #PoCView,
	#superclass : #BlElement,
	#instVars : [
		'state',
		'element'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #drawing }
PoCView >> drawOnSpartaCanvas: aCanvas [
	
	aCanvas fill
		path: (aCanvas shape roundedRectangle: (Rectangle origin: (state at: #location) extent: 10@10) radii:(BlCornerRadii radius: 4) );
		paint: (Color black);
		draw.
		
	""
]

{ #category : #initialization }
PoCView >> initialize [
	super initialize.

	self size: PoCGame resolution.
	
	self background: Color lightGray.
	
	"self enqueueTask: (BlRepeatedTaskAction new delay: 16 milliSeconds; action: [ self step ])."
	
	"element := PoCElement new size: 10@10; relocate: 111@11.
	self addChild: (element)."
	
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

{ #category : #drawing }
PoCView >> test [
]

{ #category : #drawing }
PoCView >> test1 [
	^ 5
]

{ #category : #accessing }
PoCView >> update [
	self invalidate.
]
