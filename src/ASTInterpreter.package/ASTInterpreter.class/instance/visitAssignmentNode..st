visiting
visitAssignmentNode: aRBAssignmentNode
	| value definitionContext variableSymbol classVariablesHolder|
	variableSymbol := aRBAssignmentNode variable name.
	value := (self interpret: aRBAssignmentNode value).
	"Assigning to local variables"
	definitionContext := self findingDefinitionContextOfTemporaryVariable: aRBAssignmentNode variable name.
	definitionContext ifNotNil: [ 
		definitionContext variables at: variableSymbol put: value.
		^ value.	
	].

	"assigning to instance variable"
	[self contextStack top receiver instVarNamed: (variableSymbol asString) put: value. ^ value.] 
		on: InstanceVariableNotFound
		do: [ ].
		
	"assigning to class variable"
	classVariablesHolder := self contextStack top receiver.
	(classVariablesHolder isClass) ifFalse: [
		"If the receiver is not a class, its class hold its class variables" classVariablesHolder := classVariablesHolder class].
	(classVariablesHolder allClassVarNames includes: variableSymbol) ifTrue: [
		"We know that this class or one of its superclass has a matching variable.
		We climb up the class chain, asking each link if it has the matching variable"
		[ classVariablesHolder ~= nil ] whileTrue: [ 
			[classVariablesHolder classVarNamed: (variableSymbol asString) put: value. ^ value] 
				on: Error "Sadly readClassVariableNamed: signals this very generic exception class when the variable is not found"
				do: [].
			classVariablesHolder := classVariablesHolder superclass.
		]].