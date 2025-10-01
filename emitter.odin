package kdl

foreign import ckdl "kdl.lib"

// Formatting options for a kdl_emitter: How should identifiers be serialized
kdl_identifier_emission_mode :: enum i32 {
	PREFER_BARE_IDENTIFIERS, // Traditional: quote identifiers only if absolutely necessary
	QUOTE_ALL_IDENTIFIERS,   // Express *all* identifiers as strings
	ASCII_IDENTIFIERS,       // Use only ASCII
}

// Formatting options for floating-point numbers
kdl_float_printing_options :: struct {
	always_write_decimal_point:             bool,
	always_write_decimal_point_or_exponent: bool,
	capital_e:                              bool,
	exponent_plus:                          bool,
	plus:                                   bool,
	min_exponent:                           i32,
}

// Formatting options for a kdl_emitter
kdl_emitter_options :: struct {
	indent:          i32,                          // Number of spaces to indent child nodes by
	escape_mode:     kdl_escape_mode,              // How to escape strings
	identifier_mode: kdl_identifier_emission_mode, // How to quote identifiers
	float_mode:      kdl_float_printing_options,   // How to print floating point numbers
	version:         kdl_version,                  // KDL version to use
}

/* Opaque */ kdl_emitter :: struct {}

@(default_calling_convention="c", link_prefix="")
foreign ckdl {
	// Create an emitter than writes into an internal buffer
	kdl_create_buffering_emitter :: proc(opt: ^kdl_emitter_options) -> ^kdl_emitter ---

	// Create an emitter that writes by calling a user-supplied function
	kdl_create_stream_emitter :: proc(write_func: kdl_write_func, user_data: rawptr, opt: ^kdl_emitter_options) -> ^kdl_emitter ---

	// Destroy an emitter
	kdl_destroy_emitter :: proc(emitter: ^kdl_emitter) ---

	// Write a node tag
	kdl_emit_node :: proc(emitter: ^kdl_emitter, name: kdl_str) -> bool ---

	// Write a node tag including a type annotation
	kdl_emit_node_with_type :: proc(emitter: ^kdl_emitter, type: kdl_str, name: kdl_str) -> bool ---

	// Write an argument for a node
	kdl_emit_arg :: proc(emitter: ^kdl_emitter, value: ^kdl_value) -> bool ---

	// Write a property for a node
	kdl_emit_property :: proc(emitter: ^kdl_emitter, name: kdl_str, value: ^kdl_value) -> bool ---

	// Start a list of children for the previous node ('{')
	kdl_start_emitting_children :: proc(emitter: ^kdl_emitter) -> bool ---

	// End the list of children ('}')
	kdl_finish_emitting_children :: proc(emitter: ^kdl_emitter) -> bool ---

	// Finish - write a final newline if required
	kdl_emit_end :: proc(emitter: ^kdl_emitter) -> bool ---

	// Get a reference to the current emitter buffer
	// This string is invalidated on any call to kdl_emit_*
	kdl_get_emitter_buffer :: proc(emitter: ^kdl_emitter) -> kdl_str ---
}
