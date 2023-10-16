# Contributing


## Dependencies

tools used:

- make
- git
- [asdf version manager](https://asdf-vm.com/guide/getting-started.html)

## First run  

### Install project tools

use asdf to ensure required tools are installed ... configured tools are in  [.tool-versions](.tool-versions)

```bash
cd ~/work/moles
asdf plugin add python
asdf plugin add poetry
asdf install
```

### Install git hooks

```shell
make refresh-hooks
```

## Normal development

### Create virtualenv and install python dependencies

```shell
make install
source .venv/bin/activate
```

### Running tests

project uses:

- [pytest](https://docs.pytest.org/en/7.4.x/)

```shell
# start docker containers
make up

# run pytest tests
make test

```

### Linting

project uses:

- [ruff](https://docs.astral.sh/ruff/)
- [mypy](https://pypi.org/project/mypy/)

run both with

```shell
make lint
```

or individually with

```shell
make mypy
```

or

```shell
make ruff 
```

### Formatting code

project uses:

- [black](https://pypi.org/project/black/)

lint checks will fail if the code is not formatted correctly

```shell
# make black format the code
make black
```

## VSCode setup

If you are using visual studio code, please run these commands to set up the IDE:

```bash
sudo apt install jq -y && cat .vscode/extensions.json | jq .recommendations[] | xargs -I {} echo "code --install-extension {} --force" | bash
```
