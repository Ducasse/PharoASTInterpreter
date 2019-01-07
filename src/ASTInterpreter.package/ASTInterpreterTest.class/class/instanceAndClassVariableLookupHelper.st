as yet unclassified
instanceAndClassVariableLookupHelper
	"Beta inherits from Alpha"
	| a b |
	a := ASTInterpreterTestAssistAlpha new.
	b := ASTInterpreterTestAssistBeta new.
	a alphaInstVar: 1.
	ASTInterpreterTestAssistAlpha AlphaClassVar: 2.
	b betaInstVar: 3.
	ASTInterpreterTestAssistBeta BetaClassVar: 4.
	^ {
		a alphaInstVar = 1. "alpha instance reads alpha instance variable"
		b betaInstVar = 3. "beta instance reads beta instance variable"
		ASTInterpreterTestAssistAlpha AlphaClassVar = 2. "alpha class reads alpha class variable"
		ASTInterpreterTestAssistBeta BetaClassVar = 4. "beta class reads beta class variable"
		a readAlphaClassVar = 2. "alpha instance reads alpha class variable"
		b readBetaClassVar = 4. "beta instance reads beta class variable"
		b readAlphaClassVar = 2. "beta instance reads alpha class variable"
		ASTInterpreterTestAssistBeta readAlphaClassVar = 2. "beta class reads alpha class variable"
		b readAlphaInstVar = 1. "beta instance reads alpha instance variable"
	}