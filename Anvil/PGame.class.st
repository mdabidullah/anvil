"
I am a simple game meant to test the capabilities of of Anvil. I can move a simple shape around based on user input.
"
Class {
	#name : #PGame,
	#superclass : #AnvilGame,
	#category : #'Anvil-Prototype'
}

{ #category : #accessing }
PGame >> initialize [
	model := PModel new.
	state := AnvilState new.
	window := AnvilWindow new 
		extent: (self class resolution);
		title: self title.
	view := PView new state: state.
	
	window addChild: view.
	
	window root addEventHandler: (AnvilEventListener new 
												model: model).
	
	model state: state.
	
	state announcer when: AnvilStateChangedAnnouncement send: #stateChanged to: window.
]

{ #category : #accessing }
PGame >> title [ 
	^ 'Prototype'.
]
