package kdl

import "core:c"

foreign import ckdl "kdl.lib"

_ :: c

// Parameter for kdl_escape - which characters should be escaped, and which should not?
escape_mode :: enum i32 {
	MINIMAL    = 0,   // Only escape what *must* be escaped
	CONTROL    = 16,  // Escape ASCII control characters
	NEWLINE    = 32,  // Escape newline characters
	TAB        = 64,  // Escape tabs
	ASCII_MODE = 368, // Escape all non-ASCII charscters

	// "Sensible" default: escape tabs, newlines, and other control characters, but leave
	// unicode intact
	DEFAULT = 112,
}

version :: enum i32 {
	_1,
	_2,
}

// Function pointers used to interface with external IO
read_func :: proc "c" (rawptr, cstring, c.size_t) -> c.size_t

write_func :: proc "c" (rawptr, cstring, c.size_t) -> c.size_t

// A reference to a string, like Rust's str or C++'s std::u8string_view
// Need not be nul-terminated!
str :: struct {
	data: cstring,  // Data pointer - NULL means no string
	len:  c.size_t, // Length of the string - 0 means empty string
}

// An owned string. Should be destroyed using kdl_free_string
// Owned strings are nul-terminated.
owned_string :: struct {
	data: cstring,
	len:  c.size_t,
}

@(default_calling_convention="c", link_prefix="kdl_")
foreign ckdl {
	// Create a str from a nul-terminated C string
	str_from_cstr :: proc(s: cstring) -> str ---

	// Create an owned string with the same content as another string
	clone_str :: proc(s: ^str) -> owned_string ---

	// Free the memory associated with an owned string, and set the pointer to NULL
	free_string :: proc(s: ^owned_string) ---

	// Escape special characters in a string
	escape_v :: proc(version: version, s: ^str, mode: escape_mode) -> owned_string ---

	// Resolve backslash escape sequences
	unescape_v :: proc(version: version, s: ^str) -> owned_string ---

	// Resolve backslash escape sequences and (in v2) dedent string
	unescape_multi_line :: proc(version: version, s: ^str) -> owned_string ---

	// Escape special characters in a string according to KDLv1 string rules
	escape :: proc(s: ^str, mode: escape_mode) -> owned_string ---

	// Resolve backslash escape sequences according to KDLv1 rules
	unescape :: proc(s: ^str) -> owned_string ---
}
