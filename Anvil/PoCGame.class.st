"
This is a simple game meant to test the live prototyping capabilities of Pharo. 

There is a single character, a square. The square can move discretely in steps, in size equal to the length of the square. DONE

Whenever state is changed the frame is redrawn. Whenever the user asks redraw the frame. DONE

Hi, I am looking for a way to know when a Class has been changed, programmatically. I have a subclass of BlElement, and I'd like this subclass to redraw whenever I change the `#drawOnSpartaCanvas:` method. When I edit the method and accept the change in Calypso, I want the running version of that subclass to update by running `self invalidate`. I have seen something similar done in a package called `AthensSketch`. `AthensSketch` comes bundled with its own editor, when you make a change on its editor it has mechanisms in place to update the live version of the code. I could copy that approach but I'd have to learn about Calypso's code and make modifications. It would be simpler, if there was some way to observe a class for changes or if a class could observe itself for changes, and when a change does happen a method is called to update the object. 

Also we need to be able to go back in time state wise. 

Also need to be able to alter state.

"
Class {
	#name : #PoCGame,
	#superclass : #Object,
	#instVars : [
		'window',
		'view',
		'state',
		'model',
		'scheduler'
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
	
model announcer when: AnvilStateChangedAnnouncement send: #stateChanged to: window.
	
window show.
]

{ #category : #accessing }
PoCGame >> initialize [
	model := PoCModel new.
	state := PoCState new.
	scheduler := PoCScheduler new.
	window := PoCWindow new 
		extent: (self class resolution);
		title: 'PoC'.
	view := PoCView new.
	view state: state.
	model state: state.
	scheduler model: model.
	"view model: model."
	window addChild: view.
	
	window root addEventHandler: (PoCEventListener new 
												model: model).
	
	
	state announcer when: AnvilStateChangedAnnouncement send: #stateChanged to: window.
	
]

{ #category : #accessing }
PoCGame >> model [ 
	^ model
]

{ #category : #accessing }
PoCGame >> start [
	window show.
	scheduler startProcess.
]

{ #category : #accessing }
PoCGame >> state [ 
	^ state
]

{ #category : #accessing }
PoCGame >> update [ 
	view update.
]

{ #category : #accessing }
PoCGame >> view [ 
	^ view
]

{ #category : #accessing }
PoCGame >> window [
	^ window.
]
