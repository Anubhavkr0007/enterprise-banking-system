# **Enterprise Banking System - Database Notes**

## **Project Objective**

The Enterprise Banking System is a secure banking application that allows customers to manage their bank accounts, transfer money, apply for loans, and view transaction history. Bank employees can manage customer accounts and monitor banking operations.

---

## Functional Requirements

### _Customer Management_
- Register a new customer
- Update customer details
- View customer profile
- Activate or deactivate customer account

### _Account Management_
- Open a new bank account
- Close an account
- View account balance
- Support Savings and Current accounts

### _Transactions_
- Deposit money
- Withdraw money
- Transfer money between accounts
- Maintain transaction history

### _Branch Management_
- Store branch information
- Assign employees to branches

### _Employee Management_
- Add employees
- Assign employees to branches
- Manage employee details

### _Card Management_
- Issue Debit Card
- Issue Credit Card
- Block or activate cards

### _Loan Management_
- Apply for loans
- Approve or reject loans
- Track EMI and remaining balance

### _Beneficiary Management_
- Add beneficiaries
- Remove beneficiaries
- Transfer money to beneficiaries

### _Authentication_
- Secure login
- Role-based access (Customer/Admin/Employee)

### _Audit Logs_
- Record user activities
- Store login and transaction logs

---

# Database Entities

| Entity | Description |
|---------|-------------|
| Customer | Stores customer personal information |
| Branch | Stores branch details |
| Employee | Stores bank employee details |
| Account | Stores customer bank accounts |
| Transaction | Stores deposits, withdrawals, and transfers |
| Card | Stores debit and credit card details |
| Beneficiary | Stores saved beneficiaries for transfers |
| Loan | Stores loan information |
| User | Stores login credentials and roles |
| AuditLog | Stores user activity logs |
| Payment | Stores payment transaction details |