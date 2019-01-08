Class {
	#name : #ASTInterpreterTestAssistAlpha,
	#superclass : #Object,
	#instVars : [
		'alphaInstVar'
	],
	#classVars : [
		'AlphaClassVar'
	],
	#category : 'ASTInterpreter'
}

{ #category : #'as yet unclassified' }
ASTInterpreterTestAssistAlpha class >> AlphaClassVar [
	^ AlphaClassVar
]

{ #category : #'as yet unclassified' }
ASTInterpreterTestAssistAlpha class >> AlphaClassVar: aValue [
	AlphaClassVar := aValue
]

{ #category : #accessing }
ASTInterpreterTestAssistAlpha >> alphaInstVar [
	^ alphaInstVar
]

{ #category : #accessing }
ASTInterpreterTestAssistAlpha >> alphaInstVar: anObject [
	alphaInstVar := anObject
]

{ #category : #'as yet unclassified' }
ASTInterpreterTestAssistAlpha >> readAlphaClassVar [
	^ AlphaClassVar
]
