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
		
	aCanvas fill
		path: (aCanvas shape roundedRectangle: (Rectangle origin: (state at: #location) extent: 10@10) radii:(BlCornerRadii radius: 4) );
		paint: (Color red);
		draw.
]
