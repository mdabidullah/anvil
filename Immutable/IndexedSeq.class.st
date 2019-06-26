Class {
	#name : #IndexedSeq,
	#superclass : #Seq,
	#instVars : [
		'indexableCollection',
		'index',
		'delta'
	],
	#category : #'Immutable-Private'
}

{ #category : #'as yet unclassified' }
IndexedSeq >> calculateFirstAndRest [
	((delta > 0 and: [index <= indexableCollection size]) or: [delta < 0 and: [index >= 1]]) ifTrue: [
		cachedFirst := indexableCollection at: index.
		cachedRest := IndexedSeq new initializeWithCollection: indexableCollection index: index + delta delta: delta.
	].
]

{ #category : #'as yet unclassified' }
IndexedSeq >> initializeWithCollection: c index: i delta: d [
	indexableCollection := c.
	index := i.
	delta := d.
]
