test
testVariableRedefinitionInBlockEvaluated
	| interpret ast |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: '|n| n:=1. [n := 2] value. n'.
	self assert: (interpret interpret: ast) equals: 2. 