
# MediScan

MediScan is a comprehensive healthcare application designed to facilitate the registration and diagnosis of patients, including features for doctors and an admin dashboard for managing the system.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Folder Structure](#folder-structure)
- [Requirements](#requirements)
- [Setup Instructions](#setup-instructions)
  - [Mobile App](#mobile-app)
  - [Backend API](#backend-api)
  - [Admin Dashboard](#admin-dashboard)
- [Running the Applications](#running-the-applications)
- [Environment Variables](#environment-variables)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Overview

MediScan consists of three main components:
1. **Mobile App**: Built with Flutter, it allows doctors to register patients and upload diagnostic images for analysis.
2. **Backend API**: Developed with Node.js and Express, it handles data management, including patient records and authentication.
3. **Admin Dashboard**: Created with Next.js, it provides an interface for administrators to manage patients and doctors.

## Features
- Patient registration with image upload
- Diagnosis identification using machine learning
- Admin panel for managing patient and doctor data
- Secure login for doctors and administrators

## Technologies Used
- **Mobile App**: Flutter, Dart
- **Backend API**: Node.js, Express, MongoDB
- **Admin Dashboard**: Next.js, React

## Folder Structure
```
mediSacn/
├── mobile/              # Flutter mobile app
├── backend/             # Node.js backend API
└── admin-dashboard/     # Next.js admin dashboard
```

## Requirements

### Mobile App
- Flutter SDK
- Dart

### Backend API
- Node.js
- MongoDB

### Admin Dashboard
- Node.js
- npm

## Setup Instructions

### Mobile App
1. Clone the repository:
   ```bash
   git clone https://github.com/joseph-birara/mediSacn.git
   cd mediSacn/mobile
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file and add your environment variables (if needed).

### Backend API
1. Navigate to the backend folder:
   ```bash
   cd mediSacn/backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file for environment variables.

### Admin Dashboard
1. Navigate to the admin dashboard folder:
   ```bash
   cd mediSacn/admin-dashboard
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file for environment variables.

## Running the Applications

### Mobile App
Run the following command:
```bash
flutter run
```

### Backend API
Start the server:
```bash
npm start
```

### Admin Dashboard
Start the development server:
```bash
npm run dev
```

## Environment Variables
Each component requires specific environment variables. Create `.env` files in each folder and include the necessary variables.

## Troubleshooting
- Ensure all dependencies are installed.
- Check for environment variable configurations.
- Refer to the individual component documentation for specific issues.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
```

This `README.md` provides an overall view of the MediScan project, including its structure, features, and setup instructions for each component. Feel free to modify any section to better reflect your project's specifics.