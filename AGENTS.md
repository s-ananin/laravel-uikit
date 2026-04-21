# AGENTS.md

## Overview

This is a Laravel 12 project with Livewire, Filament, and Tailwind CSS. It uses SQLite by default for development.

---

## Build / Lint / Test Commands

### PHP (Laravel Pint - Code Style)

```bash
# Format all PHP files
composer pint

# Format specific file or directory
./vendor/bin/pint app/Models/Feedback.php
./vendor/bin/pint app/

# Lint check (without fixing)
./vendor/bin/pint --test
```

### PHP (PHP-CS-Fixer)

```bash
# Fix code style issues
./vendor/bin/php-cs-fixer fix

# Dry run
./vendor/bin/php-cs-fixer fix --dry-run --diff
```

### JavaScript / Vite

```bash
# Development (with hot reload)
npm run dev

# Production build
npm run build

# Install dependencies
npm install
```

### Laravel Commands

```bash
# Run all tests
composer test
# or
php artisan test

# Run tests with coverage
php artisan test --coverage

# Run a single test
php artisan test --filter=ExampleTest
php artisan test tests/Unit/ExampleTest.php
php artisan test --filter="test_example"

# Run specific test suite
php artisan test --testsuite=Unit
php artisan test --testsuite=Feature

# Clear caches
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# Database migrations
php artisan migrate
php artisan migrate:fresh --seed

# Start development server
php artisan serve
```

### Full Development Setup

```bash
# One-time setup (runs migrations, builds assets)
composer setup

# Run all services concurrently (server, queue, logs, vite)
composer dev
```

---

## Code Style Guidelines

### General

- **Encoding**: UTF-8
- **Line endings**: LF
- **Indentation**: 4 spaces (2 for YAML)
- **Final newline**: Required
- **Trailing whitespace**: Remove

### PHP

#### Naming Conventions

- Classes: `PascalCase` (e.g., `PageContent`, `FeedbackStatus`)
- Methods/Properties: `camelCase` (e.g., `scopePublished`, `$feedbacks`)
- Constants: `SCREAMING_SNAKE_CASE` (e.g., `PUBLISHED`)
- Enum cases: `PascalCase` (e.g., `case PUBLISHED`)
- Tables/Columns: `snake_case` (e.g., `full_name`, `created_at`)

#### File Structure

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Example extends Model
{
    // Properties with PHPDoc annotations
    // Traits
    // Constants
    // Boot method (scopes, events)
    // Accessors & Mutators
    // Relationships
    // Scopes
}
```

#### Imports

- Use fully qualified class names or `use` statements
- Group imports: internal packages, then external, then local
- Sort alphabetically within groups

```php
<?php

namespace App\Livewire;

use App\Enums\FeedbackStatus;       // Internal (local)
use App\Models\Feedback;            // Internal (local)
use Illuminate\Support\Collection;  // Laravel
use Livewire\Component;              // External package
```

#### Types

- Use PHP 8.x features: typed properties, union types, enums
- Return types are required on public methods
- Use `void` for methods that don't return values

```php
public function mount(): void
public function render(): Factory|View
protected Collection $feedbacks;
```

#### Enums

- Use backed enums with string values when storing in DB
- Implement `label()` method for human-readable strings
- Implement `color()` or similar for UI states

```php
enum FeedbackStatus: string
{
    case PUBLISHED = 'published';
    case UNPUBLISHED = 'unpublished';

    public function label(): string
    {
        return match ($this) {
            self::PUBLISHED => 'Опубликовано',
            self::UNPUBLISHED => 'Не опубликовано',
        };
    }
}
```

#### Models

- Always use `$fillable` or `$guarded` for mass assignment
- Cast enum fields with `$casts`
- Use PHPDoc `@property` annotations for IDE support
- Create query scopes with `scope` prefix

```php
class Feedback extends Model
{
    use HasFactory;

    protected $fillable = ['full_name', 'comment', 'status', 'type'];

    protected $casts = [
        'status' => FeedbackStatus::class,
        'type' => FeedbackType::class,
    ];

    public function scopePublished(Builder $query): Builder
    {
        return $query->where('status', FeedbackStatus::PUBLISHED);
    }
}
```

#### Blade Templates

- Use lowercase-kebab for component names: `<x-header />`, `<x-section.hero />`
- Use `$loop->first` for conditional rendering in loops
- Pass data to components with attributes: `:feedbacks="$feedbacks"`

### JavaScript

- Use ES6+ features (const/let, arrow functions, template literals)
- Use strict mode: `"use strict";`
- Prefer jQuery plugin initialization in `$(function() { ... })`
- Cache DOM queries when reused

```javascript
$(function() {
    "use strict";

    const $element = $(".element");
    $element.on("click", function() {
        // handler
    });
});
```

### CSS

- Use Tailwind CSS for utility classes
- Use BEM-ish naming for custom CSS classes
- Keep custom CSS minimal; prefer Tailwind utilities

---

## Project Structure

```
app/
├── Http/Controllers/     # Controllers (minimal, thin)
├── Livewire/           # Livewire components
├── Models/             # Eloquent models
├── Enums/              # PHP enums
├── Enums/              # PHP enums
└── ...

database/
├── migrations/         # Database migrations
└── factories/          # Model factories

resources/
└── views/
    ├── components/     # Blade components
    │   ├── layouts/
    │   └── section/
    └── livewire/       # Livewire views

routes/
├── web.php            # Web routes
└── console.php        # Console commands

tests/
├── Feature/           # Feature tests
└── Unit/              # Unit tests
```

---

## Common Patterns

### Livewire Component

```php
class PageContent extends Component
{
    public Collection $feedbacks;

    public function mount(): void
    {
        $this->feedbacks = Feedback::query()->get();
    }

    public function render(): Factory|View
    {
        return view('livewire.page-content');
    }
}
```

### Route Definition

```php
use App\Livewire\PageContent;

Route::get('/', PageContent::class);
```

### Blade Section with Anchor

```blade
<div class="section" id="section0" data-anchor="home">
    <!-- content -->
</div>
```

---

## IDE Configuration

The project includes `.editorconfig` for automatic formatting in compatible editors (PHPStorm, VS Code with extensions, etc.).
