"
It's very very useful to be able to take a *generic* approach to data manipulation.

It's irritating to have to create accessor methods and = and hash methods and stuff like that every time you make a new class, when really it's all just plain data. Worse, it actively thwarts code reuse. (Wasn't reuse supposed to be one of the selling points of OO?)

With this class, you can create subclasses that'll just behave like Maps. The keys will be the Symbol containing the instance-variable name.

As an example, I created a subclass of Record called SillyRecord, with three instance variables (a, b, c).

	| r |
	r := SillyRecord fromValues: { 111. 222. 333 }.
	r at: #a

Note that these are still meant to be semantically identical to other Maps. Equality comparisons don't care which class of Map you have:

	(SillyRecord from: { #a -> 1. #b -> 2. #c -> 3 }) = (Map from: { #a -> 1. #b -> 2. #c -> 3 })

And if you try to add a new key to a Record (that is, if you call #with:as: and pass in a key that isn't one of the Record's instance variables), you'll just get another kind of Map as the result:

	(SillyRecord from: { #a -> 1. #b -> 2. #c -> 3 }) with: #d as: 4

Records are convenient because they play more nicely with the rest of Smalltalk (e.g. inspectors understand what they're looking at), but they're still meant to just be generic maps.

"
Class {
	#name : #Record,
	#superclass : #Map,
	#category : #'Immutable-Collections'
}

{ #category : #creating }
Record class >> empty [
	^ self basicNew
]

{ #category : #creating }
Record class >> from: associations [
	| r |
	r := self basicNew.
	associations do: [ :a |
		r instVarAt: (self instVarIndexFor: a key asString ifAbsent: [ ^ ArrayMap from: associations ]) put: a value.
	].
	^ r
]

{ #category : #creating }
Record class >> fromValues: values [
	| r i |
	r := self basicNew.
	i := 1.
	values do: [ :v |
		r instVarAt: i put: v.
		i := i + 1.
	].
	^ r
]

{ #category : #iterating }
Record >> associationsInject: initialValue into: aBlock [
	^ (1 to: self size) inject: initialValue into: [ :total :i | | k v |
		k := (self class instVarNameForIndex: i) asSymbol.
		v := self instVarAt: i.
		aBlock value: total value: k -> v
	]
]

{ #category : #iterating }
Record >> associationsSeq [
	^ (1 to: self size) seq collect: [ :i | | k v |
		k := (self class instVarNameForIndex: i) asSymbol.
		v := self instVarAt: i.
		k -> v
	]
]

{ #category : #accessing }
Record >> at: key ifPresent: presentBlock ifAbsent: absentBlock [
	"This is here for compatibility with normal Smalltalk collections, but I recommend that you use #maybeAt: instead."
	| i |
	(key isKindOf: Symbol) ifFalse: [ ^ absentBlock value ].
	i := self class instVarIndexFor: key asString ifAbsent: [^ absentBlock value].
	^ presentBlock cull: (self instVarAt: i)
]

{ #category : #transforming }
Record >> mapValues: aBlock [
	| c |
	c := self class basicNew.
	(1 to: self size) do: [ :i | c instVarAt: i put: (aBlock cull: (self instVarAt: i) cull: ((self class instVarNameForIndex: i) asSymbol)) ].
	^ c
]

{ #category : #accessing }
Record >> size [
	^ self class instSize
]

{ #category : #'"modifying"' }
Record >> with: key as: value [
	| c |
	c := self shallowCopy.
	c instVarAt: (self class instVarIndexFor: key asString ifAbsent: [ ^ (ArrayMap from: self associationsFoldable) with: key as: value ]) put: value.
	^ c
]
