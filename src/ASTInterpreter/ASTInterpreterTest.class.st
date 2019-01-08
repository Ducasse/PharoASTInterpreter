Class {
	#name : #ASTInterpreterTest,
	#superclass : #TestCase,
	#classVars : [
		'writingAndReadingClassVariableTestClassVar',
		'writingAndReadingInstanceVar'
	],
	#category : 'ASTInterpreter'
}

{ #category : #'as yet unclassified' }
ASTInterpreterTest class >> instanceAndClassVariableLookupHelper [
	"Beta inherits from Alpha"
	| a b |
	a := ASTInterpreterTestAssistAlpha new.
	b := ASTInterpreterTestAssistBeta new.
	a alphaInstVar: 1.
	ASTInterpreterTestAssistAlpha AlphaClassVar: 2.
	b betaInstVar: 3.
	ASTInterpreterTestAssistBeta BetaClassVar: 4.
	^ {
		a alphaInstVar = 1. "alpha instance reads alpha instance variable"
		b betaInstVar = 3. "beta instance reads beta instance variable"
		ASTInterpreterTestAssistAlpha AlphaClassVar = 2. "alpha class reads alpha class variable"
		ASTInterpreterTestAssistBeta BetaClassVar = 4. "beta class reads beta class variable"
		a readAlphaClassVar = 2. "alpha instance reads alpha class variable"
		b readBetaClassVar = 4. "beta instance reads beta class variable"
		b readAlphaClassVar = 2. "beta instance reads alpha class variable"
		ASTInterpreterTestAssistBeta readAlphaClassVar = 2. "beta class reads alpha class variable"
		b readAlphaInstVar = 1. "beta instance reads alpha instance variable"
	}
]

{ #category : #'as yet unclassified' }
ASTInterpreterTest class >> nonLocalReturnHelper [
	^ ([ ^ 2 ] value) + 1
]

{ #category : #'as yet unclassified' }
ASTInterpreterTest class >> variableArgumentLookupHelper1: argf [
	|varf|
	varf := 'varf'.
	^ self variableArgumentLookupHelper2: 'argg'.
	
]

{ #category : #'as yet unclassified' }
ASTInterpreterTest class >> variableArgumentLookupHelper2: argg [
	|varg|
	varg := 'varg'.
	[:argb |
		|varb|
		varb := 'varb'.
		^ { argg = 'argg'. varg = 'varg'. argb = 'argb'. varb = 'varb' }.
	] value: 'argb'.
	
]

{ #category : #'as yet unclassified' }
ASTInterpreterTest class >> variableRedefinitionInMethodCalledHelper [
	| n |
	n := 2.
	^ n.
]

{ #category : #'as yet unclassified' }
ASTInterpreterTest class >> writingAndReadingClassVariableTestClassVar: aValue [
	writingAndReadingClassVariableTestClassVar := aValue
]

{ #category : #'as yet unclassified' }
ASTInterpreterTest class >> writingAndReadingClassVariableTestHelper [
	writingAndReadingClassVariableTestClassVar := 2.
	^ writingAndReadingClassVariableTestClassVar.
]

{ #category : #'as yet unclassified' }
ASTInterpreterTest class >> writingAndReadingInstanceVar [
	^ writingAndReadingInstanceVar
]

{ #category : #'as yet unclassified' }
ASTInterpreterTest class >> writingAndReadingInstanceVar: aValue [
	writingAndReadingInstanceVar := aValue
]

{ #category : #'as yet unclassified' }
ASTInterpreterTest class >> writingAndReadingLocalVariableTestHelper [
	|localVar|
	localVar := 2.
	^ localVar
]

{ #category : #running }
ASTInterpreterTest >> setUp [
	ASTInterpreterTestAssistAlpha AlphaClassVar: nil.
	ASTInterpreterTestAssistBeta BetaClassVar: nil.
]

{ #category : #test }
ASTInterpreterTest >> testBlockThatDeclareVariables [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '[|n| n:= 2. n] value'.
	self assert: (interpret interpret: ast) equals: 2.
]

{ #category : #test }
ASTInterpreterTest >> testEvaluateBlock [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '[ 2 ] value'.
	self assert: (interpret interpret: ast) equals: 2. 
]

{ #category : #test }
ASTInterpreterTest >> testEvaluateBlockWithArguments [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '[ :int | int + 2 ] value: 1'.
	self assert: (interpret interpret: ast) equals: 3. 
]

{ #category : #test }
ASTInterpreterTest >> testFactorial [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '4 factorial'.
	self assert: (interpret interpret: ast) equals: 24. 
]

{ #category : #test }
ASTInterpreterTest >> testGCD [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '45 gcd: 5'.
	self assert: (interpret interpret: ast) equals: (45 gcd: 5).
]

{ #category : #test }
ASTInterpreterTest >> testInstanceAndClassVariableLookup [
	| interpret ast resultArray |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'ASTInterpreterTest instanceAndClassVariableLookupHelper'.
	resultArray := (interpret interpret: ast). 
	"Beta class inherits from Alpha class"
	self assert: (resultArray at: 1) equals: true. "alpha instance reads alpha instance variable"
	self assert: (resultArray at: 2) equals: true. "beta instance reads beta instance variable"
	self assert: (resultArray at: 3) equals: true. "alpha class reads alpha class variable"
	self assert: (resultArray at: 4) equals: true. "beta class reads beta class variable"
	self assert: (resultArray at: 5) equals: true. "alpha instance reads alpha class variable"
	self assert: (resultArray at: 6) equals: true. "beta instance reads beta class variable"
	self assert: (resultArray at: 7) equals: true. "beta instance reads alpha class variable"
	self assert: (resultArray at: 8) equals: true. "beta class reads alpha class variable"
	self assert: (resultArray at: 9) equals: false. "beta instance reads alpha instance variable"
]

{ #category : #test }
ASTInterpreterTest >> testMultiArgumentsMethod [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'true ifTrue: [1] ifFalse: [2]'.
	self assert: (interpret interpret: ast) equals: 1. 
]

{ #category : #test }
ASTInterpreterTest >> testNonLocalReturn [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'ASTInterpreterTest nonLocalReturnHelper'.
	self assert: (interpret interpret: ast) equals: 2.
]

{ #category : #test }
ASTInterpreterTest >> testPrimitiveArray [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '#(1 2 3)'.
	self assert: (interpret interpret: ast) equals: #(1 2 3). 
]

{ #category : #test }
ASTInterpreterTest >> testPrimitiveDivision [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '6/3'.
	self assert: (interpret interpret: ast) equals: 2. 
]

{ #category : #test }
ASTInterpreterTest >> testPrimitiveOne [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '1'.
	self assert: (interpret interpret: ast) equals: 1. 
]

{ #category : #test }
ASTInterpreterTest >> testPrimitiveSubstraction [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '1 - 5'.
	self assert: (interpret interpret: ast) equals: -4. 
]

{ #category : #test }
ASTInterpreterTest >> testPrimitiveSum [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '1 + 5'.
	self assert: (interpret interpret: ast) equals: 6. 
]

{ #category : #test }
ASTInterpreterTest >> testPrimitiveTrue [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'true'.
	self assert: (interpret interpret: ast) equals: true. 
]

{ #category : #test }
ASTInterpreterTest >> testSelfInInitialExpressionIsNil [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'self'.
	self assert: (interpret interpret: ast) equals: nil. 
]

{ #category : #test }
ASTInterpreterTest >> testSequence [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'true. 1+1. 2.'.
	self assert: (interpret interpret: ast) equals: 2. 
]

{ #category : #test }
ASTInterpreterTest >> testVariableArgumentLookup [
"{ argg == 'argg'. varg == 'varg'. argb == 'argb'. varb == 'varb' }"
	| interpret ast testArray |
	interpret := ASTInterpreter new.
	interpret debugMode: true.
	ast := RBParser parseExpression: 'ASTInterpreterTest variableArgumentLookupHelper1: ''argf'''.
	testArray := (interpret interpret: ast). 
	self assert: (testArray at: 1) equals: true.
	self assert: (testArray at: 2) equals: true.
	self assert: (testArray at: 3) equals: true.
	self assert: (testArray at: 4) equals: true.
]

{ #category : #test }
ASTInterpreterTest >> testVariableRedefinitionInBlockEvaluated [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '|n| n:=1. [n := 2] value. n'.
	self assert: (interpret interpret: ast) equals: 2. 
]

{ #category : #test }
ASTInterpreterTest >> testVariableRedefinitionInMethodCalled [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '|n| n:=1. ASTInterpreterTest variableRedefinitionInMethodCalledHelper. n'.
	self assert: (interpret interpret: ast) equals: 1. 
]

{ #category : #test }
ASTInterpreterTest >> testWritingAndReadingClassVariable [
	| interpret ast |
	ASTInterpreterTest writingAndReadingClassVariableTestClassVar: 1.
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'ASTInterpreterTest writingAndReadingClassVariableTestHelper'.
	self assert: (interpret interpret: ast) equals: 2.
]

{ #category : #test }
ASTInterpreterTest >> testWritingAndReadingInstanceVariable [
	| interpret ast |
	ASTInterpreterTest writingAndReadingInstanceVar: ASTInterpreterTestAssistWriteAndReadInstanceVariable new.
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'ASTInterpreterTest writingAndReadingInstanceVar writeAndReadInstVar'.
	self assert: (interpret interpret: ast) equals: 2.
]

{ #category : #test }
ASTInterpreterTest >> testWritingAndReadingLocalVariable [
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'ASTInterpreterTest writingAndReadingLocalVariableTestHelper'.
	self assert: (interpret interpret: ast) equals: 2.
]
