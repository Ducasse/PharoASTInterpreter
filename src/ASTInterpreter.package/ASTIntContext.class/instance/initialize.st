initialization
initialize
	super initialize.
	self receiver: nil.
	self variables: Dictionary new.
	self argumentsValues: Array new.
	self argumentsNames: Array new.
	self mustReturn: false.
	self returnValue: nil.
	self nonLocalReturnBlock: nil.