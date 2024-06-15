const { verify } = require('jsonwebtoken');

module.exports = {
    checkToken: (req, res, next) => {
        let token = req.get("authorization");
        if (token) {
            token = token.slice(7); // Remove Bearer from token string
            verify(token, process.env.ENCRYPTED_TOKEN, (err, decoded) => {
                if (err) {
                    console.log(err);
                    return res.status(401).json({
                        success: 0,
                        message: "Invalid token"
                    });
                } else {
                    // Token is valid, continue to the next middleware
                    next();
                }
            });
        } else {
            return res.status(403).json({
                success: 0,
                message: "Access denied! Token not provided"
            });
        }
    }
};
