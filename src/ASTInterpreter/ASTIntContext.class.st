Class {
	#name : #ASTIntContext,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'variables',
		'argumentsValues',
		'argumentsNames',
		'parentASTIntContext',
		'mustReturn',
		'returnValue',
		'nonLocalReturnBlock'
	],
	#category : 'ASTInterpreter'
}

{ #category : #accessing }
ASTIntContext >> argumentsNames [
	^ argumentsNames
]

{ #category : #accessing }
ASTIntContext >> argumentsNames: anObject [
	argumentsNames := anObject
]

{ #category : #accessing }
ASTIntContext >> argumentsValues [
	^ argumentsValues
]

{ #category : #accessing }
ASTIntContext >> argumentsValues: anObject [
	argumentsValues := anObject
]

{ #category : #'as yet unclassified' }
ASTIntContext >> declareVariables: anOrderedCollectionOfRBVariableNodes [
	anOrderedCollectionOfRBVariableNodes do: [ :aRBVariableNode |
		self variables add: (Association key: aRBVariableNode name value: nil).	 
	].
]

{ #category : #'as yet unclassified' }
ASTIntContext >> inheritParentContextScope [
	"Indicates whether a variable or argument lookup in this context should continue to its parent context"
	^ false
]

{ #category : #initialization }
ASTIntContext >> initialize [
	super initialize.
	self receiver: nil.
	self variables: Dictionary new.
	self argumentsValues: Array new.
	self argumentsNames: Array new.
	self mustReturn: false.
	self returnValue: nil.
	self nonLocalReturnBlock: nil.
]

{ #category : #accessing }
ASTIntContext >> mustReturn [
	^ mustReturn
]

{ #category : #accessing }
ASTIntContext >> mustReturn: anObject [
	mustReturn := anObject
]

{ #category : #accessing }
ASTIntContext >> nonLocalReturnBlock [
	^ nonLocalReturnBlock
]

{ #category : #accessing }
ASTIntContext >> nonLocalReturnBlock: anObject [
	nonLocalReturnBlock := anObject
]

{ #category : #accessing }
ASTIntContext >> parentASTIntContext [
	^ parentASTIntContext
]

{ #category : #accessing }
ASTIntContext >> parentASTIntContext: anObject [
	parentASTIntContext := anObject
]

{ #category : #accessing }
ASTIntContext >> receiver [
	^ receiver
]

{ #category : #accessing }
ASTIntContext >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
ASTIntContext >> returnValue [
	^ returnValue
]

{ #category : #accessing }
ASTIntContext >> returnValue: anObject [
	returnValue := anObject
]

{ #category : #'as yet unclassified' }
ASTIntContext >> transmitNonLocalReturnToParentContext [
	"If false, indicates that a non-local return (return statement in a block) happening in a child context should replace the normal return procedure of this context.
	If true, indicates that a non-local return (return statement in a block) happening in a child context should be transmitted to the parent context"
	^ false
]

{ #category : #accessing }
ASTIntContext >> variables [
	^ variables
]

{ #category : #accessing }
ASTIntContext >> variables: anObject [
	variables := anObject
]
