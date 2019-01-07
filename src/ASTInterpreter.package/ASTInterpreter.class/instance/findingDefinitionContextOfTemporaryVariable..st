evaluation
findingDefinitionContextOfTemporaryVariable: aSymbol
	"Finds the context in which variable aSymbol is defined. Looks in current context and continue to the parent contexts as long as these are block contexts.
	If such a context was found, return it.
	If no such context was found, return"
	| lookedUpContext lookupLocalVarAndArgumentsInContextBlock |
	"Block that takes a context and looks up for aSymbol in the local variable and arguments available to it."
	lookupLocalVarAndArgumentsInContextBlock := [:context | 
		|argumentIndex|
		"Look up among local variables"
		(context variables includesKey: aSymbol) ifTrue: [
			^ context
		].
		"Look up among arguments"
		argumentIndex := context argumentsNames indexOf: aSymbol.
		(argumentIndex = 0) ifFalse: [
			"argument of matching symbol found"
			^ context
		].
	].
	lookedUpContext := self contextStack top.
	lookupLocalVarAndArgumentsInContextBlock value: lookedUpContext.
	[lookedUpContext inheritParentContextScope] whileTrue: [ 
		lookedUpContext := lookedUpContext parentASTIntContext.
		lookupLocalVarAndArgumentsInContextBlock value: lookedUpContext.
	].
	^ nil.