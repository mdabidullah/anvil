"
Code to Test the SStepper in playground

stepper := SStepper new.

view := SStepperView new. 

window := BlSpace new
	extent: AnvilGame resolution;
	title: 'Stepper'.

window addChild: view.

stepper steppingObject: view.

window show.

stepper startProcess.

Finally use 'stepper terminateProcess' to stop the process from continuing indefinitely.
"
Class {
	#name : #SStepper,
	#superclass : #Object,
	#instVars : [
		'process',
		'steppingObject'
	],
	#category : #'Anvil-Prototyping-Stepper'
}

{ #category : #accessing }
SStepper >> name [
	^ 'SStepper'
]

{ #category : #'instance creation' }
SStepper >> newProcessAt: priority do: aBlock every: duration [
	^ [ 
		[ | time delay |
		time := DateAndTime now.
		aBlock value.
		delay := duration - (DateAndTime now - time).
		delay negative 
			ifFalse: [ delay wait ]
			ifTrue: [ "slowing process" ]
		 ] repeat ] forkAt: priority named: self name.

	"See BlockClosure>>newProcess for an alternative implementation that does not start the process immediately"
]

{ #category : #accessing }
SStepper >> process [
	^ process.
]

{ #category : #accessing }
SStepper >> startProcess [
	process resume
]

{ #category : #'as yet unclassified' }
SStepper >> steppingObject [
	^ steppingObject 
]

{ #category : #'as yet unclassified' }
SStepper >> steppingObject: aObject [
	steppingObject := aObject.
	process := self newProcessAt: 50 do: [ steppingObject step ] every: 20 milliSeconds.
]

{ #category : #accessing }
SStepper >> terminateProcess [

	[ process terminate ] on: Error do: [ ].
]
