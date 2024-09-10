docker build . -t aykhaiweng-dotfiles:test \
    --build-arg SSH_PRVKEY="$(cat ~/.ssh/id_ed25519)" \
    --build-arg SSH_PUBKEY="$(cat ~/.ssh/id_ed25519.pub)"
docker run --name=dotfiles-test --interactive --tty --rm aykhaiweng-dotfiles:test
