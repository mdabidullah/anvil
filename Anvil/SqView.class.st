Class {
	#name : #SqView,
	#superclass : #BlElement,
	#instVars : [
		'state',
		'view'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #drawing }
SqView >> drawOnSpartaCanvas: aCanvas [
	self halt.
	"draw level"
	"1 to: 31 do: [ :x |
		1 to: 31 do: [ :y | 
			|element |
			element := PoCElement new.
			element relocate: (x * 21) @ (y * 21).
			self addChild: element.
		] 
	]"
	
	1 to: 2 do: [ :i |
		
		aCanvas fill
		path: (aCanvas shape roundedRectangle: (Rectangle origin: ((i*10)@(i*10)) extent: 10@10) radii:(BlCornerRadii radius: 4) );
		paint: (Color black);
		draw. ]
	"draw placed cells"
	
	"draw current shape"
]

{ #category : #initialization }
SqView >> initialize [
	super initialize.
	
	self size: PoCGame resolution.
]

{ #category : #anvil }
SqView >> state: aState [
	state := aState.
]

{ #category : #initialization }
SqView >> step [
	self flag: 'todo'.
]

{ #category : #anvil }
SqView >> update [
	self invalidate.
]
