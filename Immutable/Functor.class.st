"
A functor is something that understands #map:.

For collections, #map: is just #collect: - it maps each element by some block. But there are other kinds of functors that aren't collections, like Maybe and IO.

The #map: method needs to obey two laws (called the ""functor laws"", you can Google it):

	(aFunctor map: [ :elem | elem ]) = aFunctor
	((aFunctor map: b1) map: b2) = (aFunctor map: [ :elem | b2 value: (b1 value: elem) ])

In English:
  - If you map a functor by the identity function, you get back the same thing you started with.
  - If you map twice in a row (first operation 1, then operation 2), that's the same as mapping just once (by a block that does both operations).

Basically, that just means that mapping should map the ""contents"" while preserving the ""structure"".

This is important, from a software-engineering perspective, because it allows a separation-of-concerns: you don't need to tangle up ""what kind of structure-containing-elements is this"" with ""what operations are we doing to the elements"".

For example, you would never write a method like this:

	collectSquares: numbers
		| c |
		c := OrderedCollection new.
		self do: [ :n | c add: n * n ].
		^ c

Instead, there's a #collect: method and a #squared method, so you can just write:

	numbers collect: #squared

The #collectSquares method pointlessly tangles up the structure with the operation.

So the idea of the Functor class is just that that same idea applies to more than just collections. There's also things like Maybe, Either, IO, etc. For example, we don't want to have to write methods like this:

	squareOrNot: maybeNumber
		^ maybeNumber
			ifAbsent: [ nothing ]
			ifPresent: [ :n | n * n ]

Just have the #squared method and then call

	maybeNumber map: #squared

"
Class {
	#name : #Functor,
	#superclass : #Object,
	#category : #'Immutable-Monads'
}

{ #category : #mapping }
Functor >> map: aBlock [
	self subclassResponsibility
]
