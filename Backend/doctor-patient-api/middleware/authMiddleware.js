const jwt = require('jsonwebtoken');

const auth = (req, res, next) => {
  // Get the Authorization header
  const authHeader = req.header('Authorization');
  
  // Check if the header is missing
  if (!authHeader) {
    console.log("not token")
    return res.status(401).json({ message: 'No token, authorization denied' });
  }
  
  // Remove 'Bearer ' from the token if present
  const token = authHeader.replace('Bearer ', '');
  
  try {
    // Verify the token using jwt
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next(); // Pass the request to the next middleware or route handler
  } catch (error) {
    console.log("invalid token")
    res.status(401).json({ message: 'Invalid token' });
  }
};

module.exports = auth;
