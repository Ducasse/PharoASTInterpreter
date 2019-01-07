as yet unclassified
variableArgumentLookupHelper2: argg
	|varg|
	varg := 'varg'.
	[:argb |
		|varb|
		varb := 'varb'.
		^ { argg = 'argg'. varg = 'varg'. argb = 'argb'. varb = 'varb' }.
	] value: 'argb'.
	