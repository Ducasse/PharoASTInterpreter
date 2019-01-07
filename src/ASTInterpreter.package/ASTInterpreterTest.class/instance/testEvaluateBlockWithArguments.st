test
testEvaluateBlockWithArguments
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '[ :int | int + 2 ] value: 1'.
	self assert: (interpret interpret: ast) equals: 3. 