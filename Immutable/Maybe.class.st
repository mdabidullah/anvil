"
It's insane to have a variable that might point to an actual thing or might point to nil. That's just a recipe for bugs - you'll often forget to handle the nil case.

So here's something like Haskell's ""Maybe"" type. To represent the absence of a thing, you use ""nothing"". (This package creates a global variable named ""nothing"", which is just a singleton instance of the Nothing class.) To represent the presence of a thing, you use an instance of Something.

HashMaps and Vectors (and ordinary Smalltalk Dictionaries and SequenceableCollections too, for that matter) have a #maybeAt: method. (I wish I could just call it #at:. It's ridiculous that the method with the good short easy name is the unsafe one.) Seqs have #maybeFirst and #maybeRest. And of course you'll want to return a Maybe from all of your own methods that formerly returned either-a-thing-or-nil.

You use a Maybe like this:

	| h |
	h := HashMap from: { { 1. 'one' }. { 2. 'two' } }.
	(h maybeAt: 2) ifPresent: [ :v | v ] ifAbsent: [ 'nothing here' ].   ""returns 'two'""
	(h maybeAt: 3) ifPresent: [ :v | v ] ifAbsent: [ 'nothing here' ].   ""returns 'nothing here'""

The point of this is:
  1. Unlike #at:, you're reminded to handle both cases. You won't just forget to handle the absent case and get an error. (You might just make the ifAbsent: block say ""self error: 'I am lazy'"", but at least then it's more in-your-face.)
  2. Unlike #at:IfPresent:IfAbsent: (which does solve problem #1), it's more general. You can pass a Maybe around (as opposed to needing to put IfPresent:IfAbsent: blocks on every method that might need to deal with a null case - which, realistically, you just won't do, you'll give up and use a nil and then you're back to problem #1).

Of course, the downside is the performance cost of creating the Something object. For inner loops maybe you'll just want to do the unsafe thing. But most of the time you can probably afford to use a Maybe.

----

Extra Stuff That You Don't Need To Understand In Order To Get The Benefits Described Above

Maybes also have a #map: method. Think of it as being analogous to #collect:. (In fact, I added #map: to Collection too, for compatibility.) Or sorta roughly analogous to #ifNotNil:. So instead of writing
	argle bargle ifNotNil: [ :obj | obj whatever ]
you'd instead write
	argle bargle map: [ :obj | obj whatever ]
which is much safer, because you can't accidentally forget to do it and just write ""argle bargle whatever""), and because #map: returns another Maybe so you *still* eventually have to explicitly say what to do in the absent case.

Note that the block that you pass into #map: is expected to just return a valid result, not a Maybe. That's why Maybes also have a #flatMap: method, which is not a great name, but in Haskell they call it ""bind"", which is even worse. In Haskell it's also called >>=, which is worse yet, but it's convenient in Smalltalk too for the sake of avoiding parentheses. The idea is that you might want a whole call chain where each step in the chain returns a Maybe. (Remember how I just said that #map: expects a block that just returns a valid result?)

So if the #whatever method used above might not actually return a value, you might rename it to #maybeWhatever and make it return a Maybe, and then you'd have to write:

	argle bargle flatMap: [ :obj | obj maybeWhatever ]

If it helps, think of the relationship between #map: and #flatMap: as being analogous to the relationship between #collect: and #flatCollect:. (If it doesn't help, don't think of that.)

"
Class {
	#name : #Maybe,
	#superclass : #Monad,
	#category : #'Immutable-Monads'
}

{ #category : #creating }
Maybe class >> return: aValue [
	^ Something withValue: aValue
]

{ #category : #comparing }
Maybe >> = other [
	^ self class = other class and: [
		self ifPresent: [:v1 | other ifPresent: [:v2 | v1 = v2 ] ifAbsent: [false] ] ifAbsent: [ other ifPresent: [false] ifAbsent: [true] ]
	]
]

{ #category : #flatmapping }
Maybe >> flatMap: aBlockFromMyValueToAnotherMaybe [
	^ self
		ifPresent: [:v | aBlockFromMyValueToAnotherMaybe value: v]
		ifAbsent: [nothing]

]

{ #category : #comparing }
Maybe >> hash [
	^ self ifPresent: [ :v | 'Something' hash bitXor: v hash ] ifAbsent: [ 'Nothing' hash ]
]

{ #category : #'pattern-matching' }
Maybe >> ifAbsent: absentBlock [
	^ self ifAbsent: absentBlock ifPresent: [:v | v]
]

{ #category : #'pattern-matching' }
Maybe >> printOn: aStream [
	self
		ifPresent: [ :v | aStream nextPutAll: 'Something withValue: ('; print: v; nextPutAll: ')' ]
		ifAbsent: [ aStream nextPutAll: 'nothing' ].
]
