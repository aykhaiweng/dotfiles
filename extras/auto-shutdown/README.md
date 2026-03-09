Since you're on a modern Linux system (likely Ubuntu/Debian based on your
dotfiles), you should use systemd timers instead. They're more robust and
provide better logging via journalctl.


Create these two files in ~/.config/systemd/user/:

# The Service File
~/.config/systemd/user/auto-shutdown.service

```
[Unit]
Description=Check for system idle and power off
After=network.target

[Service]
Type=oneshot
ExecStart=/home/khai/.dotfiles/extras/auto_shutdown.sh
```


# The Timer File (Runs every 15 mins)
```
# ~/.config/systemd/user/auto-shutdown.timer
[Unit]
Description=Run auto-shutdown check every 15 minutes

[Timer]
OnBootSec=15min
OnUnitActiveSec=15min

[Install]
WantedBy=timers.target
```

# How to enable it
Run these commands to start the timer:
```
systemctl --user daemon-reload
systemctl --user enable --now auto-shutdown.timer
```

# How to check the status/logs:
See when it's scheduled to run next
```
$ systemctl --user list-timers
```

# See the logs from the last run
```
$ journalctl --user -u auto-shutdown.service
```

# Linger
Note: Since this is a user-level timer, ensure your user session stays
"lingering" so the timer runs even when you aren't logged in (crucial for an
auto-shutdown script!):

```
sudo loginctl enable-linger khai
```

# Linking
If you're using my scripts:
```
ln -sf ~/.dotfiles/extras/auto-shutdown/auto-shutdown.{service,timer} ~/.config/systemd/user/
```
