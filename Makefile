.PHONY: precommit precommit-install

# Run the pre-commit checks
precommit:
	@echo "🔍 Formatting staged files..."
	@git diff --cached --name-only | grep '\.dart$$' | xargs -r dart format > /dev/null
	@git diff --cached --name-only | grep '\.md$$' | xargs -r prettier --write > /dev/null
	@git ls-files -m | grep -E '\.dart$$|\.md$$' | xargs -r git add

# Install a pre-commit Git hook that runs `make precommit`
precommit-install:
	@echo "#!/bin/sh" > .git/hooks/pre-commit
	@echo "exec make precommit" >> .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "✅ Pre-commit hook installed."
