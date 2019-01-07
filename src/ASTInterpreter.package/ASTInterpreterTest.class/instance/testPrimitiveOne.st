test
testPrimitiveOne
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '1'.
	self assert: (interpret interpret: ast) equals: 1. 