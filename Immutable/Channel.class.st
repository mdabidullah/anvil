"
A Channel is for communication between threads. One thread puts a value on the channel, some other thread takes it off.

The idea is that shared mutable state between threads (see the MutableReference class) is scary (because it's extremely easy to screw up, and when you do screw it up it's extremely hard to debug), but we often need *some* sort of communication between threads, so channels are a safer way to do that. A MutableReference is like a coat hook where you can put something and then take it back later; a Channel is more like a conveyor belt where you can put something and then it's whisked away and some other thread handles it.

Inside the Channel there's a queue of fixed size. (You can specify the size when you create the channel.) When the queue is empty, readers will block; when the queue is full, writers will block. (This is *useful*. You don't *want* an unbounded queue. If your writers are writing so many values that your readers can't keep up, you need to *think* about that and figure out how to fix it.)

(Instead of having writers block when the queue is full, you also have the option of making it a ""dropping"" channel that just ignores new values when the queue is full, or a ""sliding"" channel that tosses away the oldest value to make room for the new value.)

Usually you want to think of Channels as being for ""streams of events."" That is, a Channel represents an enduring connection across multiple events. If you want something to represent a single asynchronous operation, use a Promise. (Promises are better for that because they assume there'll only be one result and so they cache it, so you can have many readers all using the result. Whereas a Channel is intended for a stream of many values over time.)

Channels, like Promises, allow you to completely decouple producers from consumers. Either you're putting a value on a conveyor belt with no idea who's going to take it at the other end, or you're taking a value from a conveyor belt with no idea who put it on. That's a good thing.

If you're familiar with the Actors model and wondering how this compares: you can (more or less) think of an actor as being a thread plus a channel. But there's no general reason why you shouldn't have a thread that reads from multiple channels and/or writes to multiple channels. So better to break actors apart into two separate simpler pieces.

"
Class {
	#name : #Channel,
	#superclass : #Object,
	#instVars : [
		'buffer',
		'maxBufferSize',
		'takingIndex',
		'puttingIndex',
		'overflowStrategy',
		'semaphoreForPutters',
		'semaphoreForTakers',
		'mutexForBuffer'
	],
	#category : #'Immutable-Mutation'
}

{ #category : #creating }
Channel class >> blockingOfSize: n [ 
	^ self ofSize: n overflowStrategy: #blocking
]

{ #category : #creating }
Channel class >> droppingOfSize: n [ 
	^ self ofSize: n overflowStrategy: #dropping
]

{ #category : #examples }
Channel class >> easeInOut: fractionOfTime [
	"See http://www.robertpenner.com/easing/"
	| t |
	t := fractionOfTime * 2.
	^ t < 1
		ifTrue: [ (1 / 2) * t * t ]
		ifFalse: [ t := t - 1. (-1 / 2) * (t * (t - 2) - 1) ]
]

{ #category : #creating }
Channel class >> ofSize: n [ 
	^ self blockingOfSize: n
]

{ #category : #creating }
Channel class >> ofSize: n overflowStrategy: s [
	^ self new initializeWithMaxSize: n overflowStrategy: s
]

{ #category : #creating }
Channel class >> slidingOfSize: n [ 
	^ self ofSize: n overflowStrategy: #sliding
]

{ #category : #examples }
Channel class >> tickEvery: aDuration for: totalDuration [
	"
	| m path |
	m := Morph new openInWorld.
	path := m position -> m world center.
	(Channel tickEvery: 16 milliSeconds for: 2 seconds) mapOutput: [ :f | m position: path key + ((self easeInOut: f) * (path value - path key)) ].
	"
	| c startTime |
	c := Channel slidingOfSize: 1.
	startTime := DateAndTime now.
	[| fractionOfTime |
	 [(AsyncPromise delay: aDuration) await.
	 fractionOfTime := (DateAndTime now - startTime) / totalDuration. fractionOfTime <= 1] whileTrue: [c put: fractionOfTime asFloat]] go.
	^ c
]

{ #category : #initializing }
Channel >> initializeWithMaxSize: n overflowStrategy: s [
	maxBufferSize := n.
	overflowStrategy := s.
	buffer := Array new: n.
	takingIndex := 1.
	puttingIndex := 1.
	semaphoreForPutters := Semaphore new.
	semaphoreForTakers := Semaphore new.
	mutexForBuffer := Mutex new.
	n timesRepeat: [semaphoreForPutters signal].
]

{ #category : #'common patterns' }
Channel >> mapInput: aBlock [
	| c |
	c := Channel ofSize: maxBufferSize overflowStrategy: overflowStrategy.
	[ [ self put: (aBlock value: c take) ] repeat ] go.
	^ c
]

{ #category : #'common patterns' }
Channel >> mapOutput: aBlock [
	| c |
	c := Channel ofSize: maxBufferSize overflowStrategy: overflowStrategy.
	[ [ c put: (aBlock value: self take) ] repeat ] go.
	^ c
]

{ #category : #writing }
Channel >> put: v [
	(overflowStrategy = #dropping and: [ semaphoreForPutters isSignaled not ]) ifTrue: [ ^ self ].
	
	(overflowStrategy = #sliding and: [ semaphoreForPutters isSignaled not ]) ifTrue: [
		mutexForBuffer critical: [
			buffer at: puttingIndex put: v.
			puttingIndex := (puttingIndex rem: maxBufferSize) + 1.
			takingIndex := (takingIndex rem: maxBufferSize) + 1.
		].
		^ self
	].

	semaphoreForPutters wait.
	mutexForBuffer critical: [
		buffer at: puttingIndex put: v.
		puttingIndex := (puttingIndex rem: maxBufferSize) + 1.
	].
	semaphoreForTakers signal.
]

{ #category : #reading }
Channel >> take [
	| v |
	semaphoreForTakers wait.
	mutexForBuffer critical: [
		v := buffer at: takingIndex.
		takingIndex := (takingIndex rem: maxBufferSize) + 1.
	].
	semaphoreForPutters signal.
	^ v
]
