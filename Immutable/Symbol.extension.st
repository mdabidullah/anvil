Extension { #name : #Symbol }

{ #category : #'*Immutable-Collections' }
Symbol >> curry [
	^ self
]

{ #category : #'*Immutable-Collections' }
Symbol >> value: anObject value: argumentObject [
	"I have no idea why Pharo would have defined #value: but not #value:value: or #value:value:value:.
	This way I can write things like:
	(1 to: 100) inject: 0 into: #+
	"
	^anObject perform: self with: argumentObject.
]

{ #category : #'*Immutable-Collections' }
Symbol >> value: anObject value: argumentObject value: argumentObject2 [
	"I have no idea why Pharo would have defined #value: but not #value:value: or #value:value:value:."
	^anObject perform: self with: argumentObject with: argumentObject2.
]
