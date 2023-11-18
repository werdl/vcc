module main

import regex

struct Token {
	pub mut:
	name string
	content string
}

struct TokenDef {
	name string
	regex string
}

__global (
	tokens = [
		TokenDef{
			name: "+",
			regex: "\\+"
		},
		TokenDef{
			name: "-",
			regex: "-"
		},
		TokenDef{
			name: "int_lit",
			regex: "[0-9]*"
		},
		TokenDef{
			name: "type",
			regex: r"int~float~char"
		},
		TokenDef{
			name: "{",
			regex: "{"
		},
		TokenDef{
			name: "}", 
			regex: "}"
		},
		TokenDef{
			name: "(",
			regex: "\\("
		},
		TokenDef{
			name: ")",
			regex: "\\)"
		},
		TokenDef{
			name: "=",
			regex: "="
		},
		TokenDef{
			name: ";"
			regex: ";"
		},
		TokenDef{
			name: "return",
			regex: "return"
		}
	]
)
pub fn init_lex(s string) []Token {
	mut current:=""
	mut tokens_out:=[]Token{}
	mut i:=0
	mut added:=false
	for c in s {
		current+=c.ascii_str()
		for t in tokens {
			regexes:=t.regex.split("~")
			for regexx in regexes {
				reg:=regex.regex_opt(regexx) or { panic(err) }
				if !reg.matches_string(current.trim_space()) {
					continue
				}
				tokens_out << Token{
					name: t.name
					content: current.trim_space()
				}
				added=true
				current=""
				break
			}
			if added {
				break
			}
			
		}
		if i!=s.len-1 && !added{
			ident_nexts:=[
				"(",
				" ",
				"="
			]
			if s[i+1].ascii_str() in ident_nexts && current!="" {
				tokens_out << Token{
					name: "ident"
					content: current.trim_space()
				}
				current=""
			}
		}
		added=false
		i+=1
	}
	return tokens_out

} 

pub fn (tokens_l []Token) pass() []Token {
	mut grouped_tokens:=[]Token{}
   	mut current_group:=Token{}

    for token in tokens_l {
        if token.name == 'int_lit' {
			current_group.name='int_lit'
            current_group.content += token.content
        } else {
            if current_group.content != '' {
                grouped_tokens << current_group
                current_group = Token{}
            }
            grouped_tokens << token
        }
    }

    if current_group.content != '' {
        grouped_tokens << current_group
    }

    return grouped_tokens
}

pub fn lex(s string) []Token {
	return init_lex(s).pass()
}