Class {
	#name : #ASTInterpreterTestAssistWriteAndReadInstanceVariable,
	#superclass : #Object,
	#instVars : [
		'instVar'
	],
	#category : 'ASTInterpreter'
}

{ #category : #writing }
ASTInterpreterTestAssistWriteAndReadInstanceVariable >> writeAndReadInstVar [
	instVar := 2.
	^ instVar.
]
