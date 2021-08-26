const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    b.verbose = true;
    b.verbose_link = true;
    b.verbose_cc = true;
    const target: std.zig.CrossTarget = .{ .cpu_arch = std.Target.Cpu.Arch.i386, .os_tag = std.Target.Os.Tag.freestanding, .abi = std.Target.Abi.none };

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();
    const nasmArgs = [_][]const u8{ "nasm", "./boot/bootloader.asm", "-f elf", "-o ./bootloader.o" };
    const nasmStep = b.addSystemCommand(&nasmArgs);
    const kernelObj = b.addExecutable("kernel", "src/main.zig");
    kernelObj.step.dependOn(&nasmStep.step);
    kernelObj.setTarget(target);
    kernelObj.addObjectFile("./bootloader.o");
    kernelObj.setLinkerScriptPath("./boot/linker.ld");
    kernelObj.setBuildMode(std.builtin.Mode.ReleaseFast);
    kernelObj.installRaw("raw");
    const runCommand = b.addSystemCommand(&[_][]const u8{ "qemu-system-x86_64", "-drive", "file=./zig-out/bin/raw,format=raw" });
    runCommand.step.dependOn(b.getInstallStep());
    const runOption = b.step("run", "run in qemu");
    runOption.dependOn(&runCommand.step);
}
