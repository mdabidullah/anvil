Class {
	#name : #SqView,
	#superclass : #AnvilView,
	#category : #'Anvil-SquareSquare'
}

{ #category : #drawing }
SqView >> drawOnSpartaCanvas: aCanvas [
	
	aCanvas transform
		translateBy: (state at: #offset);
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
