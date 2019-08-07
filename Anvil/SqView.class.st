Class {
	#name : #SqView,
	#superclass : #AnvilView,
	#instVars : [
		'canvas'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #'as yet unclassified' }
SqView class >> backgroundColour [
	^ Color veryVeryLightGray
]

{ #category : #'as yet unclassified' }
SqView class >> diagonalColour [
	^ Color veryLightGray.
]

{ #category : #'as yet unclassified' }
SqView class >> placedCellColour [
	^ Color darkGray.
]

{ #category : #'as yet unclassified' }
SqView class >> shapeColour [
	^ Color darkGray
]

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

	aCanvas transform 
		by: [ :aTransform | aTransform
			rotateByDegrees: (state at: #levelRotation);
			translateBy: (-170)@(-170)]
		during: [ 
			"draw level background"
			
			0 to: ((state at: #levelSize) - 1) do: [ :x |
				0 to: ((state at: #levelSize) - 1) do: [ :y | 
					aCanvas fill
						path: (aCanvas shape 
									roundedRectangle: (Rectangle origin: ((x*11)@(y*11)) 
																		 extent: 10@10)
						   			radii:(BlCornerRadii radius: 2) );
						paint: (self class backgroundColour);
						draw.
				]. 
			].
		
			0 to: ((state at: #levelSize) - 1) do: [ :i | 
				aCanvas fill
					path: (aCanvas shape 
								roundedRectangle: (Rectangle origin: ((i*11)@(i*11)) 
																	 extent: 10@10)
								radii:(BlCornerRadii radius: 2) );
					paint: (self class diagonalColour);
					draw.
					
				aCanvas fill
					path: (aCanvas shape 
								roundedRectangle: (Rectangle origin: ((330-(i*11))@(i*11)) 
																	  extent: 10@10)
								radii:(BlCornerRadii radius: 2) );
					paint: (self class diagonalColour);
					draw.
			].

			aCanvas fill
				path: (aCanvas shape 
							roundedRectangle: (Rectangle origin: ((14*11)@(14*11)) 
																  extent: 32@32)
							radii:(BlCornerRadii radius: 2) );
				paint: (self class diagonalColour);
				draw.
			
			"Draw placed cells, #level is one indexed"
			1 to: (state at: #levelSize) do: [ :x |
				1 to: (state at: #levelSize) do: [ :y |
					((state at: #level) at: x at: y) ifNotNil: [ 
						aCanvas fill
							path: (aCanvas shape 
										roundedRectangle: (Rectangle origin: (((x-1)*11)@((y-1)*11)) 
																			 extent: 10@10)
							   			radii:(BlCornerRadii radius: 2) );
							paint: (self class placedCellColour);
							draw.
					].
				].
			].
			
			aCanvas transform 
				by: [ :aTransform | aTransform 
					translateBy: (15*10+16)@9 
				]
				during: [ 
					aCanvas text
						font: aFont;
						string: 'U';
					draw
				].
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
			rotateByDegrees: (state at: #levelRotation);
			translateBy: (-170)@(-170)]
		during: [  
			(state at: #inDiagonal) ifTrue: [ 
				| x y |
				x := (state at: #diagonalLocation) x * 11.
				y := (state at: #diagonalLocation) y * 11.
				aCanvas fill
					path: (aCanvas shape 
						roundedRectangle: (Rectangle origin: (x)@(y) 
															  extent: 10@10)
						radii:(BlCornerRadii radius: 2) );
					paint: (self class shapeColour);
					draw. 
			] ifFalse: [ 
				1 to: 4 do: [ :i |
				| point x y|
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
			
		].
	
	aCanvas transform pop
]

{ #category : #drawing }
SqView >> drawShapeWithCoordinates: aCoordinateArray [ 
	
	canvas transform
		translateBy: (384@216);
		push.
	
	canvas transform 
		by: [ :aTransform | aTransform
			rotateByDegrees: (state at: #levelRotation);
			translateBy: (-170)@(-170)]
		during: [  
			
			
			1 to: 4 do: [ :i |
				| point x y|
				"self halt. "
				point := aCoordinateArray atWrap: i.
				x := point x * 11. 
				y := point y * 11.
				canvas fill
					path: (canvas shape 
						roundedRectangle: (Rectangle origin: (x)@(y) 
															  extent: 10@10)
						radii:(BlCornerRadii radius: 2) );
					paint: (Color red);
					draw. ]
			
		].
	
	canvas transform pop.
]
