# !/bin/bash set new password

PASSWORD="password"
docker compose exec -it filebrowser filebrowser config init
docker compose exec -it filebrowser filebrowser users update admin --password "$PASSWORD"
