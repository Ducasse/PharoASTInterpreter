visiting
visitAssignmentNode2: aRBAssignmentNode
	| value lookedupContext lookupContextProcedure |
	value := (self interpret: aRBAssignmentNode value).
	"self contextStack top variables add: (Association key: aRBAssignmentNode variable name value: value)."
	lookedupContext := self contextStack top.
	lookupContextProcedure := [ :context |
		(context variables includesKey: aRBAssignmentNode variable name) ifTrue: [ 
			"context has a variable with the right name defined, assigning it the new value"
			context variables at: aRBAssignmentNode variable name put: value.
			^ value.
		].
	].
	lookupContextProcedure value: lookedupContext.
	[lookedupContext inheritParentContextScope] whileTrue: [
		lookedupContext := lookedupContext parentASTIntContext.
		(lookedupContext isNil) ifTrue: [ self error: 'Could not find context where variable ', (aRBAssignmentNode variable name asString) , 'is defined' ].
		lookupContextProcedure value: lookedupContext.
	].