visiting
visitMessageNode: aRBMessageNode 
	| concreteReceiver method concreteArguments |
	concreteReceiver := self interpret: aRBMessageNode receiver.
	concreteArguments :=	aRBMessageNode arguments collect: [:arg | self interpret: arg ].

	[((concreteReceiver isKindOf: ASTIntBlockContext) and: [
		(aRBMessageNode selector = #value) or: [
			(aRBMessageNode selector = #value:) or: [
				(aRBMessageNode selector = #value:value:) or: [
					(aRBMessageNode selector = #value:value:value:) or: [
						(aRBMessageNode selector = #value:value:value:value:) or: [
							(aRBMessageNode selector = #valueWithArguments:)
						]
					]
				]
			]
		]
	])
		ifTrue: [
			self contextStack push: concreteReceiver.
			self contextStack top argumentsValues: concreteArguments.
			^ self evaluateBlock: concreteReceiver blockASTNode.
		].
	self contextStack push: (ASTIntContext new
		receiver: concreteReceiver;
		argumentsValues: concreteArguments;
		parentASTIntContext: self contextStack top).
	method := concreteReceiver class lookupSelector: aRBMessageNode selector.
	(concreteReceiver isKindOf: ASTIntBlockContext) ifTrue: [ 
		"A message different than those captured above was sent to a block.
		But blocks are represented by instances of ASTIntBlockContext, so naively looking up the method in the concrete receiver's class would look up in the ASTIntBLockContext class, and not in the BlockClosure class."
		method := BlockClosure lookupSelector: aRBMessageNode selector.
	].
	^ self evaluateMethodCall: method.
	] ensure: [
		"The following 2 lines are not necessary because these informations are now stored in the context that is popped rather than in the ASTInterpreter?" 
		"self mustReturn: false.
		self returnValue: nil."
		self contextStack pop.
	 ]
		

