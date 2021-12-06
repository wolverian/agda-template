# Agda template

## Prerequisites

- Nix

or

- GNU `make`
- Pandoc
- Agda

## Cloning the repository

1. [ ] Click on "Use this template" on GitHub.
2. [ ] Create a new Cachix binary cache for your repository by going to https://app.cachix.org → "Create a binary cache".
       Name it after your repository.
       On the cache page, go to "Settings → Auth Tokens" and create a new write token.
3. [ ] On the GitHub repository page, go to "Settings → Secrets → New repository secret" and add `CACHIX_AUTH_TOKEN`.
       Set its value to the secret you created in the previous step.
4. [ ] Open the GitHub Actions workflow file `.github/workflows/github-pages.yml` in an editor and update the value of the `cachix-action` parameter `name` to the name of your cache.
       Commit your change.
5. [ ] After the GitHub Actions "Deploy" job is green, on the GitHub repository page, go to "Settings → Pages".
       Select "Source: gh-pages".

## Compile HTML

Using Nix:

```shellsession
$ nix-build
```

Or, if you have the dependencies otherwise installed:

```shellsession
$ make all
```

## Continuous integration

## License
