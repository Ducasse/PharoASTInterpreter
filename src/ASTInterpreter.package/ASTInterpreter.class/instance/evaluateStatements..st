visiting
evaluateStatements: statements
	| lastEvaluatedStatementValue |
	self contextStack top nonLocalReturnBlock: [:returnValue | ^ { true.  returnValue } ].
	statements do: [:sta | 
		lastEvaluatedStatementValue := self interpret: sta.
		self contextStack top mustReturn ifTrue: [ ^ {true. self contextStack top returnValue} ]
	].
	^ { false. lastEvaluatedStatementValue }