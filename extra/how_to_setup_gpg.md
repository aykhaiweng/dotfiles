# Create a GPG key first
You can create a GPG key by running the following command:
```
$ gpg --full-generate-key
```

# Viewing existing GPG keys
You can then see the key you created from the following command:
```
$ gpg --list-secret-keys --keyid-format=long

/Users/hubot/.gnupg/secring.gpg
------------------------------------
sec   4096R/3AA5C34371567BD2 2016-03-10 [expires: 2017-03-10]
uid                          Hubot 
ssb   4096R/42B317FD4BA89E7A 2016-03-10
```

Note the `3AA5C34371567BD2` or whatever key is in place of that will be used for
the next command.

# Exporting the GPG key in ASCII armor format
The following command will create an output in the terminal that you can paste
into GitHub or whatever repo you wish to use.
```
$ gpg --armor --export 3AA5C34371567BD2

-----BEGIN PGP PUBLIC KEY BLOCK-----
...
...
...
-----END PGP PUBLIC KEY BLOCK-----
```