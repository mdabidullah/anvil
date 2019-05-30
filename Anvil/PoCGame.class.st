"
This is a simple game meant to test the live prototyping capabilities of Pharo. 

There is a single character, a square. The square can move discretely in steps, in size equal to the length of the square. 
"
Class {
	#name : #PoCGame,
	#superclass : #Object,
	#instVars : [
		'window',
		'state',
		'model'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #'as yet unclassified' }
PoCGame class >> resolution [
	^ 768@432
]

{ #category : #running }
PoCGame class >> run [ 
	<script>
	| model state window view|
	model := PoCModel new.
state := PoCState new.
view := PoCView new state: state.
window := PoCWindow new 
	extent: 768@432;
	title: 'PoC'.

window view: view.

window root addEventHandler: (PoCEventListener new 
											model: model).

	
model state: state.
	
model announcer when: PoCStateChangedAnnouncement send: #stateChanged to: window.
	
window show.
]

{ #category : #accessing }
PoCGame >> event: aEvent [
	((Dictionary new
		at: (Character arrowDown asInteger) put: [ model event: #Down ];
		at: (Character arrowLeft asInteger) put: [ model event: #Left ];
		at: (Character arrowRight asInteger) put: [ model event: #Right ];
		at: (Character arrowUp asInteger) put: [ model event: #Up ];
		at: (Character space asInteger) put: [ model event: #Space ];
		at: (Character cr asInteger) put: [ model event: #Enter ];
		yourself) at: (aEvent char asInteger)) value.
]

{ #category : #accessing }
PoCGame >> initialize [
	model := PoCModel new.
	state := PoCState new.
	window := BlSpace new 
		extent: (self class resolution);
		title: 'PoC'.
	
	window root addEventHandler: (PoCEventListener new 
												game: self).
	
	window root addChild: (PoCView new state: state).
		
	
	model state: state.
	
	model announcer when: PoCStateChangedAnnouncement send: #stateChanged to: window.
	
	window show.
]

{ #category : #accessing }
PoCGame >> model [ 
	^ model
]

{ #category : #accessing }
PoCGame >> start [
]

{ #category : #accessing }
PoCGame >> state [ 
	^ state
]

{ #category : #accessing }
PoCGame >> window [ 
	^ window
]
