visiting
visitSequenceNode: aRBSequenceNode

	|context returnFlagAndValue|
	context := self contextStack top.
	"Declare local variables"
	self contextStack top declareVariables: aRBSequenceNode temporaries.
	returnFlagAndValue := self evaluateStatements: aRBSequenceNode statements.
	"In case the return value comes from a non local return, unstack all the skipped contexts"
	[self contextStack top == context] whileFalse: [ self contextStack pop ].
	(returnFlagAndValue at: 1 ) 
		ifTrue: [ "the return value comes from a return statement (or a non-local return), so we return it" ^ returnFlagAndValue at: 2 ]
		ifFalse: [ "the return value is just the value of the last of the statements. Since this is a sequence node, we should return it." ^ returnFlagAndValue at: 2].

	
	"aRBSequenceNode statements do: [:sta | 
		self interpret: sta.
		self contextStack top mustReturn ifTrue: [ ^ self contextStack top returnValue ]
	].
	^ self contextStack top receiver."