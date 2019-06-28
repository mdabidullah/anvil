"
PoCView does not have a drawing loop. A drawing loop could be created with: 

	initialize
	super initialize.
	
	self enqueueTask: (BlRepeatedTaskAction new delay: 16 milliSeconds; 
															 action: [ self step ]).

The function step would be responsible for calling `self invalidate`. `invalidate` should only be called when necessary for performance. A variable to keep track of whether a redraw is necessary could be created. 
"
Class {
	#name : #AnvilView,
	#superclass : #BlElement,
	#instVars : [
		'state',
		'element'
	],
	#category : #'Anvil-Base'
}

{ #category : #drawing }
AnvilView >> drawOnSpartaCanvas: aCanvas [
	self subclassResponsibility.
]

{ #category : #anvil }
AnvilView >> initialize [
	super initialize.

	self size: AnvilGame resolution.
	
	SystemAnnouncer uniqueInstance when: MethodModified do: [ :methodModified | methodModified method selector == #drawOnSpartaCanvas: ifTrue: self update ].
]

{ #category : #anvil }
AnvilView >> state: aState [
	state := aState.
]

{ #category : #anvil }
AnvilView >> unsubscribe [
	SystemAnnouncer uniqueInstance unsubscribe: self. 
]

{ #category : #anvil }
AnvilView >> update [
	self invalidate.
]
