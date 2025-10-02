package kdl

import c "core:c"

// Data type
type :: enum i32 {
	NULL,
	BOOLEAN,
	NUMBER,
	STRING,
}

// C representation of a KDL "number"
number_type :: enum i32 {
	INTEGER,        // numbers that fit in a long long
	FLOATING_POINT, // numbers exactly representable in a double
	STRING_ENCODED, // other numbers are stored as strings
}

// A KDL number
number :: struct {
	type: number_type,
	using _: struct #raw_union {
		integer: c.longlong,
		floating_point: c.double,
		string: str,
	}
}

// A KDL value, including its type annotation (if it has one)
value :: struct {
	type:            type,
	type_annotation: str,
	using _: struct #raw_union {
		boolean: c.bool,
		number: number,
		string: str,
	}
}

