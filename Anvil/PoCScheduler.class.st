Class {
	#name : #PoCScheduler,
	#superclass : #Object,
	#instVars : [
		'process',
		'managedObject',
		'model'
	],
	#category : #'Anvil-ProofOfConcept'
}

{ #category : #'initialize-release' }
PoCScheduler >> initialize [
	super initialize.
	
	process := self newProcessWithPriority: 30 
						 do: [ model step ] 
						 every: self minTimeBetweenRendering.
]

{ #category : #accessing }
PoCScheduler >> maxFrameRate [ 
	^ 50 "frames per second"
]

{ #category : #accessing }
PoCScheduler >> minTimeBetweenRendering [ 
	^ (1000 "ms" / self maxFrameRate) milliSeconds.
]

{ #category : #accessing }
PoCScheduler >> model: aModel [
	model := aModel.
]

{ #category : #'initialize-release' }
PoCScheduler >> newProcessWithPriority: aPriority do: aBlock every: duration [
	^ [ 
		[ | time delay |
			time := DateAndTime now.
			aBlock value.
			delay := duration - (DateAndTime now - time).
			delay negative 
				ifFalse: [ delay wait ]
				ifTrue: [ "slowing process" ]
		] repeat ] forkAt: aPriority
]

{ #category : #'initialize-release' }
PoCScheduler >> process [
	^ process.
]

{ #category : #'initialize-release' }
PoCScheduler >> startProcess [
	process resume
]

{ #category : #'initialize-release' }
PoCScheduler >> terminateProcess [
	[ process terminate ] on: Error do: [  ]
]
