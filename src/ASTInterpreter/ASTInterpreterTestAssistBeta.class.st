Class {
	#name : #ASTInterpreterTestAssistBeta,
	#superclass : #ASTInterpreterTestAssistAlpha,
	#instVars : [
		'betaInstVar'
	],
	#classVars : [
		'BetaClassVar'
	],
	#category : 'ASTInterpreter'
}

{ #category : #'as yet unclassified' }
ASTInterpreterTestAssistBeta class >> BetaClassVar [
	^ BetaClassVar.
]

{ #category : #'as yet unclassified' }
ASTInterpreterTestAssistBeta class >> BetaClassVar: aValue [
	 BetaClassVar := aValue.
]

{ #category : #'as yet unclassified' }
ASTInterpreterTestAssistBeta class >> readAlphaClassVar [
	^ AlphaClassVar
]

{ #category : #accessing }
ASTInterpreterTestAssistBeta >> betaInstVar [
	^ betaInstVar
]

{ #category : #accessing }
ASTInterpreterTestAssistBeta >> betaInstVar: anObject [
	betaInstVar := anObject
]

{ #category : #'as yet unclassified' }
ASTInterpreterTestAssistBeta >> readAlphaClassVar [
	^ AlphaClassVar.
]

{ #category : #'as yet unclassified' }
ASTInterpreterTestAssistBeta >> readAlphaInstVar [
	^ alphaInstVar.
]

{ #category : #'as yet unclassified' }
ASTInterpreterTestAssistBeta >> readBetaClassVar [
	^ BetaClassVar.
]
