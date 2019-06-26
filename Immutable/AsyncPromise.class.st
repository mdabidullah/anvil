"
Had to call this class AsyncPromise instead of Promise, because Squeak already has something called Promise (though it looks overly Javascripty to me).

A Promise represents a single asynchronous operation. (As opposed to an asynchronous process producing a stream of events over time - for that you'd use a Channel. A Promise is for a *single* operation.)

Sending #go to a block will fork off a new thread and return a Promise for the result.

When you need to use the result, send #await to the Promise, which will return the result (blocking your current thread if necessary).

A Promise caches its value, so you can call #await as many times as you want from various different threads, and it'll always return the same value.

Useful for all sorts of long-running operations - I/O, HTTP requests, animations, long computations, etc. Promises make it convenient to spawn them off in their own threads without making it awkward to use their results when needed (and without doing any blocking *until* needed).

Also, there are generic utilities like:
	AsyncPromise all: { p1. p2. p3 }
	AsyncPromise any: { p1. p2. p3 }
Which are common things to want to do - maybe you want to wait until several HTTP requests are all complete, or until several animations are all complete.

This isn't really a viable style of programming, though, unless your Smalltalk VM has cheap threads. (Preferably with the ability to utilize multiple cores.) Which it may not. But if it doesn't, that's something that needs to be fixed! Cheap threads are a good thing.

Also note that having lots of threads running is much less scary when you're using immutable data structures.

"
Class {
	#name : #AsyncPromise,
	#superclass : #Object,
	#instVars : [
		'isFulfilled',
		'value',
		'waitingSemaphores',
		'mutexForFulfilling'
	],
	#category : #'Immutable-Mutation'
}

{ #category : #creating }
AsyncPromise class >> all: promises [
	"Returns a Promise that will be fulfilled when all the individual promises are fulfilled."
	^ [promises collect: #await] go
]

{ #category : #creating }
AsyncPromise class >> any: promises [
	"Returns a Promise that will be fulfilled as soon as *any* of the individual promises is fulfilled.
	The promise's value will be a 2-element array containing the particular promise that finished first (so you know which one it was) and its value."
	| overallPromise |
	overallPromise := AsyncPromise new.
	promises do: [ :p | | v | [ v := p await. overallPromise fulfill: { p. v } ] fork].
	^ overallPromise
]

{ #category : #creating }
AsyncPromise class >> delay: aDuration [
	^ [ (Delay forDuration: aDuration) wait. nil ] go
]

{ #category : #accessing }
AsyncPromise >> await [
	| s |
	s := nil.
	mutexForFulfilling critical: [ isFulfilled ifFalse: [s := Semaphore new. waitingSemaphores add: s] ].
	s ifNotNil: [s wait].
	^ value
]

{ #category : #fulfilling }
AsyncPromise >> fulfill: v [
	"Sets the value (if it hasn't already been set). Note that if there are multiple threads racing to provide a value (see Promise>>any:), only the *first* will succeed. Returns true if succeeded, false if the value was already set."
	^ mutexForFulfilling critical: [
		isFulfilled ifFalse: [
			isFulfilled := true.
			value := v.
			waitingSemaphores do: [ :s | s signal ].
			waitingSemaphores := nil.
			true
		] ifTrue: [
			false
		]
	]
]

{ #category : #initializing }
AsyncPromise >> initialize [
	isFulfilled := false.
	waitingSemaphores := OrderedCollection new.
	mutexForFulfilling := Mutex new.
]

{ #category : #testing }
AsyncPromise >> isFulfilled [
	"You usually shouldn't need to call this. But *occasionally* it's useful to be able to say things like, 'If the result has already arrived, I'll use it, otherwise I won't bother.'"
	^ isFulfilled
]
