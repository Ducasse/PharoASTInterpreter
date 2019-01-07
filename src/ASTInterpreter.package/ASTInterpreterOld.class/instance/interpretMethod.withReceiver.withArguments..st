visiting
interpretMethod: aMethod withReceiver: anObject withArguments: aCollection
	aMethod isPrimitive ifTrue: [ ^ aMethod valueWithReceiver: anObject arguments: aCollection asArray ].
	"Method is not primitive"
	self stack push: (ASTIntContext new receiver: anObject).
	[ ^ aMethod isBlock
		ifTrue: [ self evaluateBlock: aMethod ]
		ifFalse: [ self evaluateMethod: aMethod ]
	] ensure: [
		self mustReturn: false.
		self returnValue: nil.
		self stack pop].