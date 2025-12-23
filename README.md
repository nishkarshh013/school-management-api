# School Management API

A robust Ruby on Rails API designed for educational organizations to manage schools, courses, batches, users, enrollments, and student progress.

## Overview

The system enforces:
- **Strict Role-Based Access Control (RBAC)**
- **Multi-tenant data isolation**
- **Secure JWT-based authentication**

This project was built as part of a backend engineering assignment with a strong focus on **correctness**, **security**, and **testability**.

---

## Table of Contents

- [Tech Stack](#tech-stack)
- [System Dependencies](#system-dependencies)
- [Core Features](#core-features)
- [User Roles & Responsibilities](#user-roles--responsibilities)
- [Domain Model](#domain-model)
- [Progress Tracking](#progress-tracking)
- [API Design](#api-design)
- [Authentication](#authentication)
- [API Endpoints](#api-endpoints)
- [Authorization Strategy](#authorization-strategy)
- [Getting Started](#getting-started)
- [Running Tests](#running-tests)
- [Design Decisions](#design-decisions)
- [Author](#author)

---

## Tech Stack

| Technology | Version |
|------------|---------|
| Ruby       | 3.4.7   |
| Rails      | 8.1.1   |
| Database   | PostgreSQL |

---

## System Dependencies

Before running the application, ensure you have the following installed:

- **PostgreSQL**
- **Bundler**
- **Node.js** (required for Rails dependencies)

---

## Core Features

- **Role-Based Access Control (RBAC)** using Pundit
- **Stateless JWT Authentication**
- **Multi-Tenant Data Isolation** (school-level security)
- **Enrollment Workflow**: request → approve / reject
- **Student Progress Visibility** within batches
- **Comprehensive Automated Test Coverage** using RSpec

---

## User Roles & Responsibilities

### **Admin (Global)**
- Create and manage schools
- Create SchoolAdmins
- Full visibility across all data

### **SchoolAdmin**
- Manage their own school
- Create and manage courses and batches
- Approve or reject enrollment requests
- View all students enrolled in their school's batches

### **Student**
- Request enrollment into batches
- View classmates and progress within approved batches

---

## Domain Model

| Model | Description |
|-------|-------------|
| **User** | Represents Admin, SchoolAdmin, or Student |
| **School** | Top-level entity managed by Admins |
| **Course** | Belongs to a School |
| **Batch** | Cohort within a Course |
| **Enrollment** | Join model between Student and Batch |
| **Progress** | Tracked as an attribute on Enrollment |

---

## Progress Tracking

Progress is intentionally implemented in a **simple and extensible** manner:

- Each `Enrollment` contains a `progress` integer (e.g., percentage)
- Students can view:
  - Their classmates
  - Each classmate's progress **only within the same approved batch**

**Note**: No complex grading or analytics were added, as they are outside the assignment scope.

This design satisfies the requirement:
> *"Students from the same batch can see their classmates and their progress"*

While keeping the system clean and easy to extend in the future.

---

## API Design

- **API-only** Rails application
- **JSON-only** responses
- **JWT-based** authentication
- Authorization enforced via **Pundit policies**
- No frontend included (out of scope)

---

## Authentication

### Login

**Endpoint**: `POST /api/v1/login`

Returns a JWT token on successful authentication.

**Usage**: Include the token in all authenticated requests:

```http
Authorization: Bearer <JWT_TOKEN>
```

---

## API Endpoints

### Schools & Users

| Method | Endpoint | Access |
|--------|----------|--------|
| GET | `/api/v1/schools` | Admin |
| POST | `/api/v1/schools` | Admin |
| PATCH | `/api/v1/schools/:id` | Admin / Own SchoolAdmin |
| POST | `/api/v1/users` | Admin (create SchoolAdmin) |

### Academic Management

| Method | Endpoint | Access |
|--------|----------|--------|
| POST | `/api/v1/courses` | SchoolAdmin |
| GET | `/api/v1/courses` | Scoped by role |
| POST | `/api/v1/batches` | SchoolAdmin |
| GET | `/api/v1/batches` | Scoped by role |
| GET | `/api/v1/batches/:id/students` | Approved students |

### Enrollment Workflow

| Method | Endpoint | Access |
|--------|----------|--------|
| POST | `/api/v1/enrollments` | Student |
| PATCH | `/api/v1/enrollments/:id/approve` | SchoolAdmin |
| PATCH | `/api/v1/enrollments/:id/reject` | SchoolAdmin |

---

## Authorization Strategy

Authorization is handled exclusively via **Pundit**:

- **Policies enforce**:
  - Role-based permissions
  - Ownership checks
  - Cross-school isolation

- **Policy scopes** ensure users only see data they are allowed to access

- **Controllers** contain no role logic, only:
  - `authorize`
  - `policy_scope`

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/nishkarshh013/school-management-api.git
cd school-management-api
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Database Setup

```bash
rails db:create
rails db:migrate
```

### 4. Start the Server

```bash
rails server
```

The API will be available at `http://localhost:3000`

---

## 🧪 Running Tests

This project includes comprehensive automated tests using **RSpec**.

### Types of Tests

- **Policy Specs**: Validate authorization rules and prevent cross-tenant access
- **Request Specs**: End-to-end API security, JWT authentication enforcement, correct HTTP status codes

### Run All Tests

```bash
bundle exec rspec
```

### Covered Scenarios

✅ Admin workflows  
✅ SchoolAdmin workflows  
✅ Student enrollment lifecycle  
✅ Unauthorized access prevention

---

## Design Decisions

1. **API-only architecture** to focus on backend correctness
2. **JWT authentication** for stateless security
3. **Minimal but complete feature set** aligned with assignment scope
4. **Lightweight, extensible progress tracking model**

---

## Submission Notes

- ✅ All required features are implemented
- ✅ "Good to Have" requirements are satisfied
- ✅ Test coverage validates core security and business flows
- ✅ Codebase is clean, modular, and production-ready

---

## Author

**Nishkarsh Sahu**
**nishkarshsahu007@gmail.com**
Ruby on Rails Developer

---

## License

This project is part of a backend engineering assignment.

---

## Contributing

This is an assignment project. For questions or feedback, please contact the author.

---

**Built with ❤️ using Ruby on Rails**