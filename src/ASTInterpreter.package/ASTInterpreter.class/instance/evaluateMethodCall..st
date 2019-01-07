evaluation
evaluateMethodCall: aMethod

	| returnFlagAndValue context|
	aMethod isPrimitive ifTrue: [ 
		^ aMethod valueWithReceiver: self contextStack top receiver
		arguments: self contextStack top argumentsValues asArray
	].
	context := self contextStack top.
	self contextStack top argumentsNames: (aMethod ast arguments collect: [:argASTNode | argASTNode name]).
"	aMethod ast statements do: [:sta | 
		self interpret: sta.
		self contextStack top mustReturn ifTrue: [ ^ self contextStack top returnValue ]
	]."
	"Declare local variables"
	self contextStack top declareVariables: aMethod ast temporaries.
	returnFlagAndValue := self evaluateStatements: aMethod ast statements.
	"In case the return value comes from a non local return, unstack all the skipped contexts"
	[self contextStack top == context] whileFalse: [ self contextStack pop ].
	(returnFlagAndValue at: 1 ) 
		ifTrue: [ "the return value comes from a return statement (or a non-local return), so we return it" ^ returnFlagAndValue at: 2 ]
		ifFalse: [ "the return value is just the value of the last of the statements. Since this is a method call, we should return the receiver." ^ self contextStack top receiver].