// routes/userRoutes.js
const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { checkToken } = require('../auth/token_validation');

router.post('/', userController.createUser);
router.get('/', checkToken, userController.getUsers);
router.get('/:id', checkToken, userController.getUserByUserId);
router.patch('/', checkToken, userController.updateUsers);
router.delete('/', checkToken, userController.deleteUser);

module.exports = router;
