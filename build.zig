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

    // Build asm files;
    const nasmArgs = [_][]const u8{ "nasm", "./asm/bootloader/bootloader.asm", "-i ./asm/bootloader/", "-f elf", "-o ./bootloader.o" };
    const nasmStep = b.addSystemCommand(&nasmArgs);
    const kernelAsmArgs = [_][]const u8{ "nasm", "./asm/kernel/kernel-jump.asm", "-f elf", "-o ./kernel-jump.o" };
    const kernelAsmStep = b.addSystemCommand(&kernelAsmArgs);

    // Build Zig Kernel
    const kernelObj = b.addExecutable("kernel", "./src/main.zig");
    kernelObj.setTarget(target);

    kernelObj.addObjectFile("./bootloader.o");
    kernelObj.addObjectFile("./kernel-jump.o");

    kernelObj.setLinkerScriptPath("./asm/linker.ld");
    kernelObj.setBuildMode(std.builtin.Mode.ReleaseSmall);
    kernelObj.installRaw("raw");

    // Step up build commands/options
    const runCommand = b.addSystemCommand(&[_][]const u8{ "qemu-system-x86_64", "-drive", "file=./zig-out/bin/raw,format=raw" });
    const runOption = b.step("run", "run in qemu");

    // Wire up dependencies
    kernelObj.step.dependOn(&nasmStep.step);
    kernelObj.step.dependOn(&kernelAsmStep.step);
    runCommand.step.dependOn(b.getInstallStep());
    runOption.dependOn(&runCommand.step);
}
