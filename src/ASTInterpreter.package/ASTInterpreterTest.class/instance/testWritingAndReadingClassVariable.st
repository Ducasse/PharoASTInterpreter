test
testWritingAndReadingClassVariable
	| interpret ast |
	ASTInterpreterTest writingAndReadingClassVariableTestClassVar: 1.
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'ASTInterpreterTest writingAndReadingClassVariableTestHelper'.
	self assert: (interpret interpret: ast) equals: 2.