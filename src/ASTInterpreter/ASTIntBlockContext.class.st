Class {
	#name : #ASTIntBlockContext,
	#superclass : #ASTIntContext,
	#instVars : [
		'blockASTNode'
	],
	#category : 'ASTInterpreter'
}

{ #category : #accessing }
ASTIntBlockContext >> blockASTNode [
	^ blockASTNode
]

{ #category : #accessing }
ASTIntBlockContext >> blockASTNode: anObject [
	blockASTNode := anObject
]

{ #category : #'as yet unclassified' }
ASTIntBlockContext >> inheritParentContextScope [
	"Indicates whether a variable or argument lookup in this context should continue to its parent context"
	^ true
]

{ #category : #accessing }
ASTIntBlockContext >> initialize [
	super initialize.
	self blockASTNode: nil.
]

{ #category : #'as yet unclassified' }
ASTIntBlockContext >> transmitNonLocalReturnToParentContext [
	"If false, indicates that a non-local return (return statement in a block) happening in a child context should replace the normal return procedure of this context.
	If true, indicates that a non-local return (return statement in a block) happening in a child context should be transmitted to the parent context"
	^ true
]
