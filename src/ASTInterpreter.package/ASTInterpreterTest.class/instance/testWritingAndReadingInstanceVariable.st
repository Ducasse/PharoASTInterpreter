test
testWritingAndReadingInstanceVariable
	| interpret ast |
	ASTInterpreterTest writingAndReadingInstanceVar: ASTInterpreterTestAssistWriteAndReadInstanceVariable new.
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'ASTInterpreterTest writingAndReadingInstanceVar writeAndReadInstVar'.
	self assert: (interpret interpret: ast) equals: 2.