test
testEvaluateBlock
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '[ 2 ] value'.
	self assert: (interpret interpret: ast) equals: 2. 