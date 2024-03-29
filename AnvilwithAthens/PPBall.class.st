Class {
	#name : #PPBall,
	#superclass : #BlElement,
	#instVars : [
		'velocity'
	],
	#category : #'AnvilwithAthens-PingPong'
}

{ #category : #initialization }
PPBall >> bounceIn: aRect [
	"Move this atom one step along its velocity vector and make it bounce if it goes outside the given rectangle. Return true if it is bounced."
	| p vx vy px py bounced |

	p := self measuredBounds position.

	vx := velocity x.
	vy := velocity y.

	px := p x + vx.		py := p y + vy.

	bounced := false.

	px > aRect right ifTrue: [
		px := aRect right - (px - aRect right).
		vx := velocity x negated.
		bounced := true].
	py > aRect bottom ifTrue: [
		py :=  aRect bottom - (py - aRect bottom).
		vy := velocity y negated.
		bounced := true].
	px < aRect left ifTrue: [
		px := aRect left - (px - aRect left).
		vx := velocity x negated.
		bounced := true].
	py < aRect top ifTrue: [
		py :=  aRect top - (py - aRect top).
		vy := velocity y negated.
		bounced := true].
	self relocate: px @ py.
	bounced ifTrue: [self velocity: vx @ vy].
	^ bounced
]

{ #category : #initialization }
PPBall >> initialize [
	super initialize.
	self size: 5@5.
	self background: Color red
]

{ #category : #initialization }
PPBall >> velocity [
	^ velocity
]

{ #category : #initialization }
PPBall >> velocity: anObject [
	velocity := anObject
]
