"
I am the root class which creates the entire game. 
"
Class {
	#name : #AnvilGame,
	#superclass : #Object,
	#instVars : [
		'window',
		'view',
		'state',
		'model'
	],
	#category : #'Anvil-Base'
}

{ #category : #'as yet unclassified' }
AnvilGame class >> resolution [
	^ 768@432
]

{ #category : #running }
AnvilGame class >> run [ 
	<script>
	| model state window view|
	model := AnvilModel new.
state := AnvilState new.
view := AnvilView new state: state.
window := AnvilWindow new 
	extent: 768@432;
	title: 'PoC'.

window view: view.

window root addEventHandler: (AnvilEventListener new 
											model: model).

	
model state: state.
	
model announcer when: AnvilStateChangedAnnouncement send: #stateChanged to: window.
	
window show.
]

{ #category : #anvil }
AnvilGame >> initialize [
	"Example implementation, use your own classes as needed."
	
	"
	model := AnvilModel new.
	state := AnvilState new.
	window := AnvilWindow new 
		extent: (self class resolution);
		title: self title;
		position: 705@20.
	view := AnvilView new state: state.
	
	window addChild: view.
	
	window root addEventHandler: (AnvilEventListener new 
												model: model).
	
	model state: state.
	view model: model.
	state announcer when: AnvilStateChangedAnnouncement send: #stateChanged to: window.
	"
	self subclassResponsibility.
	
]

{ #category : #anvil }
AnvilGame >> model [ 
	^ model
]

{ #category : #anvil }
AnvilGame >> start [
	window show.
	window
		position: 705@20.
]

{ #category : #anvil }
AnvilGame >> state [ 
	^ state
]

{ #category : #anvil }
AnvilGame >> title [ 
	self subclassResponsibility.
]

{ #category : #anvil }
AnvilGame >> update [ 
	view update.
]

{ #category : #anvil }
AnvilGame >> view [ 
	^ view
]

{ #category : #anvil }
AnvilGame >> window [
	^ window.
]
