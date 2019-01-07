visiting
visitArgumentNode: aRBArgumentNode
	^ self lookupSymbol: aRBArgumentNode name.
	"| argSymbol argIndex argValue |
	argSymbol := aRBArgumentNode name.
	argIndex := self contextStack top argumentsNames indexOf: argSymbol.
	argValue := self contextStack top argumentsValues at: argIndex.
	^ argValue."