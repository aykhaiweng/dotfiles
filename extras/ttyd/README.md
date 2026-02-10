Link ttyd.service

```
ln -s ttyd.service /etc/systemd/system/ttyd.service
```

Start service

```
sudo systemctl daemon-reload
sudo systemctl enable ttyd
sudo systemctl start ttyd
# Check if it's running (should say "active (running)")
sudo systemctl status ttyd
```
