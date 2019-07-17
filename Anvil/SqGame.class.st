Class {
	#name : #SqGame,
	#superclass : #AnvilGame,
	#category : #'Anvil-SquareSquare'
}

{ #category : #accessing }
SqGame >> initialize [	
	model := SqModel new.
	state := AnvilState new.
	
	model state: state.
	
	window := AnvilWindow new 
		extent: (self class resolution);
		title: self title.
	
	view := SqView new state: state.
	
	window addChild: view.
	
	window root addEventHandler: (AnvilEventListener new 
												model: model).
	
	state announcer when: AnvilStateChangedAnnouncement send: #stateChanged to: window.	
]

{ #category : #accessing }
SqGame >> title [ 
	^ 'SquareSquare'.
]
