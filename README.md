# Access Control Demo

A comprehensive **Rails 8.0.2** application demonstrating **role-based access control** and **COPPA-compliant age verification** with a modern, responsive UI.

## 🎯 Key Features

- **Organization-Based Access Control**: Multi-tenant architecture with Admin/Moderator/Member roles
- **Age-Based Content Filtering**: Automatic content restriction by user age groups
- **COPPA Compliance**: Parental consent workflow for users under 13
- **Real-time Analytics**: Admin dashboard with member management
- **Email Testing**: Built-in email preview without SMTP setup
- **Modern UI**: Tailwind CSS with responsive design

## 🚀 Quick Setup

### Prerequisites
- **Ruby 3.2.3+** ([Install Guide](https://www.ruby-lang.org/en/downloads/))
- **Node.js 18+** (for Tailwind CSS)

### Installation

```bash
# Clone the repository
git clone <your-repository-url>
cd access_control_demo

# Automated setup (recommended)
./setup

# Start the application
rails server
```

**Visit**: http://localhost:3000

### Manual Setup (Alternative)

```bash
# Install dependencies
bundle install

# Setup database and seed demo data
rails db:create db:migrate db:seed

# Build CSS
rails tailwindcss:build

# Start server
rails server
```

## 👥 Demo Users

| Email | Password | Role | Age | Demo Purpose |
|-------|----------|------|-----|--------------|
| `admin@test.com` | `password123` | Admin | 35 | Full admin access + analytics |
| `moderator1@test.com` | `password123` | Moderator | 32 | Activity management permissions |
| `member1@test.com` | `password123` | Member | 28 | Standard member access |
| `child@test.com` | `password123` | Member | 10 | COPPA compliance demo |

## 🔍 Demo Flows

### 1. Admin Features
- **Login**: `admin@test.com` / `password123`
- **Admin Panel**: http://localhost:3000/admin/organizations
- **Features**: Member management, analytics, role updates

### 2. Age-Based Content Filtering
- **Adult User**: See 3 activities (ages 18+)
- **Child User**: Blocked by COPPA compliance
- **Content Filtering**: Activities filtered by user age

### 3. COPPA Compliance
- **Child Login**: Automatic redirect to consent screen
- **Parental Consent**: Beautiful waiting screen with 3-step process
- **Access Blocked**: Cannot reach dashboard until consent

### 4. Email Testing
- **Password Reset**: Emails open automatically in browser
- **Email Interface**: http://localhost:3000/letter_opener
- **No SMTP**: Works immediately without email configuration

## 🛠 Technology Stack

- **Backend**: Rails 8.0.2, Ruby 3.2.3+
- **Authentication**: Devise with custom role-based authorization
- **Database**: SQLite (development), PostgreSQL (production)
- **Frontend**: Tailwind CSS v4, Hotwire (Turbo + Stimulus)
- **Email**: LetterOpener Web (development)

## 📋 Database Information

- **Development**: SQLite (zero configuration!)
- **Production**: PostgreSQL for scalability
- **Benefits**: Self-contained, cross-platform, no external database needed

## 🎯 Business Problems Solved

### 1. Organization Access Control
- **Multi-tenant architecture** with role-based permissions
- **Real-time member management** with instant role updates
- **Organization analytics** showing member insights

### 2. Age-Compliant Content System
- **Automatic age verification** from date of birth
- **COPPA compliance** for users under 13
- **Content filtering** by age groups (5-12, 13-17, 18+)

## 🚀 Production Deployment

For production, set these environment variables:
```bash
DATABASE_URL="postgres://user:pass@host/db"
ACCESS_CONTROL_DEMO_DATABASE_PASSWORD="secure_password"
```

## 📞 Support

- **Setup Issues**: Run `./setup` again or check Ruby version
- **Demo Problems**: Use demo users listed above
- **Email Testing**: Visit `/letter_opener` for all emails

---

**Ready to demo!** 🎉 The application showcases modern Rails development with real-world business requirements.
