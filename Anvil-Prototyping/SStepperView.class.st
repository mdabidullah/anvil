Class {
	#name : #SStepperView,
	#superclass : #BlElement,
	#instVars : [
		'rotation'
	],
	#category : #'Anvil-Prototyping-Stepper'
}

{ #category : #initialization }
SStepperView >> drawOnSpartaCanvas: aCanvas [
	super drawOnSpartaCanvas: aCanvas.
	
	aCanvas transform
		translateBy: 100@100;
		push.
		
	aCanvas transform
		by: [ :aTransform | 
			aTransform rotateByDegrees: rotation.
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

{ #category : #initialization }
SStepperView >> initialize [
	super initialize.

	self size: AnvilGame resolution.
	
]

{ #category : #initialization }
SStepperView >> step [
	Transcript show: 'Time: '; show: (DateAndTime now); cr.
	Transcript show: 'Rotation: '; show: rotation; cr.
	rotation := rotation + 5.
	self invalidate.
	
]
