"
I am for debugging an Anvil game
"
Class {
	#name : #AnvilSession,
	#superclass : #Object,
	#instVars : [
		'session'
	],
	#category : #'Anvil-Base'
}

{ #category : #'as yet unclassified' }
AnvilSession >> previousEvent [
	"rewind context back to the last input/event"
]
