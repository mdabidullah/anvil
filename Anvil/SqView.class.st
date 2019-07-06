Class {
	#name : #SqView,
	#superclass : #AnvilView,
	#category : #'Anvil-SquareSquare'
}

{ #category : #'as yet unclassified' }
SqView >> drawBackground: aCanvas rotation: aDegree [
	| aFont |
	aFont := aCanvas font 
					size: 10;
					weightThin;
					sansSerif;
					build.

	aCanvas transform
		translateBy: (384@216);
		"translateBy: 0@0;"
		push.

	"draw level background"
	aCanvas transform 
		by: [ :aTransform | aTransform
			rotateByDegrees: aDegree;
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
					
			"draw transformed drawing point"
			aCanvas fill
				path: (aCanvas shape 
					roundedRectangle: (Rectangle origin: (-2)@(-2) 
														  extent: 4@4)
					radii:(BlCornerRadii radius: 2) );
				paint: (Color blue);
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
	self drawBackground: aCanvas rotation: 45.
	self drawShape: aCanvas.
]

{ #category : #drawing }
SqView >> drawShape: aCanvas [ 
	
]
