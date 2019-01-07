test
testSequence
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'true. 1+1. 2.'.
	self assert: (interpret interpret: ast) equals: 2. 