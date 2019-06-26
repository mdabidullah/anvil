"
Here's Rich Hickey's talk about transducers:

https://www.youtube.com/watch?v=6mTbuzafcII

A ""transducer"" is just a block that takes a reducingBlock and returns another reducingBlock. Where ""reducingBlock"" is one of those blocks that you pass into #inject:into:.

You're better off watching the video, but the basic idea is that we can implement methods like #collect: and #select: (and others like that) on top of #inject:into:, by using a transducer to transform the reducingBlock.

For examples, look at the users of TransducingFoldable.
"
Class {
	#name : #Transducer,
	#superclass : #Object,
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
Transducer class >> concatenating [
	^ [ :injectBlock | [ :result :each | each inject: result into: injectBlock ] ]
]

{ #category : #'as yet unclassified' }
Transducer class >> filtering: filteringBlock [
	^ [ :injectBlock | [ :result :each | (filteringBlock value: each) ifTrue: [injectBlock value: result value: each] ifFalse: [result] ] ]
]

{ #category : #'as yet unclassified' }
Transducer class >> identity [
	^ [ :injectBlock | injectBlock ]
]

{ #category : #'as yet unclassified' }
Transducer class >> mapping: mappingBlock [
	^ [ :injectBlock | [ :result :each | injectBlock value: result value: (mappingBlock value: each) ] ]
]
