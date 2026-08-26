-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080",
    position = "0x0",
    scale    = 1,
})

-- Fallback for any other/external monitor
-- NOTE: dropped a broken `mirror` flag (no target monitor given, invalid) and a
-- duplicate/conflicting catch-all line that were both present in the old monitors.conf.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
