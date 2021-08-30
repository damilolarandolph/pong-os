const video = @import("drivers/video.zig");

pub export fn main() void {
    video.printChar('X');
    while (true) {}
}
