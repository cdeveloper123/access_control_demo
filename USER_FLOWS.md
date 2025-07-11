# Access Control Demo - User Flows & Testing Guide

This document provides comprehensive testing instructions for all user types and features in the Access Control Demo application.

## 🚀 Quick Start

1. **Setup and Start the Application**:
   ```bash
   cd access_control_demo
   ./setup              # Installs deps, creates DB, seeds demo users
   bin/dev              # Starts Rails + Tailwind watcher
   ```

2. **Access Points**:
   - **Main Application**: http://localhost:3000
   - **Email Testing Interface**: http://localhost:3000/letter_opener
   - **Email Previews**: http://localhost:3000/rails/mailers

---

## 👥 Demo Users Overview

| User Type | Email | Password | Age | Role | Organization | Access Level |
|-----------|-------|----------|-----|------|--------------|--------------|
| **Admin** | `admin@test.com` | `password123` | 35 | Admin | Tech Corp | Full access + admin panel |
| **Member 1** | `member1@test.com` | `password123` | 30 | Member | Tech Corp | Standard member access |
| **Member 2** | `member2@test.com` | `password123` | 25 | Member | Tech Corp | Standard member access |
| **Member 3** | `member3@test.com` | `password123` | 20 | Member | Tech Corp | Standard member access |
| **Child** | `child@test.com` | `password123` | 10 | Member | Tech Corp | **Blocked** - needs parental consent |

---

## 🔍 User Flow Testing

### 1. Admin User Flow (`admin@test.com`)

**Purpose**: Demonstrate organization analytics, member management, and role-based permissions.

#### Step-by-Step Testing:

1. **Login as Admin**:
   - Go to: http://localhost:3000
   - Click "Login"
   - Email: `admin@test.com`
   - Password: `password123`
   - Click "Log in"

2. **Dashboard Access** ✅:
   - Should see: "Welcome, Admin User!"
   - Navigation shows: "Dashboard", "Admin Panel", "Profile", "Logout"
   - Notice **"Admin Panel"** link (only visible to admins)

3. **Age-Appropriate Content** ✅:
   - See 3 participation areas for adults (18+ content):
     - "Professional Development Series"
     - "Investment & Finance Workshop" 
     - "Advanced Technology Summit"
   - Content automatically filtered for 35-year-old user

4. **Admin Panel Access** ✅:
   - Click "Admin Panel" in navigation
   - Should redirect to: http://localhost:3000/admin/organizations

5. **Organization Analytics** ✅:
   - View analytics cards showing:
     - **Total Members**: 5
     - **Admins**: 1 
     - **Minors**: 1 (users under 18)
     - **Pending Consent**: 1 (child without consent)

6. **Member Management** ✅:
   - See member list table with:
     - User names and emails
     - **Age group badges**: "Adult", "Child"
     - **Role dropdowns**: Change member roles inline
     - **Consent status indicators**: Shows consent requirements

7. **Role Update Testing** ✅:
   - Try changing member1@test.com from "member" to "moderator"
   - Should see inline update without page reload
   - Analytics should update automatically

8. **Permissions Verification** ✅:
   - Full dashboard access ✅
   - Admin panel access ✅
   - Member management ✅
   - Analytics visibility ✅

---

### 2. Regular Member Flow (`member1@test.com`)

**Purpose**: Demonstrate standard member permissions and age-based content filtering.

#### Step-by-Step Testing:

1. **Logout Previous User** (if needed):
   - Click "Logout" to clear session

2. **Login as Member**:
   - Email: `member1@test.com`
   - Password: `password123`

3. **Dashboard Access** ✅:
   - Should see: "Welcome, Member One!"
   - Navigation shows: "Dashboard", "Profile", "Logout"
   - **Notice**: No "Admin Panel" link (hidden from non-admins)

4. **Age-Appropriate Content** ✅:
   - See same 3 adult participation areas (18+ content):
     - "Professional Development Series"
     - "Investment & Finance Workshop"
     - "Advanced Technology Summit"
   - Content filtered for 30-year-old user

5. **Admin Access Restriction** ✅:
   - Try manually visiting: http://localhost:3000/admin/organizations
   - Should be redirected to dashboard with error message
   - Error: "Access denied. Admins only."

6. **Profile Management** ✅:
   - Click "Profile" 
   - Can edit name, email, password
   - Can delete account with confirmation

7. **Permissions Verification** ✅:
   - Dashboard access ✅
   - Age-appropriate content ✅
   - No admin panel access ✅
   - Profile management ✅

---

### 3. Child User Flow (`child@test.com`)

**Purpose**: Demonstrate COPPA compliance, age verification, and parental consent requirements.

#### Step-by-Step Testing:

1. **Login as Child**:
   - Email: `child@test.com`
   - Password: `password123`

2. **Age Verification Trigger** ✅:
   - Automatic age check runs after login
   - User age (10) is under 13 → triggers COPPA compliance

3. **Consent Redirect** ✅:
   - Should be automatically redirected to: http://localhost:3000/waiting_for_consent
   - **Never reaches dashboard** due to age restriction

4. **Waiting for Consent Screen** ✅:
   - Beautiful waiting page with:
     - Clear explanation of COPPA requirements
     - Message about parental consent needed
     - Contact information for parents
     - Professional, child-friendly design

5. **Access Restriction Testing** ✅:
   - Try manually visiting: http://localhost:3000/dashboard
   - Should be redirected back to waiting screen
   - No access to any main application features

6. **Content Filtering (if consent granted)** ✅:
   - *Note*: In real scenario with consent, would see:
     - 3 children's activities (5-12 age range):
       - "Kids Art Workshop"
       - "Story Time Reading" 
       - "Building Blocks Challenge"

7. **Permissions Verification** ✅:
   - No dashboard access ✅
   - Redirected to consent screen ✅
   - COPPA compliance enforced ✅
   - Beautiful waiting experience ✅

---

### 4. Age-Based Content Testing

**Purpose**: Demonstrate how content filters by different age groups.

#### Test Different User Ages:

1. **Adult Content (18+)** - Login as `member1@test.com` (age 30):
   - See: "Professional Development Series"
   - See: "Investment & Finance Workshop"
   - See: "Advanced Technology Summit"

2. **Teen Content (13-17)** - *Test with different age*:
   - Would see: "Teen Coding Bootcamp"
   - Would see: "Youth Leadership Workshop"
   - Would see: "Digital Media Creation"

3. **Children Content (5-12)** - Child user (age 10):
   - Would see: "Kids Art Workshop"
   - Would see: "Story Time Reading"
   - Would see: "Building Blocks Challenge"
   - *Note*: Blocked by consent requirement

4. **Content Filtering Logic** ✅:
   - ParticipationArea.for_age(user.age) filters correctly
   - Age ranges: 5-12, 13-17, 18-99
   - Automatic filtering based on user age

---

### 5. Email Testing Flow

**Purpose**: Demonstrate email functionality without SMTP setup.

#### Email Interface Testing:

1. **Access Email Interface**:
   - Visit: http://localhost:3000/letter_opener
   - See LetterOpener Web interface

2. **Password Reset Email Testing**:
   - Go to: http://localhost:3000/users/password/new
   - Enter any email address (e.g., `admin@test.com`)
   - Click "Send me reset password instructions"
   - **Result**: Email automatically opens in new browser tab

3. **Email Content Verification** ✅:
   - Email opens with full styling and formatting
   - Contains reset password link
   - Links are clickable and functional
   - No SMTP configuration required

4. **Email Preview Testing**:
   - Visit: http://localhost:3000/rails/mailers/devise_mailer/reset_password_instructions
   - See preview of reset password email template
   - Test other email templates:
     - Confirmation: `/confirmation_instructions`
     - Unlock: `/unlock_instructions`

5. **LetterOpener Interface** ✅:
   - View all sent emails in web interface
   - See email history and content
   - Perfect for development testing

---

## 🎯 Feature Demonstration Checklist

### Organization-Based Access Control ✅

- [x] **Multi-tenant architecture** with organizations
- [x] **Role-based permissions** (member/moderator/admin)
- [x] **Member management** with role updates
- [x] **Organization analytics** with insights
- [x] **Access control enforcement** for admin features

### Age-Based Participation System ✅

- [x] **COPPA compliance** with parental consent
- [x] **Age verification** during login
- [x] **Content filtering** by age groups (5-12, 13-17, 18+)
- [x] **Automatic access control** for minors
- [x] **Beautiful consent waiting screens**

### Technical Features ✅

- [x] **Email testing** without SMTP (LetterOpener Web)
- [x] **Beautiful responsive UI** with Tailwind CSS
- [x] **Secure authentication** with Devise
- [x] **Database seeding** with demo users
- [x] **Comprehensive error handling**

---

## 🛠️ Development & Testing Commands

### Database Management:
```bash
rails db:seed                 # Load demo users
rails db:reset                # Reset and re-seed
rails console                 # Test models manually
```

### Testing Scenarios:
```bash
# Test user creation
User.create!(name: "Test", email: "test@example.com", age: 25, password: "password", organization: Organization.first)

# Test age filtering
ParticipationArea.for_age(10)   # Children's content
ParticipationArea.for_age(15)   # Teen content  
ParticipationArea.for_age(25)   # Adult content

# Test role permissions
user = User.find_by(email: "admin@test.com")
membership = user.memberships.first
membership.admin?               # true
```

### Email Testing:
```bash
# Trigger test emails
rails runner "Devise::Mailer.reset_password_instructions(User.first, 'token').deliver_now"

# View email interface
open http://localhost:3000/letter_opener
```

---

## 🎪 Demo Script (15-minute presentation)

### Opening (2 min):
1. **Show application overview**: http://localhost:3000
2. **Explain purpose**: Organization-based access control + Age-based participation
3. **Overview demo users** and their different access levels

### Admin Features (5 min):
1. **Login as admin@test.com**
2. **Show admin panel** with analytics
3. **Demonstrate member management** 
4. **Update member roles** inline
5. **Highlight organization insights**

### Age-Based Access (5 min):
1. **Login as child@test.com** → Show consent requirement
2. **Login as member1@test.com** → Show adult content
3. **Explain content filtering** by age groups
4. **Show COPPA compliance** features

### Email & Technical (3 min):
1. **Trigger password reset** → Show auto-opening email
2. **Visit LetterOpener interface** → Show email management
3. **Highlight no-SMTP setup** for easy testing
4. **Show responsive UI** and beautiful design

---

## 🚀 Quick Testing Scenarios

### 30-Second Tests:

1. **Admin Access**: Login admin@test.com → Click "Admin Panel" → See analytics
2. **Child Blocking**: Login child@test.com → See consent screen (no dashboard access)
3. **Member Access**: Login member1@test.com → See dashboard (no admin panel)
4. **Email Testing**: Go to "Forgot Password" → Enter email → See auto-opening email
5. **Content Filtering**: Compare participation areas between different user ages

### 5-Minute Full Demo:
1. Admin panel walkthrough
2. Member management demonstration  
3. Child consent requirement
4. Email functionality
5. Age-based content filtering

---

## 📞 Support & Troubleshooting

### Common Issues:

1. **Users not seeded**: Run `rails db:seed`
2. **Styling issues**: Run `rails tailwindcss:build` and restart with `bin/dev`
3. **Email not opening**: Check LetterOpener setup in `config/environments/development.rb`
4. **Database issues**: Run `rails db:reset` to recreate and re-seed

### Verification Commands:
```bash
# Check users exist
rails runner "puts User.all.pluck(:email)"

# Check participation areas
rails runner "puts ParticipationArea.all.pluck(:title, :min_age, :max_age)"

# Check admin access
rails runner "puts User.joins(:memberships).where(memberships: {role: 'admin'}).pluck(:email)"
```

---

**🎉 Ready to demo!** This application showcases a complete access control system with organization management, age-based participation, COPPA compliance, and beautiful user experiences. 