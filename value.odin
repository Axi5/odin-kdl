package kdl

import c "core:c"

// Data type
kdl_type :: enum i32 {
	NULL,
	BOOLEAN,
	NUMBER,
	STRING,
}

// C representation of a KDL "number"
kdl_number_type :: enum i32 {
	INTEGER,        // numbers that fit in a long long
	FLOATING_POINT, // numbers exactly representable in a double
	STRING_ENCODED, // other numbers are stored as strings
}

// A KDL number
kdl_number :: struct {
	type: kdl_number_type,
	using _: struct #raw_union {
		integer: c.longlong,
		floating_point: c.double,
		string: kdl_str,
	}
}

// A KDL value, including its type annotation (if it has one)
// kdl_value :: struct {}
kdl_value :: struct {
	type:            kdl_type,
	type_annotation: kdl_str,
	using _: struct #raw_union {
		boolean: c.bool,
		number: kdl_number,
		string: kdl_str,
	}
}

