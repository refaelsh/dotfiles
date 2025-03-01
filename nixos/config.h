static char *font = "DejaVu Sans Mono:pixelsize=14:antialias=true";
static Shortcut shortcuts[] = {
    { ControlMask|ShiftMask, XK_C, clipcopy, {.i = 0} }, // Ctrl+Shift+C to copy
    { ControlMask|ShiftMask, XK_V, clippaste, {.i = 0} }, // Ctrl+Shift+V to paste
};
