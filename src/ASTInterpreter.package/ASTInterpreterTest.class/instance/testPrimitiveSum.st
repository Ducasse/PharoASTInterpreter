test
testPrimitiveSum
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '1 + 5'.
	self assert: (interpret interpret: ast) equals: 6. 