package kdl

import "core:c"

foreign import ckdl "kdl.lib"

_ :: c

// Parameter for kdl_escape - which characters should be escaped, and which should not?
kdl_escape_mode :: enum i32 {
	MINIMAL    = 0,   // Only escape what *must* be escaped
	CONTROL    = 16,  // Escape ASCII control characters
	NEWLINE    = 32,  // Escape newline characters
	TAB        = 64,  // Escape tabs
	ASCII_MODE = 368, // Escape all non-ASCII charscters

	// "Sensible" default: escape tabs, newlines, and other control characters, but leave
	// unicode intact
	DEFAULT = 112,
}

kdl_version :: enum i32 {
	_1,
	_2,
}

// Function pointers used to interface with external IO
kdl_read_func :: proc "c" (rawptr, cstring, c.size_t) -> c.size_t

kdl_write_func :: proc "c" (rawptr, cstring, c.size_t) -> c.size_t

// A reference to a string, like Rust's str or C++'s std::u8string_view
// Need not be nul-terminated!
kdl_str :: struct {
	data: cstring,  // Data pointer - NULL means no string
	len:  c.size_t, // Length of the string - 0 means empty string
}

// An owned string. Should be destroyed using kdl_free_string
// Owned strings are nul-terminated.
kdl_owned_string :: struct {
	data: cstring,
	len:  c.size_t,
}

@(default_calling_convention="c", link_prefix="")
foreign ckdl {
	// Create a kdl_str from a nul-terminated C string
	kdl_str_from_cstr :: proc(s: cstring) -> kdl_str ---

	// Create an owned string with the same content as another string
	kdl_clone_str :: proc(s: ^kdl_str) -> kdl_owned_string ---

	// Free the memory associated with an owned string, and set the pointer to NULL
	kdl_free_string :: proc(s: ^kdl_owned_string) ---

	// Escape special characters in a string
	kdl_escape_v :: proc(version: kdl_version, s: ^kdl_str, mode: kdl_escape_mode) -> kdl_owned_string ---

	// Resolve backslash escape sequences
	kdl_unescape_v :: proc(version: kdl_version, s: ^kdl_str) -> kdl_owned_string ---

	// Resolve backslash escape sequences and (in v2) dedent string
	kdl_unescape_multi_line :: proc(version: kdl_version, s: ^kdl_str) -> kdl_owned_string ---

	// Escape special characters in a string according to KDLv1 string rules
	kdl_escape :: proc(s: ^kdl_str, mode: kdl_escape_mode) -> kdl_owned_string ---

	// Resolve backslash escape sequences according to KDLv1 rules
	kdl_unescape :: proc(s: ^kdl_str) -> kdl_owned_string ---
}
