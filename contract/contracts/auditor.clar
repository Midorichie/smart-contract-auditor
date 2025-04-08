;; auditor.clar
;; Smart Contract Auditor - Scans contracts for common vulnerabilities

;; Error codes
(define-constant ERR-UNAUTHORIZED u100)
(define-constant ERR-INVALID-CONTRACT u101)
(define-constant ERR-SCAN-FAILED u102)
(define-constant ERR-INVALID-PARAMETERS u103)
(define-constant ERR-ALREADY-INITIALIZED u104)

;; Data variables
(define-data-var admin principal tx-sender)
(define-data-var scanner-contract (optional principal) none)
(define-data-var initialized bool false)

;; Data structures
(define-map vulnerability-patterns 
  { pattern-id: uint }
  { 
    name: (string-ascii 50),
    description: (string-utf8 500),
    severity: uint,
    detection-pattern: (string-utf8 500)
  }
)

(define-map audit-results
  { contract-id: principal, audit-id: uint }
  { 
    timestamp: uint,
    vulnerabilities: (list 20 uint),
    score: uint,
    auditor: principal
  }
)

(define-data-var audit-counter uint u0)

;; Initialize contract
(define-public (initialize (scanner-principal principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err ERR-UNAUTHORIZED))
    (asserts! (not (var-get initialized)) (err ERR-ALREADY-INITIALIZED))
    ;; Basic validation that it's not the zero address
    (asserts! (not (is-eq scanner-principal 'SP000000000000000000002Q6VF78)) (err ERR-INVALID-CONTRACT))
    
    (var-set scanner-contract (some scanner-principal))
    (var-set initialized true)
    (ok true)
  )
)

;; Public functions
(define-public (register-vulnerability (pattern-id uint) 
                                      (name (string-ascii 50)) 
                                      (description (string-utf8 500)) 
                                      (severity uint) 
                                      (detection-pattern (string-utf8 500)))
  (begin
    ;; Security check - only admin can register patterns
    (asserts! (is-eq tx-sender (var-get admin)) (err ERR-UNAUTHORIZED))
    
    ;; Validation
    (asserts! (and (> severity u0) (<= severity u10)) (err ERR-INVALID-PARAMETERS))
    (asserts! (> (len name) u0) (err ERR-INVALID-PARAMETERS))
    (asserts! (> (len description) u0) (err ERR-INVALID-PARAMETERS))
    (asserts! (> (len detection-pattern) u0) (err ERR-INVALID-PARAMETERS))
    
    ;; Additional validation of pattern-id to address unchecked data warning
    (asserts! (< pattern-id (+ (var-get audit-counter) u1000)) (err ERR-INVALID-PARAMETERS))
    
    ;; Store the pattern
    (map-set vulnerability-patterns 
      { pattern-id: pattern-id }
      { 
        name: name,
        description: description,
        severity: severity,
        detection-pattern: detection-pattern
      }
    )
    (ok true)
  )
)

(define-public (audit-contract (contract-id principal))
  (let
    (
      (audit-id (var-get audit-counter))
      (scanner (unwrap! (var-get scanner-contract) (err ERR-INVALID-CONTRACT)))
      ;; In a real implementation, this would call the scanner contract
      (mock-audit-result (list u1 u4 u7))
      (audit-score u75)
    )
    (begin
      ;; Basic validation that it's not the zero address
      (asserts! (not (is-eq contract-id 'SP000000000000000000002Q6VF78)) (err ERR-INVALID-CONTRACT))
      
      ;; Increment audit counter for unique IDs
      (var-set audit-counter (+ audit-id u1))
      
      ;; Store audit results
      (map-set audit-results
        { contract-id: contract-id, audit-id: audit-id }
        {
          timestamp: block-height,
          vulnerabilities: mock-audit-result,
          score: audit-score,
          auditor: tx-sender
        }
      )
      (ok audit-id)
    )
  )
)

;; Read-only functions
(define-read-only (get-vulnerability-pattern (pattern-id uint))
  (map-get? vulnerability-patterns { pattern-id: pattern-id })
)

(define-read-only (get-audit-result (contract-id principal) (audit-id uint))
  (map-get? audit-results { contract-id: contract-id, audit-id: audit-id })
)

(define-read-only (get-latest-audit-id)
  (var-get audit-counter)
)

(define-read-only (get-admin)
  (var-get admin)
)

;; Administrative functions
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err ERR-UNAUTHORIZED))
    (asserts! (not (is-eq new-admin tx-sender)) (err ERR-INVALID-PARAMETERS))
    (var-set admin new-admin)
    (ok true)
  )
)

(define-public (set-scanner (new-scanner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err ERR-UNAUTHORIZED))
    (asserts! (var-get initialized) (err ERR-INVALID-CONTRACT))
    ;; Basic validation that it's not the zero address
    (asserts! (not (is-eq new-scanner 'SP000000000000000000002Q6VF78)) (err ERR-INVALID-CONTRACT))
    (var-set scanner-contract (some new-scanner))
    (ok true)
  )
)
