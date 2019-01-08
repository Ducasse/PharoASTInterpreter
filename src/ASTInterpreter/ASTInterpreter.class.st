Class {
	#name : #ASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'contextStack',
		'debugMode',
		'debugTranscriptTabLevel'
	],
	#category : 'ASTInterpreter'
}

{ #category : #accessing }
ASTInterpreter >> contextStack [
	^ contextStack
]

{ #category : #accessing }
ASTInterpreter >> contextStack: anObject [
	contextStack := anObject
]

{ #category : #accessing }
ASTInterpreter >> debugMode: anObject [
	debugMode := anObject
]

{ #category : #evaluation }
ASTInterpreter >> evaluateBlock: aBlockAST [

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
]

{ #category : #evaluation }
ASTInterpreter >> evaluateMethodCall: aMethod [

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
]

{ #category : #visiting }
ASTInterpreter >> evaluateStatements: statements [
	| lastEvaluatedStatementValue |
	self contextStack top nonLocalReturnBlock: [:returnValue | ^ { true.  returnValue } ].
	statements do: [:sta | 
		lastEvaluatedStatementValue := self interpret: sta.
		self contextStack top mustReturn ifTrue: [ ^ {true. self contextStack top returnValue} ]
	].
	^ { false. lastEvaluatedStatementValue }
]

{ #category : #evaluation }
ASTInterpreter >> findingDefinitionContextOfTemporaryVariable: aSymbol [
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
]

{ #category : #visiting }
ASTInterpreter >> initialize [
	super initialize.
	contextStack := Stack new.
	contextStack push: ASTIntContext new.
	debugMode := false.
	debugTranscriptTabLevel := 0.
]

{ #category : #main }
ASTInterpreter >> interpret: aNode [
	|retVal|
	debugMode ifTrue: [
		debugTranscriptTabLevel timesRepeat: [ Transcript tab. ].
		Transcript show: 'Interpreting: '.
		Transcript show: aNode; cr.
		debugTranscriptTabLevel := debugTranscriptTabLevel + 1.
	].
	retVal := aNode acceptVisitor: self.
	debugMode ifTrue: [ 
		debugTranscriptTabLevel := debugTranscriptTabLevel - 1.
		debugTranscriptTabLevel timesRepeat: [ Transcript tab. ].
		Transcript show: 'Value: '.
		Transcript show: retVal; cr.
	].
	^ retVal.
]

{ #category : #evaluation }
ASTInterpreter >> lookupSymbol: aSymbol [
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

]

{ #category : #visiting }
ASTInterpreter >> visitArgumentNode: aRBArgumentNode [
	^ self lookupSymbol: aRBArgumentNode name.
	"| argSymbol argIndex argValue |
	argSymbol := aRBArgumentNode name.
	argIndex := self contextStack top argumentsNames indexOf: argSymbol.
	argValue := self contextStack top argumentsValues at: argIndex.
	^ argValue."
]

{ #category : #evaluation }
ASTInterpreter >> visitArrayNode: aRBArrayNode [ 
	^ (aRBArrayNode statements collect: [ :statement | self interpret: statement ]) asArray.
]

{ #category : #visiting }
ASTInterpreter >> visitAssignmentNode2: aRBAssignmentNode [
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
]

{ #category : #visiting }
ASTInterpreter >> visitAssignmentNode: aRBAssignmentNode [
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
]

{ #category : #visiting }
ASTInterpreter >> visitBlockNode: aRBBlockNode [
	"| blockContext |"
	^ ASTIntBlockContext new
		receiver: self contextStack top receiver;
		parentASTIntContext: self contextStack top;
		blockASTNode: aRBBlockNode;
		yourself
	
"	blockContext := ASTIntContext new
		parentASTInterpreterContext: self activeContext;
		receiver: nil.
	^ ASTIntBlock new
		context: blockContext;
		astNode: aRBBlockNode;
		yourself."
]

{ #category : #'as yet unclassified' }
ASTInterpreter >> visitGlobalNode: aRBGlobalNode [ 
	^ self visitVariableNode: aRBGlobalNode.
]

{ #category : #'as yet unclassified' }
ASTInterpreter >> visitInstanceVariableNode: aRBInstanceVariableNode [ 
	^ self visitVariableNode: aRBInstanceVariableNode.
]

{ #category : #visiting }
ASTInterpreter >> visitLiteralArrayNode: aRBLiteralArrayNode [ 
	^ self visitLiteralNode: aRBLiteralArrayNode
]

{ #category : #visiting }
ASTInterpreter >> visitLiteralNode: aRBLiteralValueNode [ 
	^ aRBLiteralValueNode value.
]

{ #category : #visiting }
ASTInterpreter >> visitMessageNode: aRBMessageNode [ 
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
		


]

{ #category : #visiting }
ASTInterpreter >> visitReturnNode: aRBReturnNode [ 
	self contextStack top mustReturn: true.
	self contextStack top returnValue: (self interpret: aRBReturnNode value).
]

{ #category : #visiting }
ASTInterpreter >> visitSelfNode: aRBSelfNode [ 
	
	^ self contextStack top receiver.
]

{ #category : #visiting }
ASTInterpreter >> visitSequenceNode: aRBSequenceNode [

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
]

{ #category : #visiting }
ASTInterpreter >> visitTemporaryNode: aRBTemporaryNode [ 
	^ self visitVariableNode: aRBTemporaryNode.
]

{ #category : #visiting }
ASTInterpreter >> visitVariableNode: anRBVariableNode [
	^ self lookupSymbol: anRBVariableNode name.
]
