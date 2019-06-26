"
I hate the name ""monad"".

I mean, I understand that the mathematicians already had a name for this concept, so the functional-programming people kept on using it. But it's a very confusing name for programmers. I wish the Haskell people had decided to call it Flatmappable or something.

Anyway, a Monad is just something with these two operations:
  - The instances understand #flatMap:.
  - The class understands #return:.

#flatMap: is just like collections' #flatCollect: (or #gather:) method - it takes a block, and the block is supposed to take an element and return another instance of the Monad.
"
Class {
	#name : #Monad,
	#superclass : #Applicative,
	#category : #'Immutable-Monads'
}

{ #category : #'as yet unclassified' }
Monad class >> pure: aValue [
	^ self return: aValue
]

{ #category : #'as yet unclassified' }
Monad class >> return: aValue [
	self subclassResponsibility.
]

{ #category : #flatmapping }
Monad >> >> m2 [
	"Haskell uses >> and pronounces it 'then'. It's convenient in Smalltalk too, though, for avoiding parentheses."
	^ self then: m2
]

{ #category : #flatmapping }
Monad >> >>= aBlockFromOutput1ToM2 [
	"Haskell uses >>= to mean flatMap (though they pronounces it 'bind'). It's convenient in Smalltalk too, though, for avoiding parentheses."
	^ self flatMap: aBlockFromOutput1ToM2
]

{ #category : #applying }
Monad >> apply: mArg [
	^ self flatMap: [ :aFunction | mArg flatMap: [ :arg | self class return: (aFunction curry value: arg)] ]
]

{ #category : #flatmapping }
Monad >> flatMap: aBlockFromOutput1ToM2 [
	self subclassResponsibility
]

{ #category : #flatmapping }
Monad >> then: m2 [
	^ self flatMap: [ :output1 | m2 ]
]
