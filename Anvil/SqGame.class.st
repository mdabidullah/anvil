Class {
	#name : #SqGame,
	#superclass : #Object,
	#instVars : [
		'model',
		'state',
		'window',
		'view'
	],
	#category : #'Anvil-SquareSquare'
}

{ #category : #'as yet unclassified' }
SqGame class >> resolution [
	^ 768@432
]

{ #category : #anvil }
SqGame >> initialize [
	model := SqModel new.
	state := SqState new.
	window := SqWindow new 
		extent: (self class resolution);
		title: 'PoC'.
	view := SqView new state: state.
	view model: model.
	model state: state.
	
	window addChild: view.
	
	window root addEventHandler: (SqEventListener new 
												model: model).
	
	state announcer when: SqStateChangedAnnouncement send: #stateChanged to: window.
	
]

{ #category : #anvil }
SqGame >> model [ 
	^ model
]

{ #category : #anvil }
SqGame >> start [
	window show.
]

{ #category : #anvil }
SqGame >> state [ 
	^ state
]

{ #category : #anvil }
SqGame >> update [ 
	view update.
]

{ #category : #anvil }
SqGame >> view [ 
	^ view
]

{ #category : #anvil }
SqGame >> window [
	^ window.
]
