module main

import pcre

__global {
	tokens = {
		"NUMBER": "^(?!.*\..*\.|\s)\d*(\.\d+)?$",
		"RETURN": "return",
		"LBRACK": "{",
		"RBRACK": "}",
		"MAIN": "int\s+main\s*\(\s*\)"
	}
}