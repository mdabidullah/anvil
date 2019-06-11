Class {
	#name : #AnvilScheduler,
	#superclass : #Object,
	#instVars : [
		'process',
		'model',
		'running'
	],
	#category : #'Anvil-Prototype'
}

{ #category : #'initialize-release' }
AnvilScheduler >> initialize [
	| block |
	super initialize.
	running := false.
	
	block := [ model step ].
	
	process := self newProcessWithPriority: 30 
						 do: block
						 every: self minTimeBetweenRendering.
]

{ #category : #accessing }
AnvilScheduler >> maxFrameRate [ 
	^ 50 "frames per second"
]

{ #category : #accessing }
AnvilScheduler >> minTimeBetweenRendering [ 
	^ (1000 "ms" / self maxFrameRate) milliSeconds.
]

{ #category : #accessing }
AnvilScheduler >> model: aModel [
	model := aModel.
]

{ #category : #'initialize-release' }
AnvilScheduler >> newProcessWithPriority: aPriority do: aBlock every: duration [
	^ [ 
		[ | time delay |
			time := DateAndTime now.
			running ifTrue: [ aBlock value. ].
			aBlock value.
			delay := duration - (DateAndTime now - time).
			delay negative 
				ifFalse: [ delay wait ]
				ifTrue: [ "slowing process" ]
		] repeat ] forkAt: aPriority
]

{ #category : #'initialize-release' }
AnvilScheduler >> process [
	^ process.
]

{ #category : #'initialize-release' }
AnvilScheduler >> startProcess [
	running := true.
	process resume
]

{ #category : #'initialize-release' }
AnvilScheduler >> stopProcess [
	running := false.
	[ process terminate ] on: Error do: [  ]
]
