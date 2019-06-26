"
Sorta like Haskell's IO type.

I'm not really sure whether this class will be valuable in Smalltalk while the entire rest of the system is still imperative. But still, it might be nice to have around, to see if it might be possible to carve out a sane little corner of the universe where effects are nicely wrapped and explicit.

The idea is that an IO action is a *description* of a mutation/side-effect. (The instance of IO simply contains a block which, when executed, will have that side effect.) Creating an IO does *not* actually *do* anything; nothing will be done until the #run method is called.

An IO action has a ""result"" value, which is just the result of calling the block. This is important when chaining actions together to make a composite action (see below).

There are a few ways to create an IO action:

	""Creates an action that (when run) will call that block. This is how you interoperate with the rest of Smalltalk.""
	IO createWithProcedure: [someObject doSomething]
	
	""Creates an action that doesn't actually do anything when run, it just returns someValue as its result.""
	IO return: someValue
	
	""Creates a composite action which, when run, will run io1, pass its result into the block, and then run the IO returned by the block.""
	io1 >>= [ :result1 | result1 someMethodThatWillReturnAnotherIO ]
	
	""Creates an action that runs io1 in a separate thread.""
	io1 fork

Remember, none of the above lines of code will actually *do* anything; each one just returns an IO action that you can call #run on.

The point of all of this is to be very very explicit about where the scary effects-that-modify-the-universe are happening. Never write a method that has a side effect; just return one of these IO actions (which your caller can then chain together with other actions to make a bigger composite action, and return that to *his* caller, etc.). Ideally your entire program ends up being a giant pure function that simply computes a big composite action... and then #run is called once, at the very top.

And of course you try to avoid dealing with IO actions at all - it's much better to write as much of your program as possible as pure functions operating on immutable data structures (like HashMap and Vector and so on). IO actions are much more awkward to deal with than ordinary functions, because they have to be chained together in this explicitly linear way. But it's still better to have this explicit linear chaining than to rely on imperative methods that have side effects - those are linear too (since time is linear), it's just much harder to follow because the effects are implicit rather than explicit.

"
Class {
	#name : #IO,
	#superclass : #Monad,
	#instVars : [
		'procedure'
	],
	#category : #'Immutable-Monads'
}

{ #category : #creating }
IO class >> createWithProcedure: aBlock [
	^ self new initializeWithProcedure: aBlock
]

{ #category : #combining }
IO class >> parallel: ios [
	"[IO a] -> IO Promise [a]"
	^ (IO sequential: (ios seq map: #fork)) map: [ :promises | AsyncPromise all: promises ]
]

{ #category : #creating }
IO class >> return: aValue [
	^ self createWithProcedure: [ aValue ]
]

{ #category : #combining }
IO class >> sequential: ios [
	"[IO a] -> IO [a]"
	^ ios seq
		ifEmpty: [ IO return: List empty ]
		ifNotEmpty: [ :firstIO :restOfIOs | firstIO >>= [ :x | (IO sequential: restOfIOs) >>= [ :xs | IO return: (xs cons: x) ] ] ]

]

{ #category : #flatmapping }
IO >> flatMap: aBlockFromOutput1ToIO2 [
	^ IO createWithProcedure: [ | output1 io2 |
		output1 := self run.
		io2 := aBlockFromOutput1ToIO2 value: output1.
		io2 run
	]
]

{ #category : #transforming }
IO >> fork [
	^ IO createWithProcedure: [ [self run] go ]
]

{ #category : #'private-initialization' }
IO >> initializeWithProcedure: aBlock [
	procedure := aBlock.
]

{ #category : #running }
IO >> run [
	^ procedure value
]
