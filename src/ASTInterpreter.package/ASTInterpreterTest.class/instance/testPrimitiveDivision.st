test
testPrimitiveDivision
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '6/3'.
	self assert: (interpret interpret: ast) equals: 2. 