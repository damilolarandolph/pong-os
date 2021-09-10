const vbe = @import("drivers/video/vbe.zig");
extern const vbe_info: u32;

pub export fn main(val: u32) callconv(.C) void {
    var vbePtr = @intToPtr(*vbe.VesaBlock, vbe.VBE_ADDRESS);
    var frameBufferPtr = @intToPtr([*]u24, vbePtr.physicalBasePtr);
    var frameBufferPtr8 = @intToPtr([*]u8, vbePtr.physicalBasePtr);

    for (frameBufferPtr8[0..100]) |*b| {
        b.* = 0xff;
    }

    while (true) {}
}
