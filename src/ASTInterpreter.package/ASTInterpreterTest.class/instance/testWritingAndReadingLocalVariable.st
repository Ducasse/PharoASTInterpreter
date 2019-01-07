test
testWritingAndReadingLocalVariable
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'ASTInterpreterTest writingAndReadingLocalVariableTestHelper'.
	self assert: (interpret interpret: ast) equals: 2.