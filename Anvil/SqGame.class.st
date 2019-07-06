Class {
	#name : #SqGame,
	#superclass : #AnvilGame,
	#category : #'Anvil-SquareSquare'
}

{ #category : #accessing }
SqGame >> initialize [	
	model := SqModel new.
	state := AnvilState new.
	window := AnvilWindow new 
		extent: (self class resolution);
		title: self title.
	window
		position: 705@20.
	view := SqView new state: state.
	
	window addChild: view.
	
	window root addEventHandler: (AnvilEventListener new 
												model: model).
	
	model state: state.
	
	state announcer when: AnvilStateChangedAnnouncement send: #stateChanged to: window.	
]

{ #category : #accessing }
SqGame >> title [ 
	^ 'SquareSquare'.
]
