# Flutter and Dart paths (prefer FVM when available, allow override)
FVM := $(shell command -v fvm 2>/dev/null)
FLUTTER ?= $(if $(FVM),fvm flutter,flutter)
DART ?= $(if $(FVM),fvm dart,dart)

## Flutter related commands

# Command to run build_runner
.PHONY: build
build:
	@echo "🏗️  Running build_runner for code generation..."
	@echo "----------------------------------------"
	@$(DART) run build_runner build --delete-conflicting-outputs -d
	@echo ""
	@echo "----------------------------------------"
	@echo "✅ Code generation completed!"

# Command to start development workflow
.PHONY: start
start:
	@echo "🚀 Initializing development environment..."
	@echo "----------------------------------------"
	@echo "📝 Formatting the dart files"
	@$(DART) format lib test
	@echo "🚀 Running the app"
	@$(FLUTTER) run

# Command to clean the project
.PHONY: clean
clean:
	@echo "🧹 Cleaning project..."
	@$(FLUTTER) clean
	@$(FLUTTER) pub get
	@echo "🏗️  Running build_runner for code generation..."
	@echo "----------------------------------------"
	@$(DART) run build_runner build --delete-conflicting-outputs -d
	@echo ""
	@echo "----------------------------------------"
	@echo "✅ Code generation completed!"

# Command to run tests
.PHONY: test
test:
	@echo "🧪 Running tests..."
	@$(FLUTTER) test

# Command to generate a new feature using Mason
# Example: make feature name=add_workout -- make feature name=add_workou
.PHONY: feature
feature:
	@if [ -z "$(name)" ]; then \
		echo "❌ Error: Missing 'name' argument."; \
		echo "Usage: make feature name=<feature_name>"; \
		exit 1; \
	fi
	@echo "🛠️  Generating new feature..."
	@mason make feature --name $(name) -o lib/features/
	@echo "✅ Feature '$(name)' generated successfully!"

# Command to generate a new feature using Mason
# Example: mason make get_controller --name workout_log -o lib/features/auth/controller/
.PHONY: controller
controller:
	@if [ -z "$(name)" ]; then \
		echo "❌ Error: Missing 'name' argument."; \
		echo "Usage: make controller name=<controller_name>"; \
		exit 1; \
	fi
	@echo "🛠️  Generating new feature..."
	@mason make get_controller --name $(name) -o lib/features/$(name)/controller/
	@echo "✅ Controller '$(name)' generated successfully!"

# Command to run before pushing the code
.PHONY: done
done:
	@echo ""
	@echo "🚀 Getting project for Merge Request..."
	@echo "----------------------------------------"
	@echo "📝 Formatting the dart files"
	@$(DART) format lib test
	@echo "🧹 Cleaning the dart files"
	@$(FLUTTER) clean
	@echo ""
	@echo "📦 Fetching the necessary packages"
	@$(FLUTTER) pub get
	@echo ""
	@echo "🔨 Generating necessary files..."
	@$(DART) run build_runner build -d
	@echo ""
	@echo "------------------------------"
	@echo "🚀 Code ready for Merge Request! 🚀🚀🚀"

## Git related commands

# Command to pull the latest changes from the dev branch
.PHONY: pull
pull:
	git pull origin main

# Command to run slang
.PHONY: slang
slang:
	@echo "🏗️  Running slang for translation generation..."
	@echo "----------------------------------------"
	@$(DART) run slang
	@python3 scripts/i18n_sort.py
	@echo ""
	@echo "----------------------------------------"
	@echo "✅ Translation generation completed!"

# Command to run dart fix
.PHONY: fix
fix:
	@echo "🏗️  Running dart fix..."
	@echo "----------------------------------------"
	@$(DART) fix --apply
	@echo ""
	@echo "----------------------------------------"
	@$(DART) format lib test
	@echo ""
	@echo "----------------------------------------"
	@echo "✅ Fix completed!"

# Command to build Android App Bundle (.aab)
.PHONY: bundle
bundle:
	@echo ""
	@echo "📦 Building Android App Bundle..."
	@echo "----------------------------------------"
	@$(FLUTTER) clean
	@$(FLUTTER) pub get
	@$(DART) run build_runner build --delete-conflicting-outputs -d
	@$(FLUTTER) build appbundle --release --flavor prod
	@echo ""
	@echo "----------------------------------------"
	@echo "✅ App Bundle built successfully!"
	@echo "📍 Output: build/app/outputs/bundle/prodRelease/app-prod-release.aab"

# Command to build Android APK
.PHONY: apk
apk:
	@echo ""
	@echo "📦 Building Android APK..."
	@echo "----------------------------------------"
	@$(FLUTTER) clean
	@$(FLUTTER) pub get
	@$(DART) run build_runner build --delete-conflicting-outputs -d
	@$(FLUTTER) build apk --release --flavor prod
	@echo ""
	@echo "----------------------------------------"
	@echo "✅ APK built successfully!"
	@echo "📍 Output: build/app/outputs/apk/prod/release/app-prod-release.apk"