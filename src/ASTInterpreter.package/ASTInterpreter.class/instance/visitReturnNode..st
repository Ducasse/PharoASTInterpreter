visiting
visitReturnNode: aRBReturnNode 
	self contextStack top mustReturn: true.
	self contextStack top returnValue: (self interpret: aRBReturnNode value).