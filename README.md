# Task Management System

The Task Management System is a command-line application that allows users to change the status of task , postpone the task , get next task , change the priority of task and perform various operations on task management system.

## Installation

Follow these steps to set up the Task Management System on your local machine:

1. Clone the repository:
- git clone https://github.com/lakshay42jain/Task-Management.git
- cd Task-Management

2. Install dependencies:
- bundle install

4. Configure environment variables:
- Create a `.env` file in the project root directory.
- Add the necessary environment variables for your database configuration. For example:
  ```
  DATABASE_USER=your_database_username
  DATABASE_PASSWORD=your_database_password
  DATABASE_HOST=your_database_port
  ```

5. Run the application:
- ruby main.rb


## Usage

Upon running the application, you will be presented with a login screen. Use your username and password to log in as a user or admin.

### User Features

- Show All Tasks 
- Postpone the Task
- Change the priority
- Update the Status

### Admin Features

- Assign tasks to users
- Delete tasks 
- Show All Tasks of All users

## Dependencies

- Ruby
- PostgreSQL
- Bundler
- RSpec
- SimpleCov
- pg (PostgreSQL gem)
- dotenv (gem for managing environment variables)

## Contributing

Contributions to the Task Management System are welcome! If you find any issues or have suggestions for improvements, please feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
