package odin

import "core:fmt"
import "core:strings"
import os "core:os/os2"

CONFIGURATION :: #config(CONFIGURATION, "Release")
SHARED_LIB :: #config(SHARED_LIB, "ON")

root_directory :: #directory + "../"
build_directory :: root_directory + "build"

main :: proc() {
    context.allocator = context.temp_allocator
    defer free_all(context.allocator)

    os.make_directory_all(build_directory)

    configure()
    build()
    install()
}

configure :: proc() {
    exec({ "cmake", root_directory + "ckdl", "-DBUILD_SHARED_LIBS=" + SHARED_LIB }, build_directory)
}

build :: proc() {
    exec({ "cmake", "--build", ".", "--config", CONFIGURATION }, build_directory)
}

Export :: struct {
    from: string,
    to: string,
}

@(rodata)
exports := [?]Export {
    { "kdl.dll", "bin/" + CONFIGURATION + "/kdl.dll" },
    { "kdl.pdb", "bin/" + CONFIGURATION + "/kdl.pdb" },
    { "kdl.lib", "kdl.lib" },
}

install :: proc() {
    for export in exports {
        from := fmt.aprintf("%s/%s/%s", build_directory, CONFIGURATION, export.from)
        if os.exists(from) {
            to := fmt.aprintf("%s/%s", root_directory, export.to)
            dir, _ := os.split_path(to)
            os.make_directory_all(dir)
            os.copy_file(to, from)
        }
    }
}

@(private="file")
exec :: proc(command: []string, working_dir := "") {

    fmt.printfln("Executing command: %s", strings.join(command[:], " "))

    desc := os.Process_Desc {
        working_dir = working_dir,
        command = command,
    }
    _, stdout, stderr, err := os.process_exec(desc, context.allocator)

    // Error handling
    if err != nil {
        panic(os.error_string(err))
    }
    if len(stdout) > 0 {
        fmt.printfln("%s", stdout)
    }
    if len(stderr) > 0 {
        fmt.printfln("%s", stderr)
    }
}
