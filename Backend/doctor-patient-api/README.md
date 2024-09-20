
# MediScan - Backend API

The MediScan backend API is designed to support the MediScan mobile application, providing endpoints for doctor authentication and patient management.

## Table of Contents
- [Requirements](#requirements)
- [Setup Instructions](#setup-instructions)
- [API Endpoints](#api-endpoints)
- [Running the Application](#running-the-application)
- [Troubleshooting](#troubleshooting)

## Requirements
Before setting up the API, ensure you have the following installed:

- **Node.js**: [Download and Install Node.js](https://nodejs.org/)
- **npm** (Node Package Manager): Comes with Node.js
- **MongoDB**: Ensure MongoDB is installed and running or use a cloud-based service like MongoDB Atlas.

## Setup Instructions

### 1. Clone the Repository
Open your terminal and run:
```bash
git clone https://github.com/joseph-birara/mediSacn.git
```

### 2. Navigate to the Backend Folder
Change directory to the backend folder (adjust the path if necessary):
```bash
cd mediSacn/backend
```

### 3. Install Dependencies
Run the following command to install all necessary dependencies:
```bash
npm install
```

### 4. Configure Environment Variables
Create a `.env` file in the root directory and add your environment variables. A sample `.env` file might look like this:
```
PORT=3000
MONGODB_URI= yoor mongo db url 
JWT_SECRET=your_jwt_secret
```

## API Endpoints

### Authentication
- **POST** `/api/auth/login`
  - Request Body: `{ "username": "doctor_id", "password": "your_password" }`
  - Response: Returns a JWT token for authenticated requests.

### Patients
- **POST** `/api/patients`
  - Request Body: `{ "name": "patient_name", "age": patient_age, "diagnosis": "patient_diagnosis", "imageUrl": "url_to_image" }`
  - Response: Status 201 on success.

- **GET** `/api/patients`
  - Response: Returns a list of all patients.

## Running the Application

### 1. Start the Server
Run the following command to start the server:
```bash
npm start
```
The server will be running on `http://localhost:3000` (or the port you specified in your `.env` file).

### 2. Test the API
You can use tools like Postman or cURL to test the API endpoints.

## Troubleshooting

- **Port Already in Use**: If you encounter a port conflict, change the `PORT` variable in your `.env` file.
- **Database Connection Issues**: Ensure your MongoDB server is running and accessible. Check the `MONGODB_URI` in your `.env`.

For any further issues, please open an issue on the [GitHub repository](https://github.com/joseph-birara/mediSacn) or reach out for support.

## License
This project is licensed under the MIT License. See the [LICENSE](../LICENSE) file for more details.
```

This `README.md` provides a basic guide for setting up and running the backend API, including details on requirements, setup, API endpoints, and troubleshooting. Adjust any specific details to fit your project's needs.