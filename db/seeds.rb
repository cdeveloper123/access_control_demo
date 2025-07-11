# Access Control Demo - Seed Data
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding Access Control Demo data..."

# Create test organization
organization = Organization.find_or_create_by!(name: "Tech Corp") do |org|
  org.description = "A technology company for demonstrating access control"
end

puts "✅ Organization created: #{organization.name}"

# Demo users for comprehensive testing across all roles
demo_users = [
  {
    name: "Admin User",
    email: "admin@test.com", 
    password: "password123",
    date_of_birth: 35.years.ago.to_date,
    role: "admin"
  },
  {
    name: "Senior Moderator",
    email: "moderator1@test.com",
    password: "password123", 
    date_of_birth: 32.years.ago.to_date,
    role: "moderator"
  },
  {
    name: "Young Moderator", 
    email: "moderator2@test.com",
    password: "password123",
    date_of_birth: 24.years.ago.to_date,
    role: "moderator"
  },
  {
    name: "Member One",
    email: "member1@test.com",
    password: "password123", 
    date_of_birth: 28.years.ago.to_date,
    role: "member"
  },
  {
    name: "Member Two", 
    email: "member2@test.com",
    password: "password123",
    date_of_birth: 22.years.ago.to_date,
    role: "member"
  },
  {
    name: "Child User",
    email: "child@test.com",
    password: "password123",
    date_of_birth: 10.years.ago.to_date,
    role: "member"
  }
]

# Create users and memberships
demo_users.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.name = user_data[:name]
    u.password = user_data[:password]
    u.password_confirmation = user_data[:password]
    u.date_of_birth = user_data[:date_of_birth]
  end
  
  # Create membership with role
  membership = Membership.find_or_create_by!(user: user, organization: organization) do |m|
    m.role = user_data[:role]
  end
  
  puts "✅ User created: #{user.email} (#{user.age} years old, #{membership.role})"
end

# Create parental consent for child user
child_user = User.find_by(email: "child@test.com")
if child_user && child_user.age < 13
  parental_consent = ParentalConsent.find_or_create_by!(user: child_user) do |pc|
    pc.parent_email = "parent@test.com"
  end
  puts "✅ Parental consent created for #{child_user.email} with parent email: #{parental_consent.parent_email}"
end

# Create age-appropriate participation areas
participation_areas = [
  # Children's activities (5-12)
  {
    title: "Kids Art Workshop",
    content: "Fun creative activities for young artists! Paint, draw, and create amazing artwork.",
    min_age: 5,
    max_age: 12
  },
  {
    title: "Story Time Reading",
    content: "Join us for exciting story time with age-appropriate books and interactive reading.",
    min_age: 5,
    max_age: 12
  },
  {
    title: "Building Blocks Challenge",
    content: "Construct amazing structures with building blocks and develop problem-solving skills.",
    min_age: 5,
    max_age: 12
  },
  
  # Teen activities (13-17)
  {
    title: "Teen Coding Bootcamp",
    content: "Learn programming fundamentals with Python and JavaScript. Build your first apps!",
    min_age: 13,
    max_age: 17
  },
  {
    title: "Youth Leadership Workshop",
    content: "Develop leadership skills, teamwork, and communication through interactive exercises.",
    min_age: 13,
    max_age: 17
  },
  {
    title: "Digital Media Creation",
    content: "Create videos, podcasts, and digital content using professional tools and techniques.",
    min_age: 13,
    max_age: 17
  },
  
  # Adult activities (18+)
  {
    title: "Professional Development Series",
    content: "Advanced career development workshops covering leadership, management, and strategy.",
    min_age: 18,
    max_age: 99
  },
  {
    title: "Investment & Finance Workshop",
    content: "Learn about investment strategies, financial planning, and retirement preparation.",
    min_age: 18,
    max_age: 99
  },
  {
    title: "Advanced Technology Summit",
    content: "Deep-dive into emerging technologies, AI, blockchain, and enterprise architecture.",
    min_age: 18,
    max_age: 99
  }
]

participation_areas.each do |area_data|
  area = ParticipationArea.find_or_create_by!(
    title: area_data[:title], 
    organization: organization
  ) do |pa|
    pa.content = area_data[:content]
    pa.min_age = area_data[:min_age]
    pa.max_age = area_data[:max_age]
  end
  
  puts "✅ Participation area created: #{area.title} (ages #{area.min_age}-#{area.max_age})"
end

puts ""
puts "🎉 Seeding complete!"
puts ""
puts "📋 Demo Users Created:"
puts "┌─────────────────┬──────────────┬─────┬───────────┬──────────────────────────────┐"
puts "│ Email           │ Password     │ Age │ Role      │ Status                       │"
puts "├─────────────────┼──────────────┼─────┼───────────┼──────────────────────────────┤"
puts "│ admin@test.com  │ password123  │ 35  │ admin     │ Full access + admin panel    │"
puts "│ moderator1@test │ password123  │ 32  │ moderator │ Can edit/delete activities   │"
puts "│ moderator2@test │ password123  │ 24  │ moderator │ Can edit/delete activities   │"
puts "│ member1@test.com│ password123  │ 28  │ member    │ Standard member access       │"
puts "│ member2@test.com│ password123  │ 22  │ member    │ Standard member access       │"  
puts "│ child@test.com  │ password123  │ 10  │ member    │ Blocked - needs consent      │"
puts "└─────────────────┴──────────────┴─────┴───────────┴──────────────────────────────┘"
puts ""
puts "🎯 Role Capabilities:"
puts "• 👑 Admin: Full access + admin panel + organization management"
puts "• ⚡ Moderator: Create, edit, delete activities + member permissions"  
puts "• 👤 Member: Create activities + view organization content"
puts ""
puts "🎯 Participation Areas by Age Group:"
puts "• Children (5-12): 3 activities"
puts "• Teens (13-17): 3 activities"  
puts "• Adults (18+): 3 activities"
puts ""
puts "🚀 Ready for testing! Visit http://localhost:3000"
