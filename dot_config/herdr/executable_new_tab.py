#!/usr/bin/env python3
"""Open a new Herdr tab right after the current one.

Usage: new_tab.py <home|cwd>
home: start in $HOME; cwd: start in the active pane's directory.
"""
import json
import os
import socket
import subprocess
import sys


def herdr(*args):
    out = subprocess.run(["herdr", *args], capture_output=True, text=True, check=True).stdout
    return json.loads(out)["result"]


def move_tab(tab_id, index):
    path = os.environ.get("HERDR_SOCKET_PATH") or os.path.expanduser("~/.config/herdr/herdr.sock")
    with socket.socket(socket.AF_UNIX) as s:
        s.connect(path)
        request = {"id": "new_tab", "method": "tab.move", "params": {"tab_id": tab_id, "insert_index": index}}
        s.sendall((json.dumps(request) + "\n").encode())
        s.makefile().readline()


pane_id = os.environ.get("HERDR_ACTIVE_PANE_ID") or os.environ["HERDR_PANE_ID"]
pane = herdr("pane", "get", pane_id)["pane"]
cwd = os.path.expanduser("~") if sys.argv[1] == "home" else pane.get("foreground_cwd") or pane["cwd"]

tabs = [t["tab_id"] for t in herdr("tab", "list", "--workspace", pane["workspace_id"])["tabs"]]
position = tabs.index(pane["tab_id"]) + 1

created = herdr("tab", "create", "--workspace", pane["workspace_id"], "--cwd", cwd, "--focus")
move_tab(created["tab"]["tab_id"], position)
