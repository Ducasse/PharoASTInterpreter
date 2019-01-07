test
testPrimitiveArray
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '#(1 2 3)'.
	self assert: (interpret interpret: ast) equals: #(1 2 3). 