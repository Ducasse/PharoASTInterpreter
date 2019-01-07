test
testPrimitiveTrue
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'true'.
	self assert: (interpret interpret: ast) equals: true. 