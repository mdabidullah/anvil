Class {
	#name : #TestMorph,
	#superclass : #Morph,
	#instVars : [
		'timeLast',
		'colour'
	],
	#category : #'Anvil-Prototyping-Test'
}

{ #category : #'stepping and presenter' }
TestMorph >> step [
	| timeNow delta |
	timeLast ifNil: [ timeLast := Time millisecondClockValue ].
	colour ifNil: [ colour := false ].
	timeNow := Time millisecondClockValue.
	delta := timeNow - timeLast.
	
	
	delta > 50 ifTrue: [ 
		Transcript show: delta; cr. 
		timeLast := timeNow.
		colour 
			ifTrue: [ 
				self color: Color red. 
				colour := false.
			]
			ifFalse: [ 
				self color: Color blue. 
				colour := true.
			]
		
	]
]

{ #category : #'stepping and presenter' }
TestMorph >> stepTime [
	^ 50.
]
