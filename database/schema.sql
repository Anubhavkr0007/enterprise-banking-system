-- ============================================
-- CUSTOMER TABLE
-- ============================================

CREATE TABLE customer (
                          customer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          first_name VARCHAR(50) NOT NULL,
                          last_name VARCHAR(50) NOT NULL,
                          email VARCHAR(100) NOT NULL UNIQUE,
                          phone VARCHAR(15) NOT NULL UNIQUE,
                          date_of_birth DATE NOT NULL,
                          aadhaar_number VARCHAR(12) NOT NULL UNIQUE,
                          pan_number VARCHAR(10) NOT NULL UNIQUE,
                          address VARCHAR(255) NOT NULL,
                          city VARCHAR(50) NOT NULL,
                          state VARCHAR(50) NOT NULL,
                          pincode VARCHAR(10) NOT NULL,
                          status VARCHAR(20) DEFAULT 'ACTIVE',
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- BRANCH TABLE
-- ============================================

CREATE TABLE branch (
                        branch_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                        branch_name VARCHAR(100) NOT NULL,
                        ifsc_code VARCHAR(20) NOT NULL UNIQUE,
                        address VARCHAR(255) NOT NULL,
                        city VARCHAR(50) NOT NULL,
                        state VARCHAR(50) NOT NULL,
                        pincode VARCHAR(10) NOT NULL,
                        phone VARCHAR(15),
                        email VARCHAR(100) UNIQUE,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- EMPLOYEE TABLE
-- ============================================

CREATE TABLE employee (
                          employee_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          branch_id BIGINT NOT NULL,
                          first_name VARCHAR(50) NOT NULL,
                          last_name VARCHAR(50) NOT NULL,
                          email VARCHAR(100) NOT NULL UNIQUE,
                          phone VARCHAR(15) NOT NULL UNIQUE,
                          designation VARCHAR(50) NOT NULL,
                          salary DECIMAL(12,2) NOT NULL,
                          joining_date DATE NOT NULL,
                          status VARCHAR(20) DEFAULT 'ACTIVE',
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                          CONSTRAINT fk_employee_branch
                              FOREIGN KEY (branch_id)
                                  REFERENCES branch(branch_id)
);

-- ============================================
-- ACCOUNT TABLE
-- ============================================

CREATE TABLE account (
                         account_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         customer_id BIGINT NOT NULL,
                         branch_id BIGINT NOT NULL,
                         account_number VARCHAR(20) NOT NULL UNIQUE,
                         account_type ENUM('SAVINGS', 'CURRENT') NOT NULL,
                         balance DECIMAL(15,2) DEFAULT 0.00,
                         status VARCHAR(20) DEFAULT 'ACTIVE',
                         opened_date DATE NOT NULL,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                         CONSTRAINT fk_account_customer
                             FOREIGN KEY (customer_id)
                                 REFERENCES customer(customer_id),

                         CONSTRAINT fk_account_branch
                             FOREIGN KEY (branch_id)
                                 REFERENCES branch(branch_id)
);

-- ============================================
-- TRANSACTION TABLE
-- ============================================

CREATE TABLE transaction_history (
                                     transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                     account_id BIGINT NOT NULL,
                                     transaction_type ENUM('DEPOSIT', 'WITHDRAWAL', 'TRANSFER') NOT NULL,
                                     amount DECIMAL(15,2) NOT NULL,
                                     reference_number VARCHAR(50) NOT NULL UNIQUE,
                                     description VARCHAR(255),
                                     transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     status ENUM('SUCCESS', 'FAILED', 'PENDING') DEFAULT 'SUCCESS',

                                     CONSTRAINT fk_transaction_account
                                         FOREIGN KEY (account_id)
                                             REFERENCES account(account_id)
);

-- ============================================
-- CARD TABLE
-- ============================================

CREATE TABLE card (
                      card_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                      account_id BIGINT NOT NULL,
                      card_number VARCHAR(16) NOT NULL UNIQUE,
                      card_type ENUM('DEBIT', 'CREDIT') NOT NULL,
                      expiry_date DATE NOT NULL,
                      cvv CHAR(3) NOT NULL,
                      status ENUM('ACTIVE', 'BLOCKED', 'EXPIRED') DEFAULT 'ACTIVE',
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                      CONSTRAINT fk_card_account
                          FOREIGN KEY (account_id)
                              REFERENCES account(account_id)
);
-- ============================================
-- LOAN TABLE
-- ============================================

CREATE TABLE loan (
                      loan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                      customer_id BIGINT NOT NULL,
                      loan_type ENUM('HOME', 'PERSONAL', 'EDUCATION', 'VEHICLE') NOT NULL,
                      loan_amount DECIMAL(15,2) NOT NULL,
                      interest_rate DECIMAL(5,2) NOT NULL,
                      tenure_months INT NOT NULL,
                      emi_amount DECIMAL(15,2) NOT NULL,
                      remaining_amount DECIMAL(15,2) NOT NULL,
                      status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CLOSED') DEFAULT 'PENDING',
                      applied_date DATE NOT NULL,
                      approved_date DATE,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                      CONSTRAINT fk_loan_customer
                          FOREIGN KEY (customer_id)
                              REFERENCES customer(customer_id)
);

-- ============================================
-- BENEFICIARY TABLE
-- ============================================

CREATE TABLE beneficiary (
                             beneficiary_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                             customer_id BIGINT NOT NULL,
                             beneficiary_name VARCHAR(100) NOT NULL,
                             account_number VARCHAR(20) NOT NULL,
                             ifsc_code VARCHAR(20) NOT NULL,
                             bank_name VARCHAR(100) NOT NULL,
                             nickname VARCHAR(50),
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                             CONSTRAINT fk_beneficiary_customer
                                 FOREIGN KEY (customer_id)
                                     REFERENCES customer(customer_id)
);

-- ============================================
-- USER TABLE
-- ============================================

CREATE TABLE users (
                       user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       customer_id BIGINT,
                       employee_id BIGINT,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       role ENUM('CUSTOMER', 'EMPLOYEE', 'ADMIN') NOT NULL,
                       is_enabled BOOLEAN DEFAULT TRUE,
                       last_login TIMESTAMP NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                       CONSTRAINT fk_user_customer
                           FOREIGN KEY (customer_id)
                               REFERENCES customer(customer_id),

                       CONSTRAINT fk_user_employee
                           FOREIGN KEY (employee_id)
                               REFERENCES employee(employee_id)
);

-- ============================================
-- AUDIT LOG TABLE
-- ============================================

CREATE TABLE audit_log (
                           audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                           user_id BIGINT NOT NULL,
                           action VARCHAR(100) NOT NULL,
                           table_name VARCHAR(100) NOT NULL,
                           record_id BIGINT,
                           ip_address VARCHAR(45),
                           action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                           CONSTRAINT fk_audit_user
                               FOREIGN KEY (user_id)
                                   REFERENCES users(user_id)
);

-- ============================================
-- PAYMENT TABLE
-- ============================================

CREATE TABLE payment (
                         payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         transaction_id BIGINT NOT NULL,
                         payment_mode ENUM('UPI', 'NEFT', 'RTGS', 'IMPS', 'CARD') NOT NULL,
                         merchant_name VARCHAR(100),
                         utr_number VARCHAR(50) UNIQUE,
                         payment_status ENUM('SUCCESS', 'FAILED', 'PENDING') DEFAULT 'SUCCESS',
                         payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                         CONSTRAINT fk_payment_transaction
                             FOREIGN KEY (transaction_id)
                                 REFERENCES transaction_history(transaction_id)
);