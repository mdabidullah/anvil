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
	"draw level"
	
	1 to: 31 do: [ :x |
		1 to: 31 do: [ :y | 
			aCanvas fill
				path: (aCanvas shape roundedRectangle: (Rectangle origin: ((x*11)@(y*12)) extent: 10@10)                                    radii:(BlCornerRadii radius: 2) );
				paint: (Color veryVeryLightGray);
				draw.
		] 
	].
	
	"1 to: (state at: #levelSize) do: [ :i |
		
		aCanvas fill
		path: (aCanvas shape roundedRectangle: (Rectangle origin: ((i*10)@(i*10)) extent: 10@10) radii:(BlCornerRadii radius: 4) );
		paint: (Color black);
		draw. ]."
	"draw placed cells"
	
	"draw current shape"
]

{ #category : #initialization }
SqView >> initialize [
	super initialize.
	
	self size: PoCGame resolution.
	
	SystemAnnouncer uniqueInstance when: MethodModified do: [:methodModified | methodModified method selector == #drawOnSpartaCanvas: ifTrue: self update ].
]

{ #category : #anvil }
SqView >> state: aState [
	state := aState.
]

{ #category : #initialization }
SqView >> step [
	self flag: 'todo'.
]

{ #category : #initialization }
SqView >> unsubscribe [
	SystemAnnouncer uniqueInstance unsubscribe: self. 
]

{ #category : #anvil }
SqView >> update [
	self invalidate.
]
