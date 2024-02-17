.PHONY: test

#################################################################################
# GLOBALS                                                                       #
#################################################################################
PROJECT_NAME=ml-system-design
PYTHON_INTERPRETER = python3

GLOBAL_PYTHON = $(shell which python3)

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Run all setup
setup: venv install pre-commit

## Create virtual environment
venv: $(GLOBAL_PYTHON)
	@echo "Creating .venv..."
	poetry env use $(GLOBAL_PYTHON)

## Install required dependencies
install:
	@echo "Installing dependencies..."
	poetry install --no-root --sync

## Install pre-commit hooks
pre-commit:
	@echo "Setting up pre-commit..."
	poetry run pre-commit install

# test: test_unit test_smoke
#
# ## Run all unit tests
# test_unit:
# 	poetry run pytest tests/unit
#
# # Run all smoke tests
# test_smoke:
# 	poetry run pytest tests/smoke

flake8:
	poetry run flake8 src/ app.py

# Check for static typing using Mypy
mypy:
	poetry run sh ./run-mypy.sh

check: flake8 # mypy test

#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
