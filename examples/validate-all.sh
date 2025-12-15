#!/bin/bash
# Validate all examples in the examples directory

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXAMPLES_DIR="$SCRIPT_DIR"

echo "================================================"
echo "Validating all VPC module examples"
echo "================================================"
echo ""

EXAMPLES=(
    "minimal"
    "basic-vpc"
    "vpc-with-nat-gateway"
    "complete-vpc"
    "ipv6-vpc"
    "vpn-gateway"
    "network-acls"
    "secondary-cidrs"
    "outposts"
)

FAILED=()
PASSED=()

for example in "${EXAMPLES[@]}"; do
    echo "-------------------------------------------"
    echo "Validating: $example"
    echo "-------------------------------------------"

    if [ ! -d "$EXAMPLES_DIR/$example" ]; then
        echo "❌ Directory not found: $example"
        FAILED+=("$example")
        continue
    fi

    cd "$EXAMPLES_DIR/$example"

    # Initialize
    if terraform init -backend=false > /dev/null 2>&1; then
        # Validate
        if terraform validate > /dev/null 2>&1; then
            echo "✅ $example - VALID"
            PASSED+=("$example")
        else
            echo "❌ $example - VALIDATION FAILED"
            terraform validate
            FAILED+=("$example")
        fi
    else
        echo "❌ $example - INIT FAILED"
        terraform init -backend=false
        FAILED+=("$example")
    fi

    echo ""
done

echo "================================================"
echo "Validation Summary"
echo "================================================"
echo "Passed: ${#PASSED[@]}/${#EXAMPLES[@]}"
echo "Failed: ${#FAILED[@]}/${#EXAMPLES[@]}"
echo ""

if [ ${#PASSED[@]} -gt 0 ]; then
    echo "✅ Passed examples:"
    for example in "${PASSED[@]}"; do
        echo "   - $example"
    done
    echo ""
fi

if [ ${#FAILED[@]} -gt 0 ]; then
    echo "❌ Failed examples:"
    for example in "${FAILED[@]}"; do
        echo "   - $example"
    done
    echo ""
    exit 1
fi

echo "🎉 All examples validated successfully!"
exit 0
