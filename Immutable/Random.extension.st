Extension { #name : #Random }

{ #category : #'*Immutable-Collections' }
Random >> seq [
	^ [ self next ] repeatedly
]
