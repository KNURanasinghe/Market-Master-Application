// controllers/userController.js
const userService = require('../services/userServices');

const userController = {
    createUser: (req, res) => {
        const userData = req.body;
        const role = req.body.role; // Ensure role is passed from frontend

        userService.createUser(userData, role, (err, results) => {
            if (err) {
                console.error(err);
                if (err === "Email already exists") {
                    return res.status(400).json({
                        success: 0,
                        message: "Email already exists. Please use a different email."
                    });
                } else {
                    return res.status(500).json({
                        success: 0,
                        message: "Database connection error"
                    });
                }
            }
            res.status(201).json({
                success: 1,
                message: "User created successfully",
                data: results.insertId
            });
        });
    },

    getUsers: (req, res) => {
        userService.getUsers((err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).json({
                    success: 0,
                    message: "Database connection error"
                });
            }
            res.status(200).json({
                success: 1,
                data: results
            });
        });
    },

    getUserByUserId: (req, res) => {
        const userId = req.params.id;
        userService.getUserById(userId, (err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).json({
                    success: 0,
                    message: "Database connection error"
                });
            }
            if (results.length === 0) {
                return res.status(404).json({
                    success: 0,
                    message: "User not found"
                });
            }
            res.status(200).json({
                success: 1,
                data: results[0]
            });
        });
    },

    updateUsers: (req, res) => {
        const userId = req.body.user_id;
        const userData = req.body;
        userService.updateUser(userId, userData, (err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).json({
                    success: 0,
                    message: "Database connection error"
                });
            }
            res.status(200).json({
                success: 1,
                message: "User updated successfully"
            });
        });
    },

    deleteUser: (req, res) => {
        const userId = req.body.user_id;
        userService.deleteUser(userId, (err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).json({
                    success: 0,
                    message: "Database connection error"
                });
            }
            res.status(200).json({
                success: 1,
                message: "User deleted successfully"
            });
        });
    }
};

module.exports = userController;
