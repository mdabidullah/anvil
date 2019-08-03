Class {
	#name : #SqView,
	#superclass : #AnvilView,
	#instVars : [
		'canvas'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #accessing }
SqView >> canvas [ 
	^ canvas.
]

{ #category : #drawing }
SqView >> drawBackground: aCanvas [
	| aFont |
	aFont := aCanvas font 
					size: 10;
					weightThin;
					sansSerif;
					build.

	aCanvas transform
		translateBy: (384@216);
		push.

	"draw level background"
	aCanvas transform 
		by: [ :aTransform | aTransform
			rotateByDegrees: (state at: #levelRotation);
			translateBy: (-180)@(-180)]
		during: [ 
			1 to: (state at: #levelSize) do: [ :x |
				1 to: (state at: #levelSize) do: [ :y | 
					aCanvas fill
						path: (aCanvas shape 
									roundedRectangle: (Rectangle origin: ((x*11)@(y*11)) 
																		 extent: 10@10)
						   			radii:(BlCornerRadii radius: 2) );
						paint: (Color veryVeryLightGray);
						draw.
				] 
			].
			1 to: (state at: #levelSize) do: [ :i | 
				aCanvas fill
					path: (aCanvas shape 
								roundedRectangle: (Rectangle origin: ((i*11)@(i*11)) 
																	 extent: 10@10)
								radii:(BlCornerRadii radius: 2) );
					paint: (Color veryLightGray);
					draw.
					
				aCanvas fill
					path: (aCanvas shape 
								roundedRectangle: (Rectangle origin: ((352-(i*11))@(i*11)) 
																	  extent: 10@10)
								radii:(BlCornerRadii radius: 2) );
					paint: (Color veryLightGray);
					draw.
			].

			aCanvas fill
				path: (aCanvas shape 
							roundedRectangle: (Rectangle origin: ((15*11)@(15*11)) 
																  extent: 32@32)
							radii:(BlCornerRadii radius: 2) );
				paint: (Color veryLightGray);
				draw.
	
			aCanvas transform 
				by: [ :aTransform | aTransform 
					translateBy: (16*10+17)@20 ]
				during: [ 
					aCanvas text
						font: aFont;
						string: 'U';
					draw
				]
		].	
		
	aCanvas transform pop
]

{ #category : #drawing }
SqView >> drawOnSpartaCanvas: aCanvas [
	canvas ifNil: [ canvas := aCanvas ].
	self drawBackground: aCanvas.
	self drawShape: aCanvas.
]

{ #category : #drawing }
SqView >> drawShape: aCanvas [ 
	(state at: #shape) ifNil: [ ^ self ].
	aCanvas transform
		translateBy: (384@216);
		push.

	aCanvas transform 
		by: [ :aTransform | aTransform
			rotateByDegrees: 0;
			translateBy: (-180)@(-180)]
		during: [  
			
			1 to: 4 do: [ :i |
				| location point x y|
				"self halt. "
				point := (state at: #shape) atWrap: i.
				location := (state at: #shapeLocation). 
				x := location x * 11 + (point x * 11). 
				y := location y * 11 + (point y * 11).
				aCanvas fill
					path: (aCanvas shape 
						roundedRectangle: (Rectangle origin: (x)@(y) 
															  extent: 10@10)
						radii:(BlCornerRadii radius: 2) );
					paint: (Color darkGray);
					draw. ]
		].
	
	aCanvas transform pop
]
