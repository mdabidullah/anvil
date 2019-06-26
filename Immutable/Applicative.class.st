"
An applicative functor is a functor that has an #apply: operation.

The idea of #apply: is to take a structure-of-functions and apply it to a structure-of-arguments, to get a structure-of-results.

"
Class {
	#name : #Applicative,
	#superclass : #Functor,
	#category : #'Immutable-Monads'
}

{ #category : #'as yet unclassified' }
Applicative class >> pure: aValue [
	self subclassResponsibility.
]

{ #category : #applying }
Applicative >> <*> otherApplicativeContainingTheArgument [
	"Using the word 'apply' reads better but requires more parentheses."
	^ self apply: otherApplicativeContainingTheArgument
]

{ #category : #applying }
Applicative >> apply: otherApplicativeContainingTheArgument [
	"F (a->b) -> F a -> F b"
	"Assumes that 'self' contains a curried block, and that otherApplicativeContainingTheArgument contains an argument for that block.
	Returns an Applicative containing the result of calling that block on the argument."
	self subclassResponsibility
]

{ #category : #mapping }
Applicative >> map: aBlock [
	"Note that every Applicative is a Functor. (That's why TApplicative 'uses' TFunctor.)
	We can implement #map: by wrapping aBlock in an applicative and then applying it."
	^ (self class pure: aBlock) <*> self
]
