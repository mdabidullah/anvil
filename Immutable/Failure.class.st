Class {
	#name : #Failure,
	#superclass : #Either,
	#instVars : [
		'value'
	],
	#category : #'Immutable-Monads'
}

{ #category : #creating }
Failure class >> withValue: v [
	^ self new initializeWithValue: v
]

{ #category : #'pattern-matching' }
Failure >> ifFailure: failureBlock ifSuccess: successBlock [
	^ failureBlock value: value
]

{ #category : #'pattern-matching' }
Failure >> ifSuccess: successBlock ifFailure: failureBlock [
	^ failureBlock value: value
]

{ #category : #'private-initialization' }
Failure >> initializeWithValue: v [
	value := v.
]
