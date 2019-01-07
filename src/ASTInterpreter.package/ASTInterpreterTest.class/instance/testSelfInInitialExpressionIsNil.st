test
testSelfInInitialExpressionIsNil
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'self'.
	self assert: (interpret interpret: ast) equals: nil. 