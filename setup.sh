#!/bin/bash

rye init .

rye pin 3.10

rye sync

if grep -q "\[tool.hatch.build.targets.wheel\]" pyproject.toml; then
    awk '
    /\[tool.hatch.build.targets.wheel\]/ {
        print
        getline
        print "packages = [\"src/\"]"
        next
    }
    {print}
    ' pyproject.toml > pyproject_temp.toml && mv pyproject_temp.toml pyproject.toml
else
    echo -e "\n[tool.hatch.build.targets.wheel]\npackages = [\"src/\"]" >> pyproject.toml
fi

# src -------------------------------------------
rm -rf ./src

mkdir -p ./src/

# Makefile -------------------------------------------

content=$(cat << EOF
all:
	echo "rye setup"

init:
	rye add --dev ruff
	rye add pip
	rye sync

sync:
	rye sync

lint:
	rye run lint

format:
	rye run format

check:
	rye run check

mypy:
	rye run lint:mypy

clean:
	find src/ -name "__pycache__" | xargs rm -rf
	find . -name ".mypy_cache" | xargs rm -rf
	find . -name ".ruff_cache" | xargs rm -rf

.PHONY: sync lint clean init all format check mypy
EOF
)

echo "$content" > Makefile

echo "Makefile created successfully!"

# rye setup -------------------------------------------
make init

# .vscode/settings.json -------------------------------------------
content=$(cat << EOM
{
    "[python]": {
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "charliermarsh.ruff"
    }
}
EOM
)

mkdir -p .vscode

echo "$content" > .vscode/settings.json

echo ".vscode/settings.json created successfully!"


# .gitignore -------------------------------------------
content=$(cat << EOF

# custom
.DS_Store
.env
.mypy_cache/
.ruff_cache/
.pytest_cache/
.mypy_cache/
wandb/

EOF
)

echo "$content" >> .gitignore

echo ".gitignore added successfully!"

# pyproject.toml -------------------------------------------
content=$(cat << EOF

[tool.rye.scripts]
lint = { chain = [
    "echo:format",
    "ruff:format",
    "echo:check",
    "ruff:check",
    "echo:mypy",
    "lint:mypy",
] }
"echo:format" = "echo ruff formatting..."
"ruff:format" = "ruff format src/"
"echo:check" = "echo ruff checking..."
"ruff:check" = "ruff check src/ --fix"
"echo:mypy" = "echo ruff mypy..."
"lint:mypy" = "mypy src/"
format = { chain = [
    "echo:format",
    "ruff:format",
] }
check = { chain = [
    "echo:check",
    "ruff:check",
] }

[tool.ruff]

[tool.mypy]
EOF
)

echo "$content" >> pyproject.toml

echo "pyproject.toml added successfully!"

# end -------------------------------------------

echo "all files created successfully!"