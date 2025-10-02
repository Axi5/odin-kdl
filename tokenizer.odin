package kdl

foreign import ckdl "kdl.lib"

// Return code for the tokenizer
tokenizer_status :: enum i32 {
	OK,    // ok: token returned
	EOF,   // regular end of file
	ERROR, // error
}

// Type of token
token_type :: enum i32 {
	START_TYPE,           // '('
	END_TYPE,             // ')'
	WORD,                 // identifier, number, boolean, or null
	STRING,               // regular string
	MULTILINE_STRING,     // KDLv2 multi-line string
	RAW_STRING_V1,        // KDLv1 raw string
	RAW_STRING_V2,        // KDLv2 raw string
	RAW_MULTILINE_STRING, // KDLv2 raw multiline string
	SINGLE_LINE_COMMENT,  // // ...
	SLASHDASH,            // /-
	MULTI_LINE_COMMENT,   // /* ... */
	EQUALS,               // '='
	START_CHILDREN,       // '{'
	END_CHILDREN,         // '}'
	NEWLINE,              // LF, CR, or CRLF
	SEMICOLON,            // ';'
	LINE_CONTINUATION,    // '\\'
	WHITESPACE,           // any regular whitespace
}

// Character set configuration
character_set :: enum i32 {
	V1      = 1, // V1 character set: BOM is whitespace, vertical tab is not, etc.
	V2      = 2, // V2 character set: control characters restricted, etc.
	DEFAULT = 2,
}

// A token, consisting of a token type and token text
token :: struct {
	type:  token_type,
	value: str,
}

/* Opaque */ tokenizer :: struct {}

@(default_calling_convention="c", link_prefix="")
foreign ckdl {
	// Create a tokenizer that reads from a string
	create_string_tokenizer :: proc(doc: str) -> ^tokenizer ---

	// Create a tokenizer that reads data by calling a user-supplied function
	create_stream_tokenizer :: proc(read_func: read_func, user_data: rawptr) -> ^tokenizer ---

	// Destroy a tokenizer
	destroy_tokenizer :: proc(tokenizer: ^tokenizer) ---

	// Change the character set used by the tokenizer
	tokenizer_set_character_set :: proc(tokenizer: ^tokenizer, cs: character_set) ---

	// Get the next token and write it to a user-supplied structure (or return an error)
	pop_token :: proc(tokenizer: ^tokenizer, dest: ^token) -> tokenizer_status ---
}
