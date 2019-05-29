Class {
	#name : #PoCElement,
	#superclass : #BlElement,
	#instVars : [
		'position'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #initialization }
PoCElement >> drawOnSpartaCanvas: aCanvas [
	aCanvas fill
		path: (aCanvas shape roundedRectangle: (Rectangle origin: 0@0 extent: 10@10) radii:(BlCornerRadii radius: 4) );
		paint: (Color red);
		draw.
]

{ #category : #initialization }
PoCElement >> initialize [
	super initialize.
	
]
