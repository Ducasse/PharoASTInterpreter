evaluation
lookupSymbol: aSymbol
	"Order of precedence for the lookup:
		A) Local variables and arguments (look in current context and continue to the parent contexts as long as these are block contexts)
		B) Instance variables	(ask the receiver if it has a matching instance variable)
		C) Class variables (ask the class of the receiver, then the class from which it inherits and so on)
		D) Class pool variables (Apparently multiple classes can share some class variables thanks to class pools)
		E) Global variables (Smalltalk)
	"
	"Lookup algorithm:
		1) Look up in top context
			a) Look up for a local variable with a matching name
			b) Look up for an argument with a matching name
		2) If last context that lookup happened in is a block context, continue lookup (goto 1)) in the parent context of the last context lookup happened in.
		3) Continue lookup in global variables"
	| lookedUpContext lookupLocalVarAndArgumentsInContextBlock classVariablesHolder temporaryVariableDefinitionContext |

	"A) Lookup local variables and arguments"
	"Block that takes a context and looks up for aSymbol in the local variable and arguments available to it."
	
	(temporaryVariableDefinitionContext := (self findingDefinitionContextOfTemporaryVariable: aSymbol)) ifNotNil: [ 
			
	].
	lookupLocalVarAndArgumentsInContextBlock := [:context | 
		|argumentIndex|
		"Look up among local variables"
		(context variables includesKey: aSymbol) ifTrue: [
			^ context variables at: aSymbol
		].
		"Look up among arguments"
		argumentIndex := context argumentsNames indexOf: aSymbol.
		(argumentIndex = 0) ifFalse: [
			"argument of matching symbol found"
			^ context argumentsValues at: argumentIndex.
		].
	].
	lookedUpContext := self contextStack top.
	lookupLocalVarAndArgumentsInContextBlock value: lookedUpContext.
	[lookedUpContext inheritParentContextScope] whileTrue: [ 
		lookedUpContext := lookedUpContext parentASTIntContext.
		lookupLocalVarAndArgumentsInContextBlock value: lookedUpContext.
	].

	"B) No matching local variable or argument found. Looking up among instance variables" 
	[^ self contextStack top receiver instVarNamed: (aSymbol asString)] 
		on: InstanceVariableNotFound
		do: [ ].
		
	"C) No matching instance variable found. Looking up among class variables"
	classVariablesHolder := self contextStack top receiver.
	(classVariablesHolder isClass) ifFalse: [
		"If the receiver is not a class, its class hold its class variables" classVariablesHolder := classVariablesHolder class].
	(classVariablesHolder allClassVarNames includes: aSymbol) ifTrue: [
		"We know that this class or one of its superclass has a matching variable.
		We climb up the class chain, asking each link if it has the matching variable"
		[ classVariablesHolder ~= nil ] whileTrue: [ 
			[^ classVariablesHolder readClassVariableNamed: (aSymbol asString)] 
				on: Error "Sadly readClassVariableNamed: signals this very generic exception class when the variable is not found"
				do: [].
			classVariablesHolder := classVariablesHolder superclass.
		]].
		"^ classVariablesHolder classVarNamed: aSymbol]."
	"[classVariablesHolder readClassVariableNamed: (aSymbol asString)]
		on: Error ""Sadly readClassVariableNamed: signals this very generic exception class when the variable is not found""
		do: []."
	"TODO: Should also lookup for class variables in parent classes"
	
	"D) Looking up  in class pools"
	"I don't know enough about these yet"
	
	"E) Looking up in global variables."
	Smalltalk globals at: aSymbol ifPresent: [ :value | ^ value ].
	
	self error: 'Failed lookup'
