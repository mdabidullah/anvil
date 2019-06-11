"
This is a simple game meant to test the live prototyping capabilities of Pharo. 

There is a single character, a square. The square can move discretely in steps, in size equal to the length of the square. DONE

Whenever state is changed the frame is redrawn. Whenever the user asks redraw the frame. DONE

Hi, I am looking for a way to know when a Class has been changed, programmatically. I have a subclass of BlElement, and I'd like this subclass to redraw whenever I change the `#drawOnSpartaCanvas:` method. When I edit the method and accept the change in Calypso, I want the running version of that subclass to update by running `self invalidate`. I have seen something similar done in a package called `AthensSketch`. `AthensSketch` comes bundled with its own editor, when you make a change on its editor it has mechanisms in place to update the live version of the code. I could copy that approach but I'd have to learn about Calypso's code and make modifications. It would be simpler, if there was some way to observe a class for changes or if a class could observe itself for changes, and when a change does happen a method is called to update the object. 

Also we need to be able to go back in time state wise. 

Also need to be able to alter state.

"
Class {
	#name : #AnvilGame,
	#superclass : #Object,
	#instVars : [
		'window',
		'view',
		'state',
		'model',
		'scheduler'
	],
	#category : #'Anvil-Prototype'
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

{ #category : #accessing }
AnvilGame >> initialize [
	model := AnvilModel new.
	state := AnvilState new.
	scheduler := AnvilScheduler new.
	window := AnvilWindow new 
		extent: (self class resolution);
		title: 'PoC'.
	view := AnvilView new.
	view state: state.
	model state: state.
	scheduler model: model.
	window game: self.
	"view model: model."
	window addChild: view.
	
	window root addEventHandler: (AnvilEventListener new 
												model: model).
	
	
	state announcer when: AnvilStateChangedAnnouncement send: #stateChanged to: window.
	
]

{ #category : #accessing }
AnvilGame >> model [ 
	^ model
]

{ #category : #accessing }
AnvilGame >> quit [
	view unsubscribe.
	scheduler stopProcess.
	
]

{ #category : #accessing }
AnvilGame >> start [
	window show.
	"scheduler startProcess."
]

{ #category : #accessing }
AnvilGame >> state [ 
	^ state
]

{ #category : #accessing }
AnvilGame >> update [ 
	view update.
]

{ #category : #accessing }
AnvilGame >> view [ 
	^ view
]

{ #category : #accessing }
AnvilGame >> window [
	^ window.
]
