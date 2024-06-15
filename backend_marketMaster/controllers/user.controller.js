const userService = require('../services/user.service');
const { genSaltSync, hashSync, compareSync } = require('bcrypt');
const { sign } = require('jsonwebtoken');


module.exports = {
    createUser: (req, res) => {
        const body = req.body;

        userService.getUserByEmail(body.email, (err, existingUser) => {
            if (err) {
                console.log(err);
                return res.status(500).json({
                    success: 0,
                    message: "Database connection error"
                });
            }

            if (existingUser) {
                return res.status(400).json({
                    success: 0,
                    message: "Email already exists"
                });
            }

            const salt = genSaltSync(10);
            body.password = hashSync(body.password, salt);
            userService.create(body, (err, results) => {
                if (err) {
                    console.log(err);
                    if (err.message === 'Email already exists') {
                        return res.status(400).json({
                            success: 0,
                            message: "Email already exists"
                        });
                    }
                    return res.status(500).json({
                        success: 0,
                        message: "Database connection error"
                    });
                }
                return res.status(200).json({
                    success: 1,
                    data: results
                });
            });
        });
    },
    getUserByUserId: (req, res) => {
        const id = req.params.id;
        userService.getUserByUserId(id, (err, user) => {
            if (err) {
                console.log(err);
                return res.status(500).json({
                    success: 0,
                    message: "Database error"
                });
            }
            if (!user) {
                return res.status(404).json({
                    success: 0,
                    message: "User not found"
                });
            }
            return res.status(200).json({
                success: 1,
                data: user
            });
        });
    },
    
    getUsers: (req, res) => {
        userService.getUsers((err, results) => {
            if (err) {
                console.log(err);
                return;
            }
            return res.json({
                success: 1,
                data: results
            });
        });
    },
    updateUser: (req, res) => {
        const { id } = req.params;
        const { name, email, password, roles, additionalData } = req.body;

        const updatedUserData = {
            id: id,
            name: name,
            email: email,
            password: password,
            roles: roles,
            additionalData: additionalData
        };

        userService.updateUsers(updatedUserData, (err, results) => {
            if (err) {
                console.log(err);
                return res.status(500).json({
                    success: 0,
                    message: "Failed to update user"
                });
            }
            return res.status(200).json({
                success: 1,
                message: "User updated successfully"
            });
        });
    },
    deleteUser: (req, res) => {
        const userId = req.params.id;

        userService.deleteUser(userId, (err, results) => {
            if (err) {
                console.log(err); // Log error for debugging
                return res.status(500).json({
                    success: 0,
                    message: "Failed to delete user and associated data"
                });
            }

            return res.status(200).json({
                success: 1,
                message: results.message || "User and associated data deleted successfully"
            });
        });
    },
    login: (req, res) => {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                success: 0,
                message: "Email and password are required"
            });
        }

        userService.getUserByEmail(email, (err, user) => {
            if (err) {
                console.log(err);
                return res.status(500).json({
                    success: 0,
                    message: "Database connection error"
                });
            }

            if (!user) {
                return res.status(404).json({
                    success: 0,
                    message: "Invalid email or password"
                });
            }

            // Compare hashed password
            const passwordMatch = compareSync(password, user.password);
            if (!passwordMatch) {
                return res.status(401).json({
                    success: 0,
                    message: "Invalid email or password"
                });
            }

            // Passwords match, generate token
            user.password = undefined; // Remove password from user object
            const jsontoken = sign({ result: user }, process.env.ENCRYPTED_TOKEN, {
                expiresIn: "1h"
            });

            return res.status(200).json({
                success: 1,
                message: "Login successfully",
                token: jsontoken
            });
        });
    }
};