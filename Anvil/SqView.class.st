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
					size: 12;
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
			translateBy: (-170)@(-170)]
		during: [ 
			aCanvas fill
						path: (aCanvas shape 
									roundedRectangle: (Rectangle origin: 0@0 
																		 extent: 10@10)
						   			radii:(BlCornerRadii radius: 2) );
						paint: (Color blue);
						draw.
			0 to: ((state at: #levelSize) - 1) do: [ :x |
				0 to: ((state at: #levelSize) - 1) do: [ :y | 
					aCanvas fill
						path: (aCanvas shape 
									roundedRectangle: (Rectangle origin: ((x*11)@(y*11)) 
																		 extent: 10@10)
						   			radii:(BlCornerRadii radius: 2) );
						paint: (Color veryVeryLightGray);
						draw.
				] 
			].
			0 to: ((state at: #levelSize) - 1) do: [ :i | 
				aCanvas fill
					path: (aCanvas shape 
								roundedRectangle: (Rectangle origin: ((i*11)@(i*11)) 
																	 extent: 10@10)
								radii:(BlCornerRadii radius: 2) );
					paint: (Color veryLightGray);
					draw.
					
				aCanvas fill
					path: (aCanvas shape 
								roundedRectangle: (Rectangle origin: ((330-(i*11))@(i*11)) 
																	  extent: 10@10)
								radii:(BlCornerRadii radius: 2) );
					paint: (Color veryLightGray);
					draw.
			].

			aCanvas fill
				path: (aCanvas shape 
							roundedRectangle: (Rectangle origin: ((14*11)@(14*11)) 
																  extent: 32@32)
							radii:(BlCornerRadii radius: 2) );
				paint: (Color veryLightGray);
				draw.
	
			aCanvas transform 
				by: [ :aTransform | aTransform 
					translateBy: (15*10+16)@9 ]
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
	
	aCanvas fill
		path: (aCanvas shape 
					roundedRectangle: (Rectangle origin: 214@46 
														 extent: 340@340)
					radii: (BlCornerRadii radius: 0));
		paint: (Color red);
		draw.
	
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
			rotateByDegrees: (state at: #levelRotation);
			translateBy: (-170)@(-170)]
		during: [  
			
			1 to: 4 do: [ :i |
				| location point x y|
				"self halt. "
				point := (state at: #shapeCoordinates) atWrap: i.
				x := point x * 11. 
				y := point y * 11.
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
