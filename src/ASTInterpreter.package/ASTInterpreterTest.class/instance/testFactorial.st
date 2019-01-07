test
testFactorial
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '4 factorial'.
	self assert: (interpret interpret: ast) equals: 24. 