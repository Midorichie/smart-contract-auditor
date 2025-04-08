;; auditor.clar
;; Smart Contract Auditor - Scans contracts for common vulnerabilities

;; Error codes
(define-constant ERR-UNAUTHORIZED u100)
(define-constant ERR-INVALID-CONTRACT u101)
(define-constant ERR-SCAN-FAILED u102)

;; Data variables
(define-data-var admin principal tx-sender)
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
  { contract-id: principal }
  { 
    timestamp: uint,
    vulnerabilities: (list 20 uint),
    score: uint
  }
)

;; Public functions
(define-public (register-vulnerability (pattern-id uint) (name (string-ascii 50)) 
                                      (description (string-utf8 500)) 
                                      (severity uint) 
                                      (detection-pattern (string-utf8 500)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err ERR-UNAUTHORIZED))
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
      ;; In a real implementation, this would invoke more complex analysis
      (mock-audit-result (list u1 u4))
      (audit-score u80)
    )
    (map-set audit-results
      { contract-id: contract-id }
      {
        timestamp: block-height,
        vulnerabilities: mock-audit-result,
        score: audit-score
      }
    )
    (ok audit-score)
  )
)

;; Read-only functions
(define-read-only (get-vulnerability-pattern (pattern-id uint))
  (map-get? vulnerability-patterns { pattern-id: pattern-id })
)

(define-read-only (get-audit-result (contract-id principal))
  (map-get? audit-results { contract-id: contract-id })
)

;; Administrative functions
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err ERR-UNAUTHORIZED))
    (var-set admin new-admin)
    (ok true)
  )
)
