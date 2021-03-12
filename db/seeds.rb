first_user = User.find_or_create_by(name: 'User', email: 'user@example.com', password: '1234567890')
second_user = User.find_or_create_by(name: 'sample', email: 'sample@example.com', password: '1234567890')
group = Group.find_or_create_by(name: 'Lunch', owner: second_user)
group.members << second_user
group.bills.create(title: 'Last day party', amount: 190, author_id: second_user.id)