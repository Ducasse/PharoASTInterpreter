test
testInstanceAndClassVariableLookup
	| interpret ast resultArray |
	interpret := ASTInterpreter new.
	ast := RBParser parseExpression: 'ASTInterpreterTest instanceAndClassVariableLookupHelper'.
	resultArray := (interpret interpret: ast). 
	"Beta class inherits from Alpha class"
	self assert: (resultArray at: 1) equals: true. "alpha instance reads alpha instance variable"
	self assert: (resultArray at: 2) equals: true. "beta instance reads beta instance variable"
	self assert: (resultArray at: 3) equals: true. "alpha class reads alpha class variable"
	self assert: (resultArray at: 4) equals: true. "beta class reads beta class variable"
	self assert: (resultArray at: 5) equals: true. "alpha instance reads alpha class variable"
	self assert: (resultArray at: 6) equals: true. "beta instance reads beta class variable"
	self assert: (resultArray at: 7) equals: true. "beta instance reads alpha class variable"
	self assert: (resultArray at: 8) equals: true. "beta class reads alpha class variable"
	self assert: (resultArray at: 9) equals: false. "beta instance reads alpha instance variable"