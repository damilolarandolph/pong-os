const VIDEO_MEM = 0x000b8000;
const VIDEO_PTR = @intToPtr(*u8, VIDEO_MEM);

const Colors = enum(u8) { BLACK, BLUE, GREEN, CYAN, RED, PURPLE, BROWN, GRAY, DARK_GRAY, LIGHT_BLUE, LIGHT_GREEN, LIGHT_CYAN, LIGHT_RED, LIGHT_PURPLE, YELLOW, WHITE };

pub fn printChar(char: u8) void {
    VIDEO_PTR.* = 'X';
}
