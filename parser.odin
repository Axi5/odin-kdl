package kdl

foreign import ckdl "kdl.lib"

// Type of parser event
event :: enum i32 {
	EOF         = 0, // regular end of file
	PARSE_ERROR = 1, // parse error
	START_NODE  = 2, // start of a node (a child node, if the previous node has not yet ended)
	END_NODE    = 3, // end of a node
	ARGUMENT    = 4, // argument for the current node
	PROPERTY    = 5, // property for the current node

	// If KDL_EMIT_COMMENTS is specified:
	//  - on its own: a comment
	//  - ORed with another event type: a node/argument/property that has been commented out
	//    using a slashdash
	COMMENT = 65536,
}

// Parser configuration
parse_option :: enum i32 {
	EMIT_COMMENTS  = 1,      // Emit comments (default: don't)
	READ_VERSION_1 = 131072, // Use KDL version 1.0.0
	READ_VERSION_2 = 262144, // Use KDL version 2.0.0
	DETECT_VERSION = 458752, // Allow both KDL v2 and KDL v1
	DEFAULTS       = 458752, // Default: allow both versions
}

// Full event structure
event_data :: struct {
	event: event, // What is the event?
	name:  str,   // name of the node or property
	value: value, // value including type annotation (for nodes: null with type annotation)
}

/* Opaque */ parser :: struct {}

@(default_calling_convention="c", link_prefix="kdl_")
foreign ckdl {
	// Create a parser that reads from a string
	create_string_parser :: proc(doc: str, opt: parse_option) -> ^parser ---

	// Create a parser that reads data by calling a user-supplied function
	create_stream_parser :: proc(read_func: read_func, user_data: rawptr, opt: parse_option) -> ^parser ---

	// Destroy a parser
	destroy_parser :: proc(parser: ^parser) ---

	// Get the next parse event
	// Returns a pointer to an event structure. The structure (including all strings it contains!) is
	// invalidated on the next call.
	parser_next_event :: proc(parser: ^parser) -> ^event_data ---
}
