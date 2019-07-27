"
I am responsible for drawing the prototype.
"
Class {
	#name : #PView,
	#superclass : #AnvilView,
	#category : #'Anvil-Prototype'
}

{ #category : #drawing }
PView >> drawOnSpartaCanvas: aCanvas [

	aCanvas transform
		translateBy: 100@100;
		push.
		
	aCanvas transform
		by: [ :aTransform | 
			aTransform rotateByDegrees: (state at: #rotation).
			aTransform translateBy: (-150) 
											@
											(-150). ]
		during: [ 
			aCanvas fill
		path: (aCanvas shape roundedRectangle: (Rectangle origin: 100@100 extent: 100@100) radii:(BlCornerRadii radius: 4) );
		paint: (Color red);
		draw.
			 ].
		
	aCanvas transform pop.
]

{ #category : #anvil }
PView >> initialize [
	super initialize.

	self size: AnvilGame resolution.
	
	SystemAnnouncer uniqueInstance when: MethodModified do: [ :methodModified | methodModified method selector == #drawOnSpartaCanvas: ifTrue: self update ].
	
	self enqueueTask: (BlRepeatedTaskAction new delay: 100 milliSeconds; 
															 action: [ self step ]).
]
