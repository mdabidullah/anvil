"
Haskell calls this State, but it's really a state-processing function.

The idea is that we want to do some sort of computation involving state. The computation is made up of a chain of operations. In normal imperative programming, it'd look like this:

	result1 := op1 value.
	result2 := op2 value.
	result3 := op3 value.
	result4 := op4 value.

Each operation can return a result, but can also modify the state. For example, when working with a stack, it's very natural to want a ""pop"" operation that returns the top element of the stack and also removes it from the stack.

But of course we want to do functional programming. We want to work with immutable values. We don't actually want to *mutate* the state object. We want each operation to take the old state as an argument, and return both the result of the operation and also the new state, so that we can pass that new state into the next operation.

So, OK, fine, we can have each operation be a function that takes oldState and returns { result. newState }. That part's easy. The problem is that it's irritating to have to explicitly pass the newState into the next operation:

	result1AndState1 := op1 value: state0.
	result2AndState2 := op2 value: (result1AndState1 at: 2).
	result3AndState3 := op3 value: (result2AndState2 at: 2).
	result4AndState4 := op4 value: (result3AndState3 at: 2).

All of that passing-in-the-previous-state is pure boilerplate. We should be able to factor that out. So that's what this class does.

"
Class {
	#name : #StateProcessor,
	#superclass : #Monad,
	#instVars : [
		'blockFromOldStateToResultAndNewState'
	],
	#category : #'Immutable-Monads'
}

{ #category : #'as yet unclassified' }
StateProcessor class >> return: aValue [
	^ self new initializeWithBlock: [ :st | { aValue. st } ]
]

{ #category : #'as yet unclassified' }
StateProcessor class >> withBlock: aFunctionFromStateToResultAndState [
	^ self new initializeWithBlock: aFunctionFromStateToResultAndState
]

{ #category : #flatmapping }
StateProcessor >> flatMap: aBlock [
	^ self class new initializeWithBlock: [ :oldState | | result1AndNewState1 result1 newState1 |
		result1AndNewState1 := self runState: oldState.
		"I really wish Smalltalk could do destructuring."
		result1 := result1AndNewState1 at: 1.
		newState1 := result1AndNewState1 at: 2.
		(aBlock value: result1) runState: newState1
	]
]

{ #category : #'private-initialization' }
StateProcessor >> initializeWithBlock: f [
	blockFromOldStateToResultAndNewState := f.
]

{ #category : #running }
StateProcessor >> runState: oldState [
	"Returns { result. newState }."
	^ blockFromOldStateToResultAndNewState value: oldState
]
