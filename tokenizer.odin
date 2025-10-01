package kdl

foreign import ckdl "kdl.lib"

// Return code for the tokenizer
kdl_tokenizer_status :: enum i32 {
	OK,    // ok: token returned
	EOF,   // regular end of file
	ERROR, // error
}

// Type of token
kdl_token_type :: enum i32 {
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
kdl_character_set :: enum i32 {
	V1      = 1, // V1 character set: BOM is whitespace, vertical tab is not, etc.
	V2      = 2, // V2 character set: control characters restricted, etc.
	DEFAULT = 2,
}

// A token, consisting of a token type and token text
kdl_token :: struct {
	type:  kdl_token_type,
	value: kdl_str,
}

/* Opaque */ kdl_tokenizer :: struct {}

@(default_calling_convention="c", link_prefix="")
foreign ckdl {
	// Create a tokenizer that reads from a string
	kdl_create_string_tokenizer :: proc(doc: kdl_str) -> ^kdl_tokenizer ---

	// Create a tokenizer that reads data by calling a user-supplied function
	kdl_create_stream_tokenizer :: proc(read_func: kdl_read_func, user_data: rawptr) -> ^kdl_tokenizer ---

	// Destroy a tokenizer
	kdl_destroy_tokenizer :: proc(tokenizer: ^kdl_tokenizer) ---

	// Change the character set used by the tokenizer
	kdl_tokenizer_set_character_set :: proc(tokenizer: ^kdl_tokenizer, cs: kdl_character_set) ---

	// Get the next token and write it to a user-supplied structure (or return an error)
	kdl_pop_token :: proc(tokenizer: ^kdl_tokenizer, dest: ^kdl_token) -> kdl_tokenizer_status ---
}
