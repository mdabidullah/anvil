Class {
	#name : #SqView,
	#superclass : #BlElement,
	#instVars : [
		'state',
		'view'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #anvil }
SqView >> drawOnSpartaCanvas: aCanvas [
	super drawOnSpartaCanvas: aCanvas.
		
	aCanvas transform
		translateBy: (state at: #offset);
		scaleBy: 2;
		rotateByDegrees: 0;
		push.
	
	"draw level"
	
	"draw back cells"
	1 to: (state at: #levelSize) do: [ :x |
		1 to: (state at: #levelSize) do: [ :y | 
			aCanvas fill
				path: (aCanvas shape roundedRectangle: (Rectangle origin: ((x*11)@(y*11)) extent: 10@10)                                    radii:(BlCornerRadii radius: 2) );
				paint: (Color veryVeryLightGray);
				draw.
		] 
	].
	1 to: (state at: #levelSize) do: [ :i | 
		aCanvas fill
			path: (aCanvas shape roundedRectangle: (Rectangle origin: ((i*11)@(i*11)) extent: 10@10)                                    radii:(BlCornerRadii radius: 2) );
			paint: (Color veryLightGray);
			draw.
		aCanvas fill
			path: (aCanvas shape roundedRectangle: (Rectangle origin: ((352-(i*11))@(i*11)) extent: 10@10)                                    radii:(BlCornerRadii radius: 2) );
			paint: (Color veryLightGray);
			draw.
	].

	aCanvas fill
			path: (aCanvas shape roundedRectangle: (Rectangle origin: ((15*11)@(15*11)) extent: 32@32)                                    radii:(BlCornerRadii radius: 2) );
			paint: (Color veryLightGray);
			draw.
	
	
	"draw diagonal cells"
	
	"1 to: (state at: #levelSize) do: [ :i |
		
		aCanvas fill
		path: (aCanvas shape roundedRectangle: (Rectangle origin: ((i*10)@(i*10)) extent: 10@10) radii:(BlCornerRadii radius: 4) );
		paint: (Color black);
		draw. ]."
	"draw placed cells"
	
	"draw current shape"
	
	aCanvas transform pop
]

{ #category : #initialization }
SqView >> initialize [
	super initialize.
	
	self size: AnvilGame resolution.
	
	self enqueueTask: (BlRepeatedTaskAction new delay: 1 seconds; 
															 action: [ self step ]).
	
	SystemAnnouncer uniqueInstance when: MethodModified do: [:methodModified | methodModified method selector == #drawOnSpartaCanvas: ifTrue: self update ].
]

{ #category : #anvil }
SqView >> state: aState [
	state := aState.
]

{ #category : #initialization }
SqView >> step [
	self flag: 'todo'.
	"Transcript show: (Time now); cr.
	model step."
]

{ #category : #initialization }
SqView >> unsubscribe [
	SystemAnnouncer uniqueInstance unsubscribe: self. 
]

{ #category : #anvil }
SqView >> update [
	self invalidate.
]
