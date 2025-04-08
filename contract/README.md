# Clarity Smart Contract Auditor

An AI-powered tool that automatically detects vulnerabilities in Clarity smart contracts on the Stacks blockchain.

## Overview

This project implements an automated auditing system for Clarity smart contracts. It scans contract code for common security vulnerabilities and best practice violations, providing developers with early feedback to improve contract security before deployment.

## Features

- Vulnerability pattern registry for common Clarity contract issues
- Contract scanning and analysis
- Security scoring system
- Detailed vulnerability reports
- Support for custom detection patterns

## Prerequisites

Before you begin, ensure you have the following installed:
- [Clarinet](https://github.com/hirosystems/clarinet) (v1.0.0 or later)
- [Node.js](https://nodejs.org/) (v14 or later)
- [Git](https://git-scm.com/)

## Project Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/midorichie/clarity-smart-contract-auditor.git
   cd clarity-smart-contract-auditor
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Initialize the Clarinet environment:
   ```bash
   clarinet integrate
   ```

## Project Structure

```
clarity-smart-contract-auditor/
├── contracts/               # Clarity smart contracts
│   ├── auditor.clar         # Main auditor contract
│   └── examples/            # Example contracts for testing
├── tests/                   # Test files
├── settings/                # Clarinet settings
├── analysis/                # AI analysis components
│   ├── patterns/            # Vulnerability patterns
│   └── detection.js         # Detection algorithms
└── frontend/                # UI components (if applicable)
```

## Running the Project

1. Start the Clarinet console:
   ```bash
   clarinet console
   ```

2. In the console, you can interact with the contract:
   ```clarity
   (contract-call? .auditor audit-contract 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.example-contract)
   ```

## Testing

Run the test suite with:

```bash
clarinet test
```

## Common Vulnerability Patterns

The auditor checks for common vulnerabilities including:

1. Reentrancy attacks
2. Unchecked contract calls
3. Improper use of `unwrap!` or `unwrap-panic`
4. Missing authorization checks
5. Integer overflow/underflow
6. Unrestricted `as-contract` usage
7. Unbounded loops
8. Excessive contract size
9. Inefficient data structures
10. Improper error handling

## Using the Auditor

1. Register vulnerability patterns (admin only):
   ```clarity
   (contract-call? .auditor register-vulnerability u1 "reentrancy" "Contract allows reentrant function calls" u9 "(unwrap! (as-contract...))")
   ```

2. Audit a contract:
   ```clarity
   (contract-call? .auditor audit-contract 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.example-contract)
   ```

3. View audit results:
   ```clarity
   (contract-call? .auditor get-audit-result 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.example-contract)
   ```

## Future Enhancements

- Machine learning model for improved detection accuracy
- Integration with CI/CD pipelines
- Support for automated fix suggestions
- Web interface for easier interaction
- Historical vulnerability tracking

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
