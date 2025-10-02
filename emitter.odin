package kdl

foreign import ckdl "kdl.lib"

// Formatting options for a emitter: How should identifiers be serialized
identifier_emission_mode :: enum i32 {
	PREFER_BARE_IDENTIFIERS, // Traditional: quote identifiers only if absolutely necessary
	QUOTE_ALL_IDENTIFIERS,   // Express *all* identifiers as strings
	ASCII_IDENTIFIERS,       // Use only ASCII
}

// Formatting options for floating-point numbers
float_printing_options :: struct {
	always_write_decimal_point:             bool,
	always_write_decimal_point_or_exponent: bool,
	capital_e:                              bool,
	exponent_plus:                          bool,
	plus:                                   bool,
	min_exponent:                           i32,
}

// Formatting options for a emitter
emitter_options :: struct {
	indent:          i32,                          // Number of spaces to indent child nodes by
	escape_mode:     escape_mode,              // How to escape strings
	identifier_mode: identifier_emission_mode, // How to quote identifiers
	float_mode:      float_printing_options,   // How to print floating point numbers
	version:         version,                  // KDL version to use
}

/* Opaque */ emitter :: struct {}

@(default_calling_convention="c", link_prefix="kdl_")
foreign ckdl {
	// Create an emitter than writes into an internal buffer
	create_buffering_emitter :: proc(opt: ^emitter_options) -> ^emitter ---

	// Create an emitter that writes by calling a user-supplied function
	create_stream_emitter :: proc(write_func: write_func, user_data: rawptr, opt: ^emitter_options) -> ^emitter ---

	// Destroy an emitter
	destroy_emitter :: proc(emitter: ^emitter) ---

	// Write a node tag
	emit_node :: proc(emitter: ^emitter, name: str) -> bool ---

	// Write a node tag including a type annotation
	emit_node_with_type :: proc(emitter: ^emitter, type: str, name: str) -> bool ---

	// Write an argument for a node
	emit_arg :: proc(emitter: ^emitter, value: ^value) -> bool ---

	// Write a property for a node
	emit_property :: proc(emitter: ^emitter, name: str, value: ^value) -> bool ---

	// Start a list of children for the previous node ('{')
	start_emitting_children :: proc(emitter: ^emitter) -> bool ---

	// End the list of children ('}')
	finish_emitting_children :: proc(emitter: ^emitter) -> bool ---

	// Finish - write a final newline if required
	emit_end :: proc(emitter: ^emitter) -> bool ---

	// Get a reference to the current emitter buffer
	// This string is invalidated on any call to kdl_emit_*
	get_emitter_buffer :: proc(emitter: ^emitter) -> str ---
}
