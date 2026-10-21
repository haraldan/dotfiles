-- Listen on a fixed IPC socket so mpv-open (~/.local/bin) can load files into
-- this instance instead of starting another one. Set at runtime because
-- mpv.conf can't expand $XDG_RUNTIME_DIR.
if mp.get_property("input-ipc-server") == "" then
  mp.set_property("input-ipc-server", (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/mpv.sock")
end
