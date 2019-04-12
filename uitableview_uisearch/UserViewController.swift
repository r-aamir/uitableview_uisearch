import UIKit

        class UserViewController: UIViewController {
            
            private let user: User
            
            init(user: User) {
                self.user = user
                super.init(nibName: nil, bundle: nil)
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            override func viewDidLoad() {
                super.viewDidLoad()
                
                self.view.backgroundColor = .white
                
                let nameLabel = UILabel()
                nameLabel.text = self.user.firstName + " " + self.user.lastName
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(nameLabel)
                
                let emailLabel = UILabel()
                emailLabel.text = self.user.email
                emailLabel.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(emailLabel)
                
                let safeAreaGuide = self.view.safeAreaLayoutGuide
                NSLayoutConstraint.activate([
                    nameLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 16.0),
                    nameLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16.0),
                    nameLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 16.0),
                    
                    emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
                    emailLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16.0),
                    emailLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 16.0)
                ])
            }
            
        }
