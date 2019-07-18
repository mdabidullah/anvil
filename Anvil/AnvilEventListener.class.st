"
I am a EventListener, I pass on events to AnvilModel.
"
Class {
	#name : #AnvilEventListener,
	#superclass : #BlElementEventListener,
	#instVars : [
		'model'
	],
	#category : #'Anvil-Base'
}

{ #category : #anvil }
AnvilEventListener >> keystrokeEvent: aEvent [
	((Dictionary new
		at: (Character arrowDown asInteger) put: [ model event: #Down ];
		at: (Character arrowLeft asInteger) put: [ model event: #Left ];
		at: (Character arrowRight asInteger) put: [ model event: #Right ];
		at: (Character arrowUp asInteger) put: [ model event: #Up ];
		at: (Character space asInteger) put: [ model event: #Space ];
		at: (Character cr asInteger) put: [ model event: #Enter ];
		yourself) at: (aEvent char asInteger) ifAbsent: [] ) value.
]

{ #category : #anvil }
AnvilEventListener >> model: aModel [
	model := aModel.
]
