# Contributing to AWS VPC Terraform Module

Thank you for your interest in contributing to this project! We welcome contributions from the community.

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct (be respectful and professional).

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/jhonmezaa/terraform-aws-vpc/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Terraform version
   - AWS Provider version
   - Minimal reproducible example

### Suggesting Enhancements

1. Check existing [Issues](https://github.com/jhonmezaa/terraform-aws-vpc/issues) and [Discussions](https://github.com/jhonmezaa/terraform-aws-vpc/discussions)
2. Create a new issue or discussion with:
   - Clear use case description
   - Proposed solution
   - Example configuration
   - Benefits and potential drawbacks

### Pull Requests

1. **Fork the repository**

   ```bash
   git clone https://github.com/jhonmezaa/terraform-aws-vpc.git
   cd terraform-aws-vpc
   git checkout -b feature/my-new-feature
   ```

2. **Make your changes**

   - Follow the existing code style
   - Update documentation
   - Add examples if applicable
   - Add tests if applicable

3. **Format and validate**

   ```bash
   # Format all Terraform files
   terraform fmt -recursive

   # Validate module
   cd vpc
   terraform init
   terraform validate

   # Validate all examples
   cd ../examples
   ./validate-all.sh
   ```

4. **Commit your changes**

   ```bash
   git add .
   git commit -m "Add feature: description"
   ```

5. **Push and create PR**
   ```bash
   git push origin feature/my-new-feature
   ```
   Then open a Pull Request on GitHub

## Development Guidelines

### Code Style

- Use `for_each` instead of `count` for resources
- Use descriptive variable and resource names
- Add comments for complex logic
- Follow the numbered file organization (0-14)

### File Organization

```
vpc/
├── 0-versions.tf        # Provider requirements
├── 1-*.tf               # Primary resources
├── 2-*.tf               # Supporting resources
├── N-variables.tf       # Input variables
├── N-outputs.tf         # Outputs
├── N-data.tf            # Data sources
└── N-locals.tf          # Local values
```

### Variable Guidelines

- Use clear, descriptive names
- Add comprehensive descriptions
- Provide sensible defaults where appropriate
- Use validation blocks for complex inputs
- Group related variables together

### Output Guidelines

- Output all useful resource attributes
- Use descriptive output names
- Add clear descriptions
- Use `try()` for optional resources

### Example Guidelines

Each example should include:

- `main.tf` - Module configuration
- `variables.tf` - Input variables with defaults
- `outputs.tf` - Relevant outputs
- `versions.tf` - Provider requirements
- `README.md` - Documentation with cost estimate

### Documentation

- Update README.md for new features
- Update CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/)
- Add or update examples
- Document breaking changes clearly

### Testing

Before submitting a PR:

```bash
# Format code
terraform fmt -recursive

# Validate module
cd vpc && terraform validate

# Validate all examples
cd examples && ./validate-all.sh

# Test with real infrastructure (optional)
cd examples/basic-vpc
terraform init
terraform plan
```

## Commit Message Guidelines

Use clear, descriptive commit messages:

```
Add support for IPv6 egress-only gateway

- Added create_egress_only_igw variable
- Added egress-only IGW resource
- Updated route tables for IPv6
- Added example configuration
- Updated documentation

Closes #123
```

### Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

Types:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

## Release Process

Releases follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.0.0): Breaking changes
- **MINOR** (0.1.0): New features (backward compatible)
- **PATCH** (0.0.1): Bug fixes (backward compatible)

## Questions?

- Open a [Discussion](https://github.com/jhonmezaa/terraform-aws-vpc/discussions)
- Ask in [Issues](https://github.com/jhonmezaa/terraform-aws-vpc/issues)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
