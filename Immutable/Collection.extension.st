Extension { #name : #Collection }

{ #category : #'*Immutable-Collections' }
Collection >> flatMap: aBlock [
	"For compatibility with Maybe and IO. The word 'collect' doesn't really make sense for those."
	^ self flatCollect: aBlock
]

{ #category : #'*Immutable-Collections' }
Collection >> foldable [
	^ SimpleFoldable new initializeForCollection: self injectMethodName: #inject:into:
]

{ #category : #'*Immutable-Collections' }
Collection >> map: aBlock [
	"For compatibility with Maybe and IO. The word 'collect' doesn't really make sense for those."
	^ self collect: aBlock
]
