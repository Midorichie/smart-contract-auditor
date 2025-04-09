# Clarity Smart Contract Auditor

An AI-powered tool that automatically detects vulnerabilities in Clarity smart contracts on the Stacks blockchain. This project now includes multiple specialized modules that provide comprehensive scanning, utility functions for security analysis, and full auditing capabilities.

## Overview

This project implements an automated auditing system for Clarity smart contracts. It not only scans contract code for common vulnerabilities and best practice violations, but also registers custom vulnerability patterns and tracks detailed audit histories. The system is built as a set of interrelated modules:
  
- **Vulnerability Scanner:** Registers and tracks vulnerability patterns and scan histories, and performs automated scanning of contracts.
- **Security Utilities:** Offers utility functions for string matching and vulnerability detection, along with common vulnerability patterns (e.g., reentrancy, authorization issues) and mitigation recommendations.
- **Auditor Module:** Orchestrates contract audits, registers vulnerability patterns specific to auditing, and maintains detailed audit results with scoring and timestamps.

## Features

- **Vulnerability Pattern Registry:** Easily register and manage known vulnerability patterns with custom detection logic.
- **Contract Scanning:** Execute scans on deployed contracts with automated vulnerability detection and scan history tracking.
- **Security Utilities:** Provides helper functions for detecting common code issues, calculating security scores, and more.
- **Detailed Audit Reports:** Retrieves audit results that include vulnerability listings, security scores, and timestamps.
- **Modular Architecture:** Separate contracts for vulnerability scanning, security utilities, and auditing for clearer logic and easier maintenance.
- **Custom Pattern Support:** Developers can define and register new vulnerability patterns and scanning logic as needed.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Clarinet](https://github.com/hirosystems/clarinet) (v1.0.0 or later)
- [Node.js](https://nodejs.org/) (v14 or later)
- [Git](https://git-scm.com/)

## Project Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/midorichie/clarity-smart-contract-auditor.git
   cd clarity-smart-contract-auditor
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Initialize the Clarinet environment:**
   ```bash
   clarinet integrate
   ```

## Project Structure

```
clarity-smart-contract-auditor/
├── contracts/                    # Clarity smart contracts
│   ├── auditor.clar              # Main auditor and vulnerability registration contract
│   ├── vulnerability-scanner.clar# Implements contract scanning and vulnerability pattern registration
│   └── security-utils.clar       # Provides utility functions and common security patterns 
├── tests/                        # Test files to validate contract behavior
├── settings/                     # Clarinet configuration settings
├── analysis/                     # AI analysis components
│   ├── patterns/                 # Vulnerability patterns for automated scanning
│   └── detection.js              # Detection algorithms for assessing smart contract security
└── frontend/                     # UI components (if applicable)
```

## Running the Project

1. **Start the Clarinet console:**
   ```bash
   clarinet console
   ```

2. **Interact with the contracts:**  
   - **Scanning a Contract:**  
     ```clarity
     (contract-call? .vulnerability-scanner scan-for-vulnerabilities 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.example-contract)
     ```
   - **Auditing a Contract:**  
     ```clarity
     (contract-call? .auditor audit-contract 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.example-contract)
     ```

## Testing

Run the test suite with:
```bash
clarinet test
```

## Common Vulnerability Patterns

The auditor and scanner check for several common issues, including:

- Reentrancy attacks
- Unchecked contract calls and improper use of `unwrap!`
- Missing or weak authorization checks
- Integer overflow/underflow risks
- Unrestricted `as-contract` usage
- Unbounded loops or inefficient data structures
- Inadequate error handling

These patterns can be extended by registering new vulnerability definitions using the provided functions in both the vulnerability scanner and auditor modules.

## Using the Modules

### Vulnerability Scanner

- **Register a New Pattern (Admin Only):**
  ```clarity
  (contract-call? .vulnerability-scanner register-pattern u10 "pattern-code" "detection-logic" u5)
  ```
- **Scan a Contract:**
  ```clarity
  (contract-call? .vulnerability-scanner scan-for-vulnerabilities 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.example-contract)
  ```
- **Retrieve Scan Results:**
  ```clarity
  (contract-call? .vulnerability-scanner get-scan-result 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.example-contract u0)
  ```

### Security Utilities

Utilize helper functions from the security utilities module to check for:

- Reentrancy issues using a basic parenthesis check.
- Authorization issues via custom string matching functions.
- The calculation of a security score based on identified issues.

### Auditor Module

- **Register a Vulnerability Pattern:**
  ```clarity
  (contract-call? .auditor register-vulnerability u1 "reentrancy" "Contract allows reentrant function calls" u9 "(unwrap! (as-contract ...))")
  ```
- **Audit a Contract:**
  ```clarity
  (contract-call? .auditor audit-contract 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.example-contract)
  ```
- **Retrieve Audit Results:**
  ```clarity
  (contract-call? .auditor get-audit-result 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.example-contract u0)
  ```

## Future Enhancements

- Integration with machine learning models for improved vulnerability detection accuracy.
- Enhanced CI/CD integration for continuous security monitoring.
- Automated fix suggestions based on audit outcomes.
- A dedicated web interface for simplified interaction with the auditing system.
- Expanded historical vulnerability tracking.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request with improvements or bug fixes.

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.
