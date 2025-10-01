package kdl

foreign import ckdl "kdl.lib"

// Type of parser event
kdl_event :: enum i32 {
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
kdl_parse_option :: enum i32 {
	EMIT_COMMENTS  = 1,      // Emit comments (default: don't)
	READ_VERSION_1 = 131072, // Use KDL version 1.0.0
	READ_VERSION_2 = 262144, // Use KDL version 2.0.0
	DETECT_VERSION = 458752, // Allow both KDL v2 and KDL v1
	DEFAULTS       = 458752, // Default: allow both versions
}

// Full event structure
kdl_event_data :: struct {
	event: kdl_event, // What is the event?
	name:  kdl_str,   // name of the node or property
	value: kdl_value, // value including type annotation (for nodes: null with type annotation)
}

/* Opaque */ kdl_parser :: struct {}

@(default_calling_convention="c", link_prefix="")
foreign ckdl {
	// Create a parser that reads from a string
	kdl_create_string_parser :: proc(doc: kdl_str, opt: kdl_parse_option) -> ^kdl_parser ---

	// Create a parser that reads data by calling a user-supplied function
	kdl_create_stream_parser :: proc(read_func: kdl_read_func, user_data: rawptr, opt: kdl_parse_option) -> ^kdl_parser ---

	// Destroy a parser
	kdl_destroy_parser :: proc(parser: ^kdl_parser) ---

	// Get the next parse event
	// Returns a pointer to an event structure. The structure (including all strings it contains!) is
	// invalidated on the next call.
	kdl_parser_next_event :: proc(parser: ^kdl_parser) -> ^kdl_event_data ---
}
