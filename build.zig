const std = @import("std");
pub fn main() !void {
    try std.fs.File.stdout().writeAll("I run zig init today\nn");
}
