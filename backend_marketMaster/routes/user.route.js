const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const { checkToken } = require('../auth/token.validation');

// Define routes
router.post("/", userController.createUser);
router.get("/", checkToken, userController.getUsers);
router.get("/:id", checkToken, userController.getUserByUserId);
router.patch("/:id", checkToken, userController.updateUser); // assuming you want to update by id
router.delete("/:id", checkToken, userController.deleteUser);
router.post("/login", userController.login);

module.exports = router;
