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
	model := PoCModel new.
	state := PoCState new.
	window := PoCWindow new 
		extent: (self class resolution);
		title: 'PoC'.
	view := PoCView new state: state.
	
	window addChild: view.
	
	window root addEventHandler: (PoCEventListener new 
												model: model).
	
	model state: state.
	
	state announcer when: PoCStateChangedAnnouncement send: #stateChanged to: window.
	
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
