"
An Either is like a Maybe, except that the Failure case contains a value (like an error message). So when you #map: a Success it'll get mapped, but when you #map: a Failure it doesn't map the error value.

Just like with Maybe, the point of this is that when you have an operation that might succeed or might fail, you're just asking for bugs if you write a method that just directly returns the actual result of the operation (in the successful case, and presumably throws an exception in the failure case), because you're going to forget to handle the exception.

Instead, you can return an Either (i.e. either a Success or a Failure), so that you can't accidentally forget to handle the failure case.

And then when you want to chain together a whole bunch of operations and propagate any errors through (so that if any of the operations fails, the whole chain ends up with that error value), you can use #map: or #flatMap:.

"
Class {
	#name : #Either,
	#superclass : #Monad,
	#category : #'Immutable-Monads'
}

{ #category : #creating }
Either class >> return: aValue [
	^ Success withValue: aValue
]

{ #category : #flatmapping }
Either >> flatMap: aBlockFromMyValueToAnotherEither [
	^ self
		ifSuccess: [:v | aBlockFromMyValueToAnotherEither value: v]
		ifFailure: [:v | self]

]

{ #category : #printing }
Either >> printOn: aStream [
	self
		ifSuccess: [ :v | aStream nextPutAll: 'Success withValue: ('; print: v; nextPutAll: ')' ]
		ifFailure: [ :v | aStream nextPutAll: 'Failure withValue: ('; print: v; nextPutAll: ')' ].
]
