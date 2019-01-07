evaluation
evaluateBlock: aBlockAST

	| result returnFlagAndValue nonLocalReturnTargetContext |
	result := nil.
	self contextStack top argumentsNames: (aBlockAST arguments collect: [:argASTNode | argASTNode name]).
	"Declare local variables"
	self contextStack top declareVariables: aBlockAST temporaries.
	returnFlagAndValue := self evaluateStatements: aBlockAST statements.
	(returnFlagAndValue at: 1) 
		ifTrue: [
			"There was a return statement in the block, or someone did a non local return to this block's context (which I think should not normally happen). Performing a non local return by looking among the ancestor contexts of this block context"
			"Look among the ancestor of the current context to find the first one that does not transmit non-local returns to its parent, i.e. the first context that is a method context"
			nonLocalReturnTargetContext := self contextStack top.
			[ nonLocalReturnTargetContext transmitNonLocalReturnToParentContext ] whileTrue: [ nonLocalReturnTargetContext := nonLocalReturnTargetContext parentASTIntContext ].
			nonLocalReturnTargetContext nonLocalReturnBlock value: (returnFlagAndValue at: 2)
		]
		ifFalse: [ 
			"There was no return statement in the block, so all the statement were normally evaluated. We return the value of the last evaluated statement."
			^ returnFlagAndValue at: 2.
		].
"	aBlockAST statements do: [:sta | 
		result := self interpret: sta.
		self contextStack top mustReturn ifTrue: [ self halt: 'Non local return not implemented yet' ]
	].
	^ result"