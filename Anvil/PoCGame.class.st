"
This is a simple game meant to test the live prototyping capabilities of Pharo. 

There is a single character, a square. The square can move discretely in steps, in size equal to the length of the square. DONE

Now create a drawing loop so that the canvas is redrawn whenever necessary. This is whenever the state changes.

Also we need to be able to go back in time state wise. 

Also need to be able to alter state.

Join window and view to just view.
"
Class {
	#name : #PoCGame,
	#superclass : #Object,
	#instVars : [
		'window',
		'view',
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
PoCGame >> initialize [
	model := PoCModel new.
	state := PoCState new.
	window := PoCWindow new 
		extent: (self class resolution);
		title: 'PoC'.
	view := PoCView new state: state.
	
	window root addChild: view.
	
	window root addEventHandler: (PoCEventListener new 
												model: model).
	
	model state: state.
	
	state announcer when: PoCStateChangedAnnouncement send: #stateChanged to: window.
	
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
PoCGame >> view [ 
	^ view
]

{ #category : #accessing }
PoCGame >> window [
	^ window.
]
