// services/userService.js
const pool = require('../config/database');
const bcrypt = require('bcrypt');


const userService = {
    createUser: (userData, role, callback) => {
       

        // Generate a salt and hash the password
        bcrypt.hash(userData.password, 10, (err, hashedPassword) => {
            if (err) {
                return callback(err);
            }
            // Replace plain text password with hashed password
            userData.password = hashedPassword;

            // Check if email already exists
            pool.query('SELECT * FROM Users WHERE email = ?', userData.email, (err, results) => {
                if (err) {
                    return callback(err);
                }
                if (results.length > 0) {
                    // Email already exists, return error
                    return callback("Email already exists");
                }

                // Email does not exist, proceed with insertion
                pool.getConnection((err, connection) => {
                    if (err) {
                        return callback(err);
                    }

                    connection.beginTransaction((err) => {
                        if (err) {
                            connection.release();
                            return callback(err);
                        }

                        // Insert into Users table
                        connection.query('INSERT INTO Users SET ?', userData, (err, userResult) => {
                            if (err) {
                                connection.rollback(() => {
                                    connection.release();
                                    return callback(err);
                                });
                            }

                            const userId = userResult.insertId;

                            // Determine which role-specific table to insert into
                            let insertQuery;
                            let roleData;

                            switch (role) {
                                case 'farmer':
                                    insertQuery = 'INSERT INTO Farmers SET ?';
                                    roleData = {
                                        user_id: userId,
                                        home_address: userData.home_address,
                                        nic_no: userData.nic_no,
                                        nic_image: userData.nic_image
                                    };
                                    break;
                                case 'seller':
                                    insertQuery = 'INSERT INTO Sellers SET ?';
                                    roleData = {
                                        user_id: userId,
                                        shop_name: userData.shop_name,
                                        shop_address: userData.shop_address,
                                        shop_registration_no: userData.shop_registration_no,
                                        goods_type: userData.goods_type,
                                        br_image: userData.br_image
                                    };
                                    break;
                                default:
                                    // Customer signup (default behavior)
                                    connection.commit((err) => {
                                        if (err) {
                                            connection.rollback(() => {
                                                connection.release();
                                                return callback(err);
                                            });
                                        }
                                        connection.release();
                                        return callback(null, { insertId: userId });
                                    });
                                    return;
                            }

                            // Insert into respective role table (Farmer or Seller)
                            connection.query(insertQuery, roleData, (err) => {
                                if (err) {
                                    connection.rollback(() => {
                                        connection.release();
                                        return callback(err);
                                    });
                                }

                                connection.commit((err) => {
                                    if (err) {
                                        connection.rollback(() => {
                                            connection.release();
                                            return callback(err);
                                        });
                                    }
                                    connection.release();
                                    return callback(null, { insertId: userId });
                                });
                            });
                        });
                    });
                });
            });
        });
    },


    getUsers: (callback) => {
        pool.query('SELECT * FROM Users', callback);
    },
    getUserById: (userId, callback) => {
        pool.query('SELECT * FROM Users WHERE user_id = ?', userId, callback);
    },
    updateUser: (userId, userData, callback) => {
        pool.query('UPDATE Users SET ? WHERE user_id = ?', [userData, userId], callback);
    },
    deleteUser: (userId, callback) => {
        pool.query('DELETE FROM Users WHERE user_id = ?', userId, callback);
    }
};

module.exports = userService;
