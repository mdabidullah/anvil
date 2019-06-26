Extension { #name : #ArrayedCollection }

{ #category : #'*Immutable-Collections' }
ArrayedCollection >> fold: aMonoid [
	^ ParallelFolding arrayedCollection: self fold: aMonoid maxChunkSize: 20
]

{ #category : #'*Immutable-Collections' }
ArrayedCollection >> foldable [
	^ SimpleFoldable new initializeForCollection: self injectMethodName: #inject:into: foldMethodName: #fold:
]
