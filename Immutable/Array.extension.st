Extension { #name : #Array }

{ #category : #'*Immutable-Collections' }
Array >> copyAndAppend: element [
	| a |
	a := Array new: self size + 1.
	a replaceFrom: 1 to: self size with: self startingAt: 1.
	a at: self size + 1 put: element.
	^ a
]

{ #category : #'*Immutable-Collections' }
Array >> copyAndInsert: element atIndex: index [
	| a |
	a := Array new: self size + 1.
	a replaceFrom: 1 to: index - 1 with: self startingAt: 1.
	a replaceFrom: index + 1 to: a size with: self startingAt: index.
	a at: index put: element.
	^ a
]

{ #category : #'*Immutable-Collections' }
Array >> copyAndRemoveIndex: index [
	| a |
	a := Array new: self size - 1.
	a replaceFrom: 1 to: index - 1 with: self startingAt: 1.
	a replaceFrom: index to: a size with: self startingAt: index + 1.
	^ a

]

{ #category : #'*Immutable-Collections' }
Array >> copyWith: index as: element [
	^ self shallowCopy at: index put: element; yourself
]
