Class {
	#name : #Success,
	#superclass : #Either,
	#instVars : [
		'value'
	],
	#category : #'Immutable-Monads'
}

{ #category : #creating }
Success class >> withValue: v [
	^ self new initializeWithValue: v
]

{ #category : #'pattern-matching' }
Success >> ifFailure: failureBlock ifSuccess: successBlock [
	^ successBlock value: value
]

{ #category : #'pattern-matching' }
Success >> ifSuccess: successBlock ifFailure: failureBlock [
	^ successBlock value: value
]

{ #category : #'private-initialization' }
Success >> initializeWithValue: v [
	value := v.
]
