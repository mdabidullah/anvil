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

{ #category : #running }
PoCGame class >> run [ 
	<script: 'self run'>
	^ self new start
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
		extent: 800@800;
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
