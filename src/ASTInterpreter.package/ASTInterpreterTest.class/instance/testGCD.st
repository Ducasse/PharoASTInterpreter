test
testGCD
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '45 gcd: 5'.
	self assert: (interpret interpret: ast) equals: (45 gcd: 5).