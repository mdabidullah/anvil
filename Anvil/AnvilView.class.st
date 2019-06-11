"
PoCView does not have a drawing loop. A drawing loop could be created with: 

	initialize
	super initialize.
	
	self enqueueTask: (BlRepeatedTaskAction new delay: 16 milliSeconds; 
															 action: [ self step ]).

The function step would be responsible for calling `self invalidate`. `invalidate` should only be called when necessary for performance. A variable to keep track of whether a redraw is necessary could be created. 
"
Class {
	#name : #AnvilView,
	#superclass : #BlElement,
	#instVars : [
		'state',
		'element',
		'model'
	],
	#category : #'Anvil-Prototype'
}

{ #category : #drawing }
AnvilView >> drawOnSpartaCanvas: aCanvas [
	super drawOnSpartaCanvas: aCanvas.
	"aCanvas transform
		translateBy: 100@100;
		rotateByDegrees: (state at: #rotation);
		push."

	aCanvas transform
	by: [ :aTransform | 
		aTransform 
			translateBy: 100@50"-50@(-50)";
			rotateByDegrees: (state at: #rotation) ]
	during: [  
		aCanvas fill
			path: 
				(aCanvas shape 
					roundedRectangle: 
						(Rectangle origin: (state at: #location) extent: 10@10) 
					radii:(BlCornerRadii radius: 2) );
			paint: (Color black);
			draw.
	].

	"aCanvas translate
		pop."
]

{ #category : #initialization }
AnvilView >> initialize [
	super initialize.

	self size: AnvilGame resolution.
	
	self background: Color lightGray.
	
	SystemAnnouncer uniqueInstance when: MethodModified do: [:methodModified | methodModified method selector == #drawOnSpartaCanvas: ifTrue: self update ].
	
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
AnvilView >> model: aModel [
	model := aModel.
]

{ #category : #accessing }
AnvilView >> state: aState [
	state := aState.
]

{ #category : #announcement }
AnvilView >> unsubscribe [
	SystemAnnouncer uniqueInstance unsubscribe: self. 
]

{ #category : #accessing }
AnvilView >> update [
	self invalidate.
]
